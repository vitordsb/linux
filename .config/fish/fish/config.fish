# ===================================
# ~/.config/fish/config.fish (Android + Dev - OTIMIZADO / ESTÁVEL)
# ===================================

# --------------------------
# Básico
# --------------------------
set -g fish_greeting ""

# Evita tela preta do Android Emulator no Wayland + NVIDIA
set -gx QT_QPA_PLATFORM xcb

# --------------------------
# Java (Android Studio exige Java 17)
# --------------------------
set -gx JAVA_HOME /usr/lib/jvm/java-17-openjdk-amd64

# --------------------------
# Android SDK
# --------------------------
set -gx ANDROID_SDK_ROOT $HOME/Android/Sdk
set -gx ANDROID_HOME $ANDROID_SDK_ROOT

# Adiciona paths do Android (sem duplicar)
if type -q fish_add_path
    fish_add_path -m $ANDROID_SDK_ROOT/emulator
    fish_add_path -m $ANDROID_SDK_ROOT/platform-tools
    fish_add_path -m $ANDROID_SDK_ROOT/cmdline-tools/latest/bin
else
    set -gx PATH \
        $ANDROID_SDK_ROOT/emulator \
        $ANDROID_SDK_ROOT/platform-tools \
        $ANDROID_SDK_ROOT/cmdline-tools/latest/bin \
        $PATH
end

# --------------------------
# Flutter
# --------------------------
set -gx FLUTTER_HOME $HOME/dev/flutter

# --------------------------
# Node / PNPM / Bun / Rust
# --------------------------
set -gx NVM_DIR $HOME/.nvm
set -gx PNPM_HOME $HOME/.local/share/pnpm
set -gx BUN_INSTALL $HOME/.bun
set -gx CARGO_HOME $HOME/.cargo
set -gx RUSTUP_HOME $HOME/.rustup

# --------------------------
# PATH (somente ferramentas de dev)
# - use fish_add_path pra evitar PATH inflado e duplicado
# --------------------------
if type -q fish_add_path
    fish_add_path -m $HOME/bin
    fish_add_path -m $PNPM_HOME
    fish_add_path -m $BUN_INSTALL/bin
    fish_add_path -m $CARGO_HOME/bin
    fish_add_path -m $JAVA_HOME/bin
    fish_add_path -m $FLUTTER_HOME/bin
else
    for p in $HOME/bin $PNPM_HOME $BUN_INSTALL/bin $CARGO_HOME/bin $JAVA_HOME/bin $FLUTTER_HOME/bin
        if test -d $p
            set -gx PATH $p $PATH
        end
    end
end

# --------------------------
# Zoxide (leve) + cd -> z
# --------------------------
if status --is-interactive
    if type -q zoxide
        zoxide init fish | source
        alias cd='z'
    end
end

# --------------------------
# NVM (lazy-load) - NÃO trava o startup
# - Só carrega quando você rodar node/npm/npx
# - Se você NÃO usa NVM, não quebra: só não carrega.
# --------------------------
function __load_nvm --description "Load NVM on demand"
    # Só tenta se existir nvm.sh
    if not test -s $NVM_DIR/nvm.sh
        return 127
    end

    # Precisa do 'bass' para rodar bash scripts no fish.
    # Se não tiver, avisa só quando for usar node/npm/npx.
    if not functions -q bass
        echo "bass não instalado. Instale com: fisher install edc/bass"
        return 127
    end

    # Carrega nvm e usa default
    bass source $NVM_DIR/nvm.sh --no-use
    command nvm use default >/dev/null 2>&1
end

for cmd in node npm npx
    functions -q $cmd; and continue
    function $cmd --wraps $cmd
        __load_nvm; or return $status
        functions -e $cmd
        command $cmd $argv
    end
end

# --------------------------
# Auto Virtualenv Python (on cd)
# - silencioso (sem echo) para não poluir e não travar
# --------------------------
if status --is-interactive
    function __auto_venv_activate --on-variable PWD
        # Se já existe um venv ativo e você saiu do projeto, desativa
        if set -q VIRTUAL_ENV
            # Evita custo se ainda estiver dentro da mesma raiz (heurística simples)
            # Se quiser, remova essa heurística.
            if not string match -q -- "*"(pwd)"*" "$VIRTUAL_ENV"
                if functions -q deactivate
                    deactivate >/dev/null 2>&1
                else
                    set -e VIRTUAL_ENV
                end
            end
        end

        # Ativa venv local se existir
        if test -f ./venv/bin/activate.fish
            source ./venv/bin/activate.fish >/dev/null 2>&1
        else if test -f ./.venv/bin/activate.fish
            source ./.venv/bin/activate.fish >/dev/null 2>&1
        end
    end
end

# --------------------------
# Aliases úteis
# --------------------------
alias ll='ls -lah'
alias l='ls -l'
alias rl='source ~/.config/fish/config.fish'

alias up='sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt autoclean -y'

# Editores
alias vi='nvim'
alias nano='nvim'
alias gedit='nvim'

# Git deploy
function deploy
    if test -z "$argv"
        echo "Erro: Você precisa digitar uma mensagem de commit."
        echo 'Uso: deploy "mensagem aqui"'
        return 1
    end

    git add .
    git commit -m "$argv"
    git push origin HEAD
    echo "Deploy concluído!"
end

# Python
alias py='python3'
alias pyinit='python3 -m venv venv'

# Navegação
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Info
alias info='neofetch'
alias myip='curl ipinfo.io'

# Serviços
alias linit='systemctl list-units --type=service'
alias cls='sudo apt autoremove -y && sudo apt autoclean -y'

# --------------------------
# Android Emulator (RTX 3050 otimizado)
# --------------------------
alias mobile='emulator -avd Pixel_5 -gpu angle_indirect -no-snapshot'
alias mobile-soft='emulator -avd Pixel_5 -gpu swiftshader_indirect -no-snapshot'

# --------------------------
# Android Studio launcher
# --------------------------
function android
    set -l studio /opt/android-studio/bin/studio.sh

    if not test -x $studio
        echo "Android Studio não encontrado em $studio"
        return 1
    end

    if test (count $argv) -eq 0
        $studio >/dev/null 2>&1 &
    else
        $studio $argv[1] >/dev/null 2>&1 &
    end
end

# --------------------------
# Starship (se você usa) - sempre por último
# --------------------------
if status --is-interactive
    if type -q starship
        starship init fish | source
    end
end

