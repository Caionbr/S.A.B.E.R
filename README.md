EN:
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
![S.A.B.E.R. Architecture](figs/arquitetura.png)  
*Figure 1: General architecture of the S.A.B.E.R. system.*  

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

FR:
# S.A.B.E.R. — Secure AI-Based Encrypted ECG Rhythm-monitoring

## Présentation
L’intégration des dispositifs médicaux avec les technologies de l’Internet des Objets (IoT) s’est considérablement développée au fil des années. Par conséquent, la protection des données personnelles acquises et transmises est devenue un élément essentiel dans la conception de tels systèmes.  

La plupart de ces dispositifs visent à assurer une surveillance continue des patients, les signaux électrocardiographiques (ECG) étant parmi les plus analysés, permettant par exemple la détection précoce de maladies cardiovasculaires. Cependant, la transmission sur des réseaux non sécurisés compromet la confidentialité et la sécurité de ces informations sensibles.  

Dans ce contexte, nous présentons **S.A.B.E.R. (Secure AI-Based Encrypted ECG Rhythm-monitoring)**, un système embarqué conçu pour acquérir, traiter, chiffrer et transmettre des signaux ECG en temps réel.  

## Architecture du système
L’architecture proposée est basée sur une plateforme **FPGA** et intègre trois étapes principales :  
1. **Pré-traitement de l’ECG** : segmentation du signal brut en trames de longueur fixe.  
2. **Pipeline cryptographique (ASCON-128)** : implémenté directement en matériel afin de protéger le flux de données en temps réel.  
3. **Interface de communication** : responsable de l’empaquetage de la sortie chiffrée et de sa transmission vers des dispositifs externes.  

L’ensemble du système est coordonné par des **machines à états finis (FSM)** qui contrôlent l’interaction entre les modules d’acquisition, de cryptographie et de communication.  

### Schéma général
![Architecture S.A.B.E.R.](figs/arquitetura.png)  
*Figure 1 : Architecture générale du système S.A.B.E.R.*  

Le signal ECG est d’abord acquis par un convertisseur analogique-numérique (ADC) et stocké dans un registre de données, qui organise les échantillons en mots de 64 bits.  
Un multiplexeur sélectionne entre les données du signal et les données associées, qui, avec la clé de 128 bits et le **nonce** généré en interne, sont fournies au cœur cryptographique **ASCON-128** implémenté en matériel.  

La sortie chiffrée est stockée dans un registre dédié puis transmise via une **interface de communication** à un serveur externe.  

---

## Serveur de visualisation
Le système inclut un **serveur web** développé en Python (Flask + SocketIO), permettant la visualisation en temps réel du signal ECG et la consultation des résultats enregistrés.  

### Fonctionnalités
- **GO/STOP** :  
  - `GO` lance l’affichage en temps réel.  
  - `STOP` arrête et enregistre le dernier signal capturé.  
- **Résultat ECG** : un bouton affiche l’ECG enregistré ci-dessous, avec défilement complet du signal sauvegardé.  
- **Visualisation épurée** : seul le signal ECG est affiché, sans éléments graphiques superflus.  
- **Serveur modulaire** : inclut éventuellement une analyse par intelligence artificielle pour classifier la normalité des battements à l’aide de modèles entraînés.  

---

## Validation
Le système a été validé à l’aide de **testbenches, de simulations matérielles et d’une implémentation réelle sur FPGA**.  
Les résultats montrent que S.A.B.E.R. est capable de traiter et de chiffrer des trames ECG de manière fiable, avec une **faible latence** et une **utilisation efficace des ressources logiques**, tout en respectant les standards de la cryptographie légère.  

---

## Conclusion
Ce travail démontre la faisabilité de combiner le traitement en temps réel des signaux biomédicaux avec la cryptographie embarquée directement dans le matériel.  
Le prototype développé représente une avancée vers des dispositifs médicaux IoT plus **sécurisés, économes en énergie et évolutifs**, contribuant à la fois à la **protection des données des patients** et au développement de technologies numériques de santé fiables.  