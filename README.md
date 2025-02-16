# Darsena

Repository principale per il progetto Darsena, contenente vari submoduli.

## Setup Iniziale

### 1. Configurazione Git

Prima di iniziare, configurare git con le proprie credenziali:

```bash
git config --global user.name "Il Tuo Nome"
git config --global user.email "tua.email@esempio.com"
```

### 2. Configurazione SSH

Per lavorare con il repository, è necessario configurare una chiave SSH:

1. Generare una nuova chiave SSH:
```bash
ssh-keygen -t ed25519 -C "tua.email@esempio.com"
```

2. Aggiungere la chiave all'agent SSH:
```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

3. Copiare la chiave pubblica:
```bash
cat ~/.ssh/id_ed25519.pub
```

4. Aggiungere la stessa chiave sia su GitHub che su GitLab (se necessario) attraverso le impostazioni del proprio profilo.

### 3. Clonare il Repository

Per clonare il repository con tutti i suoi submoduli:

```bash
git clone --recursive git@github.com:grammaton/darsena.git
cd darsena
```

Se hai già clonato il repository senza i submoduli:
```bash
cd darsena
git submodule init
git submodule update
```

## Gestione dei Branch

### Nomenclatura dei Branch
Per ogni sviluppatore, viene creato un branch dedicato nel formato:
```
darsena-xyz
```
dove `xyz` sono le iniziali dello sviluppatore.

### Script di Utilità

Il progetto include due script di utilità per la gestione dei branch e dei commit.

#### 1. Check Branches Script

Questo script (`check-branches.sh`) verifica e crea il branch personale in tutti i repository:

```bash
chmod +x check-branches.sh
./check-branches.sh xyz  # dove xyz sono le tue iniziali
```

Lo script:
- Controlla il repository principale e tutti i submoduli
- Crea il branch se non esiste
- Pusha il nuovo branch al remote
- Fornisce feedback dettagliato sulle operazioni

#### 2. Recursive Commit Script

Questo script (`recursive-commit.sh`) gestisce i commit in modo ricorsivo su tutti i repository modificati:

```bash
chmod +x recursive-commit.sh
./recursive-commit.sh xyz "messaggio di commit" [--push]
```

Caratteristiche:
- Gestione interattiva dei file non tracciati
- Gestione selettiva delle modifiche
- Supporto per commit ricorsivi nei submoduli
- Push automatico opzionale

##### Opzioni per File Non Tracciati
- `Y` (default): aggiunge il file
- `n`: salta il file
- `q`: interrompe il processo

##### Opzioni per File Modificati
- `Y` (default): aggiunge tutte le modifiche
- `n`: salta tutte le modifiche
- `s`: modalità selettiva (file per file)

## Best Practices

1. **Branch Personale**:
   - Lavorare sempre sul proprio branch personale
   - Mantenere il branch sincronizzato con main/master
   - Non committare direttamente su main/master

2. **Submoduli**:
   - Verificare sempre di essere nel branch corretto in ogni submodulo
   - Utilizzare gli script forniti per gestire le modifiche
   - Committare prima le modifiche nei submoduli, poi nel repository principale

3. **Commit**:
   - Usare messaggi di commit descrittivi
   - Verificare lo stato delle modifiche prima del commit
   - Controllare che tutti i file necessari siano inclusi

## Struttura del Repository

```
darsena/
├── submodule1/
├── submodule2/
├── ...
├── check-branches.sh
└── recursive-commit.sh
```

## Contribuire

1. Clona il repository con tutti i submoduli
2. Crea il tuo branch personale usando `check-branches.sh`
3. Fai le tue modifiche
4. Usa `recursive-commit.sh` per committare le modifiche
5. Crea una Pull Request quando le modifiche sono pronte per il review

## Manutenzione

Per mantenere il repository aggiornato:

```bash
# Aggiorna il repository principale e i submoduli
git pull
git submodule update --init --recursive --remote

# Verifica lo stato dei submoduli
git submodule status
```

## Sistema di Compilazione

Il progetto include un sistema di build basato su make per la gestione di documenti LaTeX e la generazione di PDF.

### Prerequisiti

1. **LaTeX**:
   - Una distribuzione TeX Live completa
   - Il pacchetto `gs-adonis` (fornito in `_layouts`)
   - Pandoc per la conversione Markdown → LaTeX

2. **Utilities**:
   - Make
   - MD5 (per il sistema di caching)

### Struttura dei Progetti

Ogni progetto nell'`arsenale` deve seguire questa struttura:
```
progetto/
├── md/         # File sorgente in Markdown
├── tex/        # File LaTeX aggiuntivi
└── img/        # Immagini e altri asset
```

### Comandi Make

1. **Compilazione completa**:
```bash
make
```

2. **Compilazione selettiva**:
```bash
ACTIVE_DIRS="progetto1 progetto2" make pdf
```

3. **Compilazione singolo progetto**:
```bash
ACTIVE_DIRS="progetto" make pdf
```

4. **Pulizia**:
```bash
make clean
```

### Sistema di Cache

Il sistema utilizza un meccanismo di cache per evitare ricompilazioni non necessarie:
- Monitora modifiche ai file sorgente
- Traccia le dipendenze tra file
- Ricompila solo quando necessario

### File di Output

I PDF generati vengono salvati in:
```
tipografia/
└── nome-progetto.pdf
```

I file temporanei vengono gestiti in:
```
_latex_temp/
```

### Aggiungere un Nuovo Progetto

1. Creare la struttura base:
```bash
make init PROJECT=nome-progetto
```

2. Aggiungere i file sorgente in `md/`
3. Opzionalmente, aggiungere file LaTeX in `tex/` e immagini in `img/`

### Best Practices

1. **Organizzazione**:
   - Mantenere i file Markdown in `md/` ordinati numericamente
   - Usare nomi descrittivi per i file
   - Documentare dipendenze speciali nel README del progetto

2. **Compilazione**:
   - Usare la compilazione selettiva per progetti grandi
   - Verificare i log in caso di errori
   - Mantenere pulita la directory con `make clean`

3. **Gestione Assets**:
   - Ottimizzare le immagini prima dell'inclusione
   - Usare formati appropriati (PNG per diagrammi, JPG per foto)
   - Mantenere una struttura coerente in `img/`

## Supporto

Per problemi o domande, aprire una issue su GitHub: [grammaton/darsena/issues](https://github.com/grammaton/darsena/issues)

## armatore

Per creare una nuova nave dell'arsenale [parti da qui], poi aggiungi il nuovo
elemento come `submodule` in `arsenale`.

[parti da qui]: https://github.com/grammaton/bucintoro/generate
