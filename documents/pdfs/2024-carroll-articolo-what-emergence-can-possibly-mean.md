---
layout: document
title: What Emergence Can Possibly Mean
author:
  name: Sean M.
  surname: Carroll
category: Articolo
date: 2024-09-15
tags: [emergence, philosophy, physics]
pdf_path: 2024-carroll-articolo-what-emergence-can-possibly-mean.pdf
parent: Biblioteca
---

## Abstract
[p.1] Consideriamo l'emergenza dalla prospettiva della dinamica: stati di un sistema che evolvono nel tempo. Ci concentriamo sul ruolo della decomposizione degli interi nelle loro parti, e tentiamo di caratterizzare le relazioni tra livelli senza riferimento al fatto che le proprietà di alto livello siano "nuove" o "inattese." Offriamo una classificazione di diverse varietà di emergenza, con e senza nuovi elementi ontologici ai livelli superiori.

## Concetti Chiave

### Definizione di Emergenza {#def-emergence}
[p.1] Tutti concordano che l'emergenza sia importante, ma non c'è accordo su cosa debba significare questa parola. L'idea di base è che, quando un sistema può essere pensato come un composito di molte parti, possono esistere proprietà o comportamenti nuovi del sistema composito che non sono facilmente prevedibili considerando le proprietà e i comportamenti delle parti stesse.

### Dinamica ed Evoluzione Temporale {#dynamics}
[p.4-5] La legge di evoluzione rilevante è Markoviana, cioè l'evoluzione futura dipende solo dallo stato corrente. Gli stati evolvono nel tempo secondo qualche legge evolutiva:

$$w(t + \Delta t) = E_\Omega[w(t)]$$

### Decomposizione e Sottosistemi {#decomposition}

[p.9] Modelleremo una decomposizione in sottosistemi come un prodotto cartesiano. Formalmente, per la nostra teoria di basso livello α abbiamo una mappa iniettiva dallo spazio degli stati A in un prodotto cartesiano di I spazi A_i di stati dei sottosistemi a_i:

$$D_\alpha: A \rightarrow \prod_{i=1}^I A_i$$

così che gli stati individuali sono scritti come I-tuple:

$$D_\alpha: a \rightarrow (a_1, a_2, a_3, ..., a_I)$$

#### Evoluzione dei Sottosistemi {#subsystem-evolution}
[p.9-10] L'evoluzione di ogni sottosistema nella teoria micro può essere scritta come:

$$a_i(t + \Delta t) = E^{(self)}_{\alpha,i}[a_i(t)] + E^{(int)}_{\alpha,i}[a_i(t), \{a_j(t)\}]$$

dove il primo termine rappresenta l'evoluzione autonoma del sottosistema e il secondo termine rappresenta le interazioni con altri sottosistemi.

Per l'emergenza di Tipo-2 [p.14], questo si modifica in:

$$a_i(t + \Delta t) = E^{(self)}_{\alpha,i}[a_i(t)] + E^{(int)}_{\alpha,i}[a_i(t), \{a_j(t)\}] + \sigma_i[a(t)]E^{(nl)}_{\alpha,i}[a_i(t), \{a'_j(t)\}]$$

dove il termine aggiuntivo include effetti non locali filtrati dalla funzione $\sigma_i$.

#### Requisiti per l'Individualità dei Sottosistemi {#subsystem-requirements}
[p.10] L'idea dell'individualità dei sottosistemi si riduce a due requisiti:
1. Possibilità di spegnere le interazioni con altri sottosistemi, sia "spostandoli molto lontano" sia ponendo alcune costanti di accoppiamento a zero
2. Quando queste interazioni sono spente, i dati nello stato del sottosistema a_i(t) sono sufficienti a determinare l'evoluzione di quel sottosistema

## Classificazione dell'Emergenza {#classification}

### Tipo-0 (senza caratteristiche) {#type-0}
[p.6] Una mappa molti-a-uno da una micro-teoria senza sottosistemi a una macro-teoria, che commuta con l'evoluzione temporale. È caratterizzata dal diagramma commutativo che collega evoluzione temporale e mappa di emergenza.

**Esempio**: transizione dalla meccanica quantistica alla meccanica classica

### Tipo-1 (locale) {#type-1}
[p.11-13] Emergenza di Tipo-0 con la condizione aggiuntiva che i sottosistemi nella teoria macro consistono di collezioni localizzate di sottosistemi nella teoria micro. Si distingue in:

- **Tipo-1a (diretta)**: quando la mappa di emergenza è algoritmicamente semplice
- **Tipo-1b (incomprimibile)**: quando la mappa di emergenza è algoritmicamente complessa

### Tipo-2 (non locale) {#type-2}
[p.14-15] Emergenza di Tipo-0 dove le teorie micro e macro hanno decomposizioni in sottosistemi locali, ma dove la teoria macro non rispetta la nozione di località ereditata dalla teoria micro. Questo può accadere in due modi:
1. La teoria macro coinvolge gradi di libertà definiti globalmente, in termini di molte parti disperse
2. Le entità macro interagiscono tra loro in modi che appaiono non locali dal punto di vista micro

### Tipo-3 (aumentata) {#type-3}
[p.17-18] Una teoria macro che presenta sia variabili costruite dagli stati della teoria micro, sia nuove variabili indipendenti dagli stati micro, che diventano dinamicamente rilevanti solo in certe situazioni macroscopiche. Questo tipo corrisponde all'emergenza forte tradizionale, in contrasto con i tipi 0-2 che rappresentano varie forme di emergenza debole.

## Glossario {#glossary}
- **emergence** → emergenza
- **downward causation** → causazione verso il basso
- **subsystem** → sottosistema
- **decomposition** → decomposizione
- **locality** → località
- **state space** → spazio degli stati
- **algorithmic complexity** → complessità algoritmica
