#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Minimal Ascon AEAD decryption (Ascon-128 by default), no debug, no prints.
Exports:
    ascon_decrypt(key: bytes, nonce: bytes, associateddata: bytes, ciphertext: bytes, variant="Ascon-128") -> Optional[bytes]
Returns plaintext or None if tag verification fails.
"""

from typing import List, Optional

# ===== Public API =====

def ascon_decrypt(key: bytes,
                  nonce: bytes,
                  associateddata: bytes,
                  ciphertext: bytes,
                  variant: str = "Ascon-128") -> Optional[bytes]:
    """
    Decrypts ct||tag. Returns plaintext (bytes) or None if tag check fails.
    """
    assert variant in ["Ascon-128", "Ascon-128a", "Ascon-80pq"]
    assert len(nonce) == 16 and (len(key) == 16 or (len(key) == 20 and variant == "Ascon-80pq"))
    assert len(ciphertext) >= 16

    # Parameters
    kbits = len(key) * 8
    a = 12
    b = 8 if variant == "Ascon-128a" else 6
    rate = 16 if variant == "Ascon-128a" else 8

    # Split CT and TAG
    ct, tag_in = ciphertext[:-16], ciphertext[-16:]

    # State
    S = [0, 0, 0, 0, 0]

    # Phases
    _ascon_initialize(S, kbits, rate, a, b, key, nonce)
    _ascon_process_associated_data(S, b, rate, associateddata)
    plaintext = _ascon_process_ciphertext(S, b, rate, ct)
    tag = _ascon_finalize(S, rate, a, key)

    return plaintext if tag == tag_in else None


# ===== Internal helpers (no debug/prints) =====

def _ascon_initialize(S: List[int], kbits: int, rate: int, a: int, b: int,
                      key: bytes, nonce: bytes) -> None:
    # IV || 0..0 || K || N
    pad_zeros = bytes(20 - len(key))  # 4 bytes (params) + pad to 20
    iv = bytes([kbits, rate * 8, a, b]) + pad_zeros + key + nonce
    S[0], S[1], S[2], S[3], S[4] = _bytes_to_state(iv)

    _ascon_permutation(S, a)

    # S ^= (0..0 || K) aligned to 40 bytes -> 5 words
    zkey = _bytes_to_state(bytes(40 - len(key)) + key)
    S[0] ^= zkey[0]; S[1] ^= zkey[1]; S[2] ^= zkey[2]; S[3] ^= zkey[3]; S[4] ^= zkey[4]


def _ascon_process_associated_data(S: List[int], b: int, rate: int, A: bytes) -> None:
    if len(A) > 0:
        # Pad A with 0x80 then zeros to a multiple of rate
        a_zeros = rate - (len(A) % rate) - 1
        A_padded = A + bytes([0x80]) + bytes(a_zeros)

        for block in range(0, len(A_padded), rate):
            S[0] ^= _bytes_to_u64(A_padded[block:block+8])
            if rate == 16:
                S[1] ^= _bytes_to_u64(A_padded[block+8:block+16])
            _ascon_permutation(S, b)

    # Domain separation
    S[4] ^= 1


def _ascon_process_ciphertext(S: List[int], b: int, rate: int, C: bytes) -> bytes:
    # Split into full blocks + last partial
    c_lastlen = len(C) % rate
    C_padded = C + bytes(rate - c_lastlen)
    P = bytearray()

    # Full blocks
    for block in range(0, len(C_padded) - rate, rate):
        if rate == 8:
            Ci = _bytes_to_u64(C_padded[block:block+8])
            P += _u64_to_bytes(S[0] ^ Ci)
            S[0] = Ci
        else:
            Ci0 = _bytes_to_u64(C_padded[block:block+8])
            Ci1 = _bytes_to_u64(C_padded[block+8:block+16])
            P += _u64_to_bytes(S[0] ^ Ci0) + _u64_to_bytes(S[1] ^ Ci1)
            S[0] = Ci0; S[1] = Ci1
        _ascon_permutation(S, b)

    # Last block (partial)
    block = len(C_padded) - rate
    if rate == 8:
        c_padding1 = (0x80 << (rate - c_lastlen - 1) * 8)
        c_mask = (0xFFFFFFFFFFFFFFFF >> (c_lastlen * 8))
        Ci = _bytes_to_u64(C_padded[block:block+8])
        P += _u64_to_bytes(Ci ^ S[0])[:c_lastlen]
        S[0] = Ci ^ (S[0] & c_mask) ^ c_padding1
    else:
        c_lastlen_word = c_lastlen % 8
        c_padding1 = (0x80 << (8 - c_lastlen_word - 1) * 8)
        c_mask = (0xFFFFFFFFFFFFFFFF >> (c_lastlen_word * 8))
        Ci0 = _bytes_to_u64(C_padded[block:block+8])
        Ci1 = _bytes_to_u64(C_padded[block+8:block+16])
        P += (_u64_to_bytes(S[0] ^ Ci0) + _u64_to_bytes(S[1] ^ Ci1))[:c_lastlen]
        if c_lastlen < 8:
            S[0] = Ci0 ^ (S[0] & c_mask) ^ c_padding1
        else:
            S[0] = Ci0
            S[1] = Ci1 ^ (S[1] & c_mask) ^ c_padding1

    return bytes(P)


def _ascon_finalize(S: List[int], rate: int, a: int, key: bytes) -> bytes:
    # Inject key
    S[rate // 8 + 0] ^= _bytes_to_u64(key[0:8])
    S[rate // 8 + 1] ^= _bytes_to_u64(key[8:16])
    S[rate // 8 + 2] ^= _bytes_to_u64(key[16:])  # works for 16 or 20-byte key (zero-extended)

    _ascon_permutation(S, a)

    S[3] ^= _bytes_to_u64(key[-16:-8])
    S[4] ^= _bytes_to_u64(key[-8:])
    return _u64_to_bytes(S[3]) + _u64_to_bytes(S[4])


def _ascon_permutation(S: List[int], rounds: int) -> None:
    assert rounds <= 12
    for r in range(12 - rounds, 12):
        # Add round constants
        S[2] ^= (0xF0 - r * 0x10 + r * 0x01)

        # Substitution layer
        S[0] ^= S[4]; S[4] ^= S[3]; S[2] ^= S[1]
        T = [((~S[i]) & 0xFFFFFFFFFFFFFFFF) & S[(i + 1) % 5] for i in range(5)]
        for i in range(5):
            S[i] ^= T[(i + 1) % 5]
        S[1] ^= S[0]; S[0] ^= S[4]; S[3] ^= S[2]
        S[2] ^= 0xFFFFFFFFFFFFFFFF

        # Linear diffusion
        S[0] ^= _rotr(S[0], 19) ^ _rotr(S[0], 28)
        S[1] ^= _rotr(S[1], 61) ^ _rotr(S[1], 39)
        S[2] ^= _rotr(S[2],  1) ^ _rotr(S[2],  6)
        S[3] ^= _rotr(S[3], 10) ^ _rotr(S[3], 17)
        S[4] ^= _rotr(S[4],  7) ^ _rotr(S[4], 41)


# ===== Byte/bit utils =====

def _bytes_to_u64(b: bytes) -> int:
    b = b[:8].rjust(8, b"\x00")
    return int.from_bytes(b, "big", signed=False)

def _u64_to_bytes(x: int) -> bytes:
    return x.to_bytes(8, "big", signed=False)

def _bytes_to_state(b: bytes) -> List[int]:
    # Expect 40 bytes (5 * 8). If longer, slice; if shorter, pad on the left.
    b = b[-40:].rjust(40, b"\x00")
    return [ _bytes_to_u64(b[8*i:8*(i+1)]) for i in range(5) ]

def _rotr(val: int, r: int) -> int:
    r &= 63
    return ((val >> r) | ((val & ((1 << r) - 1)) << (64 - r))) & 0xFFFFFFFFFFFFFFFF
