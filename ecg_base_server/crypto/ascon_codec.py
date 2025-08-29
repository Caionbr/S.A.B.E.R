# crypto/ascon_codec.py  — Python 3.9+
# Layout do frame (fixo):
#   NONCE(16) | AD(8, termina com 80 00) | TAG(16) | CIPH_REV(184 = 23×8B em c22..c0)
#
# Ajustes necessários antes da decriptação:
#   - Reordenar CIPH_REV para c0..c22
#   - Remover os últimos 3 bytes do bloco c22  -> CT final = 181 bytes
#   - Remover o padding do AD (descartar os 2 últimos bytes 80 00) -> AD efetivo = 6 bytes
#
# Chama ascon_ref.ascon_decrypt(key, nonce, ad_6B, ct_181B || tag)

from typing import Optional, Tuple
from .ascon_ref import ascon_decrypt  # módulo "limpo" com apenas a decriptação

NONCE_LEN = 16   # bytes
AAD_LEN   = 8    # bytes (no fio; efetivo será 6)
TAG_LEN   = 16   # bytes
CT_LEN    = 184  # bytes (= 23 * 8) no fio
TOTAL_LEN = NONCE_LEN + AAD_LEN + TAG_LEN + CT_LEN  # 224

class FrameFormatError(Exception):
    pass

def _slice_frame(frame: bytes) -> Tuple[bytes, bytes, bytes, bytes]:
    """Valida tamanho e fatia o frame no layout fixo."""
    if not isinstance(frame, (bytes, bytearray)):
        raise FrameFormatError("frame deve ser bytes/bytearray")
    if len(frame) != TOTAL_LEN:
        raise FrameFormatError(f"tamanho inválido do frame: {len(frame)} (esperado {TOTAL_LEN})")
    p = 0
    nonce = frame[p:p+NONCE_LEN]; p += NONCE_LEN
    aad   = frame[p:p+AAD_LEN];   p += AAD_LEN
    tag   = frame[p:p+TAG_LEN];   p += TAG_LEN
    cipher_rev = frame[p:p+CT_LEN]  # 184B, ordem c22..c0
    return nonce, aad, tag, cipher_rev

def _reverse_blocks_8(cipher_rev: bytes) -> bytes:
    """Recebe 184B em blocos de 8B (c22..c0) e devolve c0..c22 (184B)."""
    if len(cipher_rev) != CT_LEN:
        raise FrameFormatError("cipher_rev com tamanho inválido")
    blocks = [cipher_rev[i:i+8] for i in range(0, CT_LEN, 8)]
    if len(blocks) != 23 or any(len(b) != 8 for b in blocks):
        raise FrameFormatError("cipher_rev não está alinhado em blocos de 8B")
    blocks.reverse()  # agora c0..c22
    return b"".join(blocks)

def _ct_181_from_c0_to_c22(ct_184_c0_to_c22: bytes) -> bytes:
    """Remove os 3 bytes finais do último bloco (c22) -> 181B totais."""
    if len(ct_184_c0_to_c22) != CT_LEN:
        raise FrameFormatError("ct_184 com tamanho inválido")
    # c0..c22 (184B): cortar os 3 últimos bytes -> 181B
    return ct_184_c0_to_c22[:-3]

def _aad_effective_6(aad_8: bytes) -> bytes:
    """Descarta os 2 últimos bytes (padding 80 00) -> 6B."""
    if len(aad_8) != AAD_LEN:
        raise FrameFormatError("aad com tamanho inválido")
    # Opcional: validar padding: assert aad_8[-2:] == b"\x80\x00"
    return aad_8[:6]

def decrypt_fpga_frame(
    key: bytes,
    frame: bytes,
    *,
    variant: str = "Ascon-128",
    drop_hw_padding: bool = False,  # mantidos por compat
    try_both_orders: bool = False,  # mantidos por compat
) -> Optional[bytes]:
    """
    Decripta um frame no formato do fio (ver topo do arquivo).
    Retorna plaintext com 181 bytes se a tag bater; senão, None.
    """
    nonce, aad_8, tag, cipher_rev = _slice_frame(frame)

    # 1) Reordenar c22..c0 -> c0..c22
    ct_184_c0_to_c22 = _reverse_blocks_8(cipher_rev)

    # 2) Remover os 3 bytes finais (c22 truncado)
    ct_181 = _ct_181_from_c0_to_c22(ct_184_c0_to_c22)

    # 3) Remover padding do AD (80 00) -> 6B
    aad_6 = _aad_effective_6(aad_8)

    # 4) Decriptar
    plaintext = ascon_decrypt(
        key=key,
        nonce=nonce,
        associateddata=aad_6,
        ciphertext=ct_181 + tag,
        variant=variant,
    )
    return plaintext
