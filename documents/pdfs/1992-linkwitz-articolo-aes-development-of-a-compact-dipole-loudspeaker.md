---
layout: document
title: Sviluppo di un Diffusore Dipolo Compatto
author:
  name: Siegfried
  surname: Linkwitz
category: articolo AES
date: 1992-10-01
tags: [acustica, diffusori, dipolo, audio]
pdf_path: 1992-linkwitz-articolo-aes-development-of-a-compact-dipole-loudspeaker.pdf
parent: Biblioteca
---

## Abstract
[p.2] È stato sviluppato un sistema di diffusori dipolo di dimensioni relativamente contenute utilizzando driver conici convenzionali per ottenere spostamenti di volume sufficientemente ampi. Il sistema a 3 vie presenta caratteristiche direzionali di tipo dipolo nella gamma di frequenze da 20 Hz a 1000 Hz per ridurre l'interazione con l'ambiente di ascolto. Sono stati studiati gli effetti della forma del pannello frontale sul pattern di radiazione. Sono stati utilizzati crossover attivi ed equalizzazione specifica per dipolo per ottenere una risposta in frequenza lineare.

## Concetti Fondamentali

### Principi Acustici del Dipolo {#dipolo-base}
[p.2-3] Un dipolo idealizzato può essere modellato come una sorgente puntiforme acustica positiva e una negativa, distanziate di una lunghezza D. La risposta all'impulso p(t) del dipolo è:

$$p(t) = 1 - e^{-sT}$$

dove s = σ + jω come frequenza complessa. La risposta in frequenza F(ω) si determina sostituendo s con jω:

$$F(ω) = |1 - e^{-jωT}|$$
$$F(f) = |1 - cos(2πfT) + j sin(2πfT)|$$
$$F(f) = \sqrt{2(1 - cos(2πfT))}$$

### Pattern di Risposta Polare {#pattern-polare}
[p.2-3] Il pattern polare si ricava sostituendo D con D(cosα) per angoli fuori asse α:

$$F(f) = \sqrt{2(1 - cos(2πfD(cosα)/v))}$$

dove v = 340 m/s è la velocità del suono. La risposta fuori asse diminuisce con cosα ed è:
- -3 dB per α = 45°
- -6 dB per α = 60°

Come mostrato in Fig. 3, il pattern a figura di otto a bassa frequenza si modifica in lobi multipli alle alte frequenze.

### Parametri Critici di Progetto {#parametri-progetto}
[p.3] Parametri chiave per il progetto del dipolo:

1. Frequenza di picco (fpeak):
   $$f_{peak} = 0.5 v/D$$
   dove D è la differenza di percorso tra radiazione frontale e posteriore

2. Frequenza di guadagno unitario (fequal):
   $$f_{equal} = 0.17 v/D$$
   Questo permette il confronto del SPL del dipolo con un monopolo di pari intensità

### Risposta in Potenza {#risposta-potenza}
[p.4] Un dipolo irradia 1/3 della potenza acustica di un monopolo con lo stesso livello di pressione sonora sull'asse. Questo comporta:
- 4.8 dB in meno di potenza nel campo riverberante
- Distanza critica 3 volte maggiore rispetto al monopolo
- Maggior rapporto tra suono diretto e riverberato

Come illustrato in Fig. 5, la risposta in potenza del dipolo rispetto al diametro del pistone mostra caratteristiche peculiari.

## Metodologia di Progetto

### Selezione dei Driver {#selezione-driver}
[p.4-5] Il sistema utilizza:
- Due driver da 300 mm per canale per frequenze fino a 100 Hz
- Due driver da 200 mm per la gamma 100 Hz - 1.7 kHz
- Un tweeter a cupola da 25 mm sopra 1.7 kHz

Il dimensionamento dei driver è basato sul calcolo dello spostamento di volume richiesto:
1. Per il midrange (driver da 200 mm):
   - Lunghezza percorso D = 0.25 m dà fequal = 230 Hz
   - Richiede spostamento di volume 3.3x vs box chiuso
   - 200 mm fornisce ~4x area cono rispetto unità di riferimento 100 mm

2. Per woofer (driver da 300 mm):
   - D = 0.4 m dà fequal = 145 Hz
   - Richiede escursione 3x a 50 Hz vs box chiuso
   - Scelti due driver per canale come compromesso

La configurazione finale è mostrata in Fig. 1.

### Reti di Crossover {#crossover}
[p.9] Caratteristiche:
- Risposta del filtro acustico attivo 24 dB/oct
- Passa-basso a 100 Hz per woofer
- Passa-basso a 1.7 kHz per midrange
- Compensazione delle risonanze dei driver
- Compensazione del ritardo di 42 mm del tweeter

I circuiti sono illustrati nelle Fig. 17-18.

### Costruzione Meccanica {#meccanica}
[p.10-11] Elementi chiave del progetto:
- Dimensioni del cabinet e area superficiale minimizzate
- Materiale smorzante sulle superfici
- Montaggio quasi-elastico dei driver midrange
- Costruzione in compensato da 13 mm per woofer
- Rapporto di massa cono:cabinet ≈ 120g:20kg (-44 dB)

### Risposta in Ambiente {#ambiente}
Come mostrato in Fig. 32, l'interazione con l'ambiente è caratterizzata da:
- Riflessioni primarie
- Risonanze della stanza
- Campo riverberante

## Glossario {#glossario}
- **dipolo** → sorgente radiante bidirezionale con polarità opposta
- **monopolo** → sorgente puntiforme omnidirezionale
- **baffle** → pannello di montaggio per i driver
- **SPL** → Livello di Pressione Sonora
- **crossover** → rete di filtri selettivi in frequenza
- **direttività** → pattern di radiazione angolare
- **riverberazione** → persistenza del suono in uno spazio
