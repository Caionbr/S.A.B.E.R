`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Project:     S.A.B.E.R. - Secure AI-Based Encrypted ECG Rhythm-Monitoring
// Engineer:    Murilo MULLER
// File:        encryptor_system.sv
// Module:      encryptor_system
// Version:     v1.1
//
// Description:
//   Top-level wrapper of the encryption pipeline. It connects:
//
//     - Front-end sampling/packing: data_reg (byte-to-64b) and a PT/AD MUX
//     - Control FSMs: fsm_SABER (system orchestrator) and drive_ascon (ASCON flow)
//     - Crypto core: ASCON (init, AD absorption, PT encryption, finalisation, tag)
//     - Key/AD/Nonce registers + nonce generator
//     - Frame packer: data_reg (23×64b CT + 128b TAG + 64b AD + 128b NONCE)
//
//   Outputs a 1792-bit flattened frame and a 1-cycle valid pulse when the
//   frame is complete. A Wi-Fi send strobe is also provided.
//
// Competition Context:
//   Developed as part of the AMD Open Hardware University Design Competition 2025.
//
// License: MIT License
//////////////////////////////////////////////////////////////////////////////////

module encryptor_system (
    // External inputs
    input  logic          go_i,          // start trigger
    input  logic [7:0]    data_i,        // 1-byte ECG signal
    

    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 reset_i RST",
       X_INTERFACE_PARAMETER = "POLARITY ACTIVE_HIGH" *)
    input  logic          reset_i,       // asynchronous reset (active-high)

    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clock_i CLK",
       X_INTERFACE_PARAMETER = "FREQ_HZ 100000000, PHASE 0.000, INSERT_VIP 0, ASSOCIATED_RESET reset_i, ASSOCIATED_BUSIF frame_if" *)
    input  logic          clock_i,       // system clock

    (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 frame_if DATA" *)
    output logic [1791:0] data_o,        // flattened 56×32b frame

    output logic          data_valid_o,  // 1-cycle pulse when the frame is ready
    output logic          send_data_o    // send request via Wi-Fi (from fsm_SABER)
);


// ========= Fixed Key and Associated Data constants =========================
  localparam logic [127:0] KEY_CONST = 128'h8A55_114D_1CB6_A9A2_BE26_3D4D_7AEC_AAFF; 
  localparam logic [63:0]  AD_CONST  = 64'h4120_746F_2042_8000; // "A to B", if you wish to modify the Associated Data, keep the 0x8000 padding

// ========= System internal signals =========================================
// fsm_SABER → registers/generators
  logic init_registers_s;       // clears PT/KEY/AD/NONCE
  logic clear_cipher_reg_s;     // clears the 1792-bit packer
  logic init_nonce_counter_s;   // resets the internal nonce counter
  logic en_nonce_counter_s;     // enables nonce counting
  logic load_registers_s;       // loads AD/KEY/NONCE into the registers
  logic add_s;                  // sampling pulse for data_reg (1 cycle)

// fsm_SABER → drive_ascon
  logic start_s;                // triggers the ASCON driver

// drive_ascon ↔ ascon
  logic init_ascon_s;           // triggers ASCON initialization phase
  logic associate_data_s;       // indicates ASCON AD phase
  logic data_valid_s;           // strobe to send AD/PT to ASCON
  logic finalisation_s;         // indicates ASCON finalisation phase (last block)
  logic end_initialisation_s;   // indicates the end of the initialization phase
  logic end_associate_s;        // indicates the end of the AD phase
  logic cipher_valid_s;         // indicates that the encrypted value is available
  logic end_cipher_s;           // indicates the end of encryption
  logic end_tag_s;              // indicates TAG availability

// drive_ascon → PT/AD selection
  logic sel_data_reg_s;         // 0 = AD path, 1 = Plaintext path

// drive_ascon → packer enables
  logic en_cipher_reg_s;        // registers each encrypted block
  logic en_tag_cipher_reg_s;    // registers the TAG
  logic en_ad_cipher_reg_s;     // registers the AD
  logic en_nonce_cipher_reg_s;  // registers the NONCE

// ascon → data to the packer
  logic [63:0]   cipher_s;      // encrypted block
  logic [127:0]  tag_s;         // TAG

// data_reg → drive_ascon
  logic          data_reg_valid_s;  // indicates availability of each Plaintext block

// data_reg/ad_reg → MUX inputs
  logic [63:0]   plain_text_s;      // Plaintext
  logic [63:0]   ad_reg_s;          // AD

// key_reg/nonce_reg → ascon
  logic [127:0]  key_reg_s;         // KEY
  logic [127:0]  nonce_reg_s;       // NONCE

// nonce_gen → nonce_reg
  logic [127:0]  nonce_gen_s;       // generated NONCE value


// ========= fsm_SABER - system orchestrator =================================
  fsm_SABER fsm_SABER_0 (
      .clock_i               (clock_i),
      .reset_i               (reset_i),
      .go_i                  (go_i),
      .data_valid_i          (data_valid_o),

      .add_o                 (add_s),
      .init_registers_o      (init_registers_s),
      .init_nonce_counter_o  (init_nonce_counter_s),
      .en_nonce_counter_o    (en_nonce_counter_s),
      .load_registers_o      (load_registers_s),      
      .clear_cipher_reg_o    (clear_cipher_reg_s),
      .start_o               (start_s),
      .send_data_o           (send_data_o)  
  );

// ========= drive_ascon - ASCON flow controller =============================
  drive_ascon drive_ascon_0 (
      .clock_i               (clock_i),
      .reset_i               (reset_i),
      .start_i               (start_s),
      .end_initialisation_i  (end_initialisation_s),
      .end_associate_i       (end_associate_s),
      .data_reg_valid_i      (data_reg_valid_s),
      .cipher_valid_i        (cipher_valid_s),
      .end_cipher_i          (end_cipher_s),
      .end_tag_i             (end_tag_s),

      .init_ascon_o          (init_ascon_s),
      .associate_data_o      (associate_data_s),
      .data_valid_o          (data_valid_s),
      .sel_data_reg_o        (sel_data_reg_s),
      .en_cipher_reg_o       (en_cipher_reg_s),  
      .finalisation_o        (finalisation_s),
      .en_tag_cipher_reg_o   (en_tag_cipher_reg_s),
      .en_ad_cipher_reg_o    (en_ad_cipher_reg_s),
      .en_nonce_cipher_reg_o (en_nonce_cipher_reg_s)
  );

// ========= ascon - cryptographic core ======================================
  ascon ascon_0 (
      .clock_i               (clock_i),
      .reset_i               (reset_i),
      .init_i                (init_ascon_s),
      .associate_data_i      (associate_data_s),
      .finalisation_i        (finalisation_s),
      .data_i                (sel_data_reg_s ? plain_text_s : ad_reg_s),
      .data_valid_i          (data_valid_s),
      .key_i                 (key_reg_s),
      .nonce_i               (nonce_reg_s),

      .end_associate_o       (end_associate_s),
      .cipher_o              (cipher_s),
      .cipher_valid_o        (cipher_valid_s),
      .tag_o                 (tag_s),
      .end_tag_o             (end_tag_s),
      .end_initialisation_o  (end_initialisation_s),
      .end_cipher_o          (end_cipher_s)
  );

// ========= data_reg - byte→64b sliding window ==============================
  data_reg data_reg_0 (
      .clock_i               (clock_i),
      .reset_i               (reset_i),
      .clear_i               (init_registers_s),   // clear at system initialization
      .add_i                 (add_s),              // sampling pulse
      .data_i                (data_i),

      .data_reg_valid_o      (data_reg_valid_s),
      .plain_text_o          (plain_text_s)
  );

// ========= ad_reg / key_reg - static AD & KEY ===============================
  ad_reg ad_reg_0 (
      .clock_i               (clock_i),
      .reset_i               (reset_i),
      .clear_i               (init_registers_s),
      .load_i                (load_registers_s),
      .data_i                (AD_CONST),
      .data_o                (ad_reg_s)
  );

  key_reg key_reg_0 (
      .clock_i               (clock_i),
      .reset_i               (reset_i),
      .clear_i               (init_registers_s),
      .load_i                (load_registers_s),
      .data_i                (KEY_CONST),
      .data_o                (key_reg_s)
  );

// ========= nonce path: generator → register =================================
  nonce_gen nonce_gen_0 (
      .clock_i               (clock_i),
      .reset_i               (reset_i),
      .clear_i               (init_nonce_counter_s),
      .enable_i              (en_nonce_counter_s),
      .nonce_o               (nonce_gen_s)
  );

  nonce_reg nonce_reg_0 (
      .clock_i               (clock_i),
      .reset_i               (reset_i),
      .clear_i               (init_registers_s),
      .load_i                (load_registers_s),
      .data_i                (nonce_gen_s),
      .data_o                (nonce_reg_s)
  );

  // ========= cipher_reg - frame builder (active-high reset) =================
  cipher_reg cipher_reg_0 (
      .clock_i               (clock_i),
      .reset_i               (reset_i),
      .clear_i               (clear_cipher_reg_s),
      .en_cipher_i           (en_cipher_reg_s),
      .cipher_i              (cipher_s),
      .en_tag_i              (en_tag_cipher_reg_s),
      .tag_i                 (tag_s),
      .en_ad_i               (en_ad_cipher_reg_s),
      .ad_i                  (ad_reg_s),
      .en_nonce_i            (en_nonce_cipher_reg_s),
      .nonce_i               (nonce_reg_s),

      .data_valid_o          (data_valid_o),
      .data_o                (data_o)
  );

endmodule
