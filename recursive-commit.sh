#!/bin/bash

# Controlla se sono stati forniti le iniziali e il messaggio di commit
if [ $# -lt 2 ]; then
    echo "Uso: $0 xyz \"messaggio di commit\" [--push]"
    echo "  xyz: le tue iniziali"
    echo "  messaggio di commit: il messaggio da usare per i commit"
    echo "  --push: opzionale, se specificato pusha automaticamente le modifiche"
    exit 1
fi

INITIALS=$1
COMMIT_MSG=$2
BRANCH_NAME="darsena-$INITIALS"
AUTO_PUSH=0

if [ "$3" = "--push" ]; then
    AUTO_PUSH=1
fi

# Colori per output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Funzione per verificare se ci sono modifiche nel repository
check_for_changes() {
    git status --porcelain | grep -q "."
    return $?
}

# Funzione per verificare se siamo nel branch corretto
check_branch() {
    local current_branch=$(git symbolic-ref --short HEAD)
    if [ "$current_branch" != "$BRANCH_NAME" ]; then
        echo -e "${RED}⚠️  Repository $(pwd) non è nel branch $BRANCH_NAME (è in $current_branch)${NC}"
        echo -n "Vuoi passare al branch $BRANCH_NAME? [y/N] "
        read answer
        if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
            git checkout $BRANCH_NAME
        else
            return 1
        fi
    fi
    return 0
}

# Funzione per gestire i file non tracciati
handle_untracked_files() {
    local untracked_files=$(git ls-files --others --exclude-standard)
    if [ ! -z "$untracked_files" ]; then
        echo -e "${BLUE}📄 File non tracciati trovati:${NC}"
        echo "$untracked_files" | while read -r file; do
            echo -e "${YELLOW}    New: $file${NC}"
            echo -n "Vuoi aggiungere questo file? [Y/n/q(quit)] "
            read answer
            case $answer in
                [nN])
                    echo "File saltato"
                    ;;
                [qQ])
                    echo "Operazione interrotta"
                    return 1
                    ;;
                *)
                    git add "$file"
                    echo -e "${GREEN}✓ File aggiunto${NC}"
                    ;;
            esac
        done
    fi
    return 0
}

# Funzione per gestire i file modificati
handle_modified_files() {
    local modified_files=$(git status --porcelain)
    if [ ! -z "$modified_files" ]; then
        echo -e "${BLUE}📝 File modificati:${NC}"
        echo "$modified_files" | while read -r line; do
            status="${line:0:2}"
            file="${line:3}"
            case $status in
                "M "*)
                    echo -e "${YELLOW}    Modified: $file${NC}"
                    ;;
                " M"*)
                    echo -e "${YELLOW}    Modified (not staged): $file${NC}"
                    ;;
                "??"*)
                    continue  # Già gestiti da handle_untracked_files
                    ;;
                "D "*)
                    echo -e "${RED}    Deleted: $file${NC}"
                    ;;
                *)
                    echo -e "${BLUE}    $status: $file${NC}"
                    ;;
            esac
        done
        
        echo -n "Vuoi aggiungere tutte queste modifiche? [Y/n/s(selettivo)] "
        read answer
        case $answer in
            [nN])
                return 1
                ;;
            [sS])
                echo "$modified_files" | while read -r line; do
                    status="${line:0:2}"
                    file="${line:3}"
                    if [ "$status" != "??" ]; then  # Salta i file non tracciati
                        echo -n "Aggiungere $file? [Y/n] "
                        read file_answer
                        if [ "$file_answer" != "n" ] && [ "$file_answer" != "N" ]; then
                            git add "$file"
                            echo -e "${GREEN}✓ File aggiunto${NC}"
                        else
                            echo "File saltato"
                        fi
                    fi
                done
                ;;
            *)
                git add -u
                echo -e "${GREEN}✓ Tutte le modifiche aggiunte${NC}"
                ;;
        esac
    fi
    return 0
}

# Funzione per gestire commit in un repository
handle_repository() {
    local repo_path=$1
    local repo_name=$2
    
    cd "$repo_path"
    
    # Verifica il branch
    if ! check_branch; then
        cd - > /dev/null
        return 1
    fi
    
    # Controlla se ci sono modifiche
    if check_for_changes; then
        echo -e "${YELLOW}🔍 Analisi modifiche in $repo_name${NC}"
        
        # Gestisci prima i file non tracciati
        if ! handle_untracked_files; then
            cd - > /dev/null
            return 1
        fi
        
        # Gestisci i file modificati
        if ! handle_modified_files; then
            cd - > /dev/null
            return 1
        fi
        
        # Verifica se ci sono modifiche staged
        if git diff --cached --quiet; then
            echo -e "${YELLOW}Nessuna modifica staged per il commit${NC}"
            cd - > /dev/null
            return 1
        fi
        
        # Mostra il riepilogo finale
        echo -e "\n${BLUE}📋 Riepilogo delle modifiche da committare:${NC}"
        git status -s
        
        # Chiedi conferma per il commit
        echo -n "Vuoi procedere con il commit? [Y/n] "
        read answer
        if [ "$answer" != "n" ] && [ "$answer" != "N" ]; then
            git commit -m "$COMMIT_MSG"
            echo -e "${GREEN}✓ Commit effettuato in $repo_name${NC}"
            
            # Push se richiesto
            if [ $AUTO_PUSH -eq 1 ]; then
                echo "🔄 Pushing changes..."
                git push origin $BRANCH_NAME
                echo -e "${GREEN}✓ Push completato per $repo_name${NC}"
            fi
            
            return 0
        else
            echo "Commit saltato per $repo_name"
            return 1
        fi
    else
        echo -e "${GREEN}✓ Nessuna modifica in $repo_name${NC}"
        return 1
    fi
}

# Directory del repository principale
MAIN_REPO=$(pwd)

echo "🔍 Cercando modifiche nei repository..."
echo

# Array per tenere traccia dei submoduli modificati
declare -a MODIFIED_SUBMODULES=()

# Controlla prima i submoduli
echo "Controllo submoduli:"
git submodule foreach --quiet 'echo "$path"' | while read -r submodule_path; do
    if handle_repository "$MAIN_REPO/$submodule_path" "$submodule_path"; then
        MODIFIED_SUBMODULES+=("$submodule_path")
    fi
done

echo -e "\nControllo repository principale:"
# Controlla il repository principale
if handle_repository "$MAIN_REPO" "Repository principale"; then
    # Se ci sono submoduli modificati, aggiorna i riferimenti
    if [ ${#MODIFIED_SUBMODULES[@]} -gt 0 ]; then
        echo "📦 Aggiornamento riferimenti ai submoduli modificati..."
        git add "${MODIFIED_SUBMODULES[@]}"
        git commit -m "Aggiornamento submoduli: $COMMIT_MSG"
        
        if [ $AUTO_PUSH -eq 1 ]; then
            git push origin $BRANCH_NAME
        fi
    fi
fi

echo -e "\n${GREEN}✨ Operazione completata!${NC}"
