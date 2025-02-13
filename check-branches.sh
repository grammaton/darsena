#!/bin/bash

# Controlla se sono stati forniti le iniziali come parametro
if [ $# -eq 0 ]; then
    echo "Uso: $0 xyz (dove xyz sono le tue iniziali)"
    exit 1
fi

INITIALS=$1
BRANCH_NAME="darsena-$INITIALS"

# Funzione per controllare e creare il branch
check_and_create_branch() {
    local repo_path=$1
    local repo_name=$2
    
    echo "Controllando $repo_name..."
    
    # Entra nella directory del repository
    cd "$repo_path"
    
    # Assicurati di avere gli ultimi aggiornamenti
    git fetch
    
    # Controlla se il branch esiste localmente o remotamente
    if git show-ref --verify --quiet "refs/heads/$BRANCH_NAME" || \
       git show-ref --verify --quiet "refs/remotes/origin/$BRANCH_NAME"; then
        echo "✓ Branch $BRANCH_NAME già esiste in $repo_name"
        
        # Se esiste solo remotamente, crealo localmente
        if ! git show-ref --verify --quiet "refs/heads/$BRANCH_NAME"; then
            git checkout -b "$BRANCH_NAME" "origin/$BRANCH_NAME"
            echo "  → Branch locale creato da quello remoto"
        fi
    else
        # Crea il nuovo branch dalla main/master corrente
        local main_branch=""
        if git show-ref --verify --quiet refs/heads/main; then
            main_branch="main"
        else
            main_branch="master"
        fi
        
        git checkout "$main_branch"
        git pull origin "$main_branch"
        git checkout -b "$BRANCH_NAME"
        echo "+ Nuovo branch $BRANCH_NAME creato in $repo_name da $main_branch"
        
        # Pusha il branch al remote
        git push -u origin "$BRANCH_NAME"
        echo "  → Branch pushato al remote"
    fi
    
    # Torna alla directory principale
    cd - > /dev/null
}

# Directory del repository principale
MAIN_REPO=$(pwd)

# Controlla il repository principale
check_and_create_branch "$MAIN_REPO" "Repository principale"

# Controlla tutti i submoduli
echo -e "\nControllando i submoduli..."
git submodule foreach --quiet 'echo "$path"' | while read -r submodule_path; do
    check_and_create_branch "$MAIN_REPO/$submodule_path" "$submodule_path"
done

echo -e "\nOperazione completata! 🎉"
echo "Tutti i repository sono stati controllati e configurati con il branch $BRANCH_NAME"
