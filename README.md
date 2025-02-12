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

## Supporto

Per problemi o domande, aprire una issue su GitHub: [grammaton/darsena/issues](https://github.com/grammaton/darsena/issues)

## armatore

Per creare una nuova nave dell'arsenale [parti da qui], poi aggiungi il nuovo
elemento come `submodule` in `arsenale`.


[parti da qui]: https://github.com/grammaton/bucintoro/generate
