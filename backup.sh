#!/bin/bash

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

CONFIGS=(
    ".profile"
    ".gitconfig"
    ".config/nvim"       # Exemplo: Neovim
    ".config/fish"
    ".local/share/fonts"
    ".config/neofetch"
)

echo "Iniciando backup para: $DOTFILES_DIR"
echo "-------------------------------------"

for config in "${CONFIGS[@]}"; do
    SOURCE="$HOME/$config"
    DEST="$DOTFILES_DIR/$config"
    
    # Se o arquivo/pasta existe na origem
    if [ -e "$SOURCE" ]; then
        echo "Copiando: $config"
        
        # Cria a estrutura de pastas no destino se não existir
        mkdir -p "$(dirname "$DEST")"
        
        # Copia recursivamente, preservando atributos, mas sem seguir links simbólicos
        cp -R --remove-destination "$SOURCE" "$DEST"
    else
        echo "AVISO: $config não encontrado no sistema. Pulando."
    fi
done

echo "-------------------------------------"
echo "Backup local concluído."
