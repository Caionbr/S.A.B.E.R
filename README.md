# S.A.B.E.R. — Secure AI-Based Encrypted ECG Rhythm-monitoring

## Overview
The integration of medical devices with Internet of Things (IoT) technologies has grown significantly over the years. As a result, the protection of personal data acquired and transmitted has become a fundamental requirement in the design of such systems.  

Most of these devices aim at continuous patient monitoring, with electrocardiogram (ECG) signals being among the most analyzed, enabling, for example, the early detection of cardiovascular diseases. However, transmission over unsecured networks compromises the privacy and security of such sensitive information.  

In this context, we present **S.A.B.E.R. (Secure AI-Based Encrypted ECG Rhythm-monitoring)**, an embedded system designed to acquire, process, encrypt, and transmit ECG signals in real time.  

## System Architecture
The proposed architecture is based on an **FPGA** platform and integrates three main stages:  
1. **ECG pre-processing**: segmentation of the raw signal into fixed-length frames.  
2. **Cryptographic pipeline (ASCON-128)**: implemented directly in hardware to protect the data stream in real time.  
3. **Communication interface**: responsible for packing the encrypted output and transmitting it to external devices.  

The entire system is coordinated by **finite state machines (FSMs)**, which control the interaction between acquisition, cryptography, and communication modules.  

### General Diagram

The ECG signal is first acquired by an analog-to-digital converter (ADC) and stored in a data register, which organizes the samples into 64-bit words.  
A multiplexer selects between the signal data and the associated data, which together with the 128-bit key and the internally generated nonce are fed into the hardware-implemented **ASCON-128** cryptographic core.  

The encrypted output is stored in a dedicated register and then transmitted through a **communication interface** to an external server.  

---

## Visualization Server
The system includes a **web server** developed in Python (Flask + SocketIO), allowing real-time visualization of the ECG signal and consultation of stored results.  

### Features
- **GO/STOP**:  
  - `GO` starts the real-time display.  
  - `STOP` stops and saves the last captured signal.  
- **ECG Result**: a button that displays the stored ECG below, with full scrolling of the saved signal.  
- **Clean visualization**: only the ECG signal is shown, without additional graphical artifacts.  
- **Modular server**: optionally includes artificial intelligence analysis to classify the normality of heartbeats using trained models.  

---

## Validation
The system was validated through **testbenches, hardware simulations, and real FPGA implementation**.  
The results show that S.A.B.E.R. can process and encrypt ECG frames reliably, with **low latency** and **efficient hardware resource utilization**, while complying with lightweight cryptography standards.  

---

## Conclusion
This work demonstrates the feasibility of combining real-time biomedical signal processing with embedded hardware cryptography.  
The developed prototype represents a step toward more **secure, energy-efficient, and scalable** IoT medical devices, contributing both to **patient data protection** and to the advancement of trustworthy digital healthcare technologies.  
