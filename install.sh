#!/bin/bash

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Restaurando configurações para o sistema..."
echo "ATENÇÃO: Isso vai sobrescrever arquivos existentes na sua Home."
read -p "Tem certeza? (s/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    exit 1
fi

# Copia tudo da pasta atual para a Home, excluindo os próprios scripts e a pasta .git
rsync -av --no-perms --exclude '.git' --exclude 'backup.sh' --exclude 'install.sh' --exclude 'README.md' "$DOTFILES_DIR/" "$HOME/"

echo "Restauração concluída! Reinicie o shell ou o sistema para ver as mudanças."
