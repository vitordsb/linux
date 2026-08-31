
# ===================================
# ~/.config/fish/config.fish (Android + Dev - ESTÁVEL)
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
# --------------------------
set -l dev_paths \
    $HOME/bin \
    $PNPM_HOME \
    $BUN_INSTALL/bin \
    $CARGO_HOME/bin \
    $JAVA_HOME/bin \
    $FLUTTER_HOME/bin

for p in $dev_paths
    if test -d $p
        if type -q fish_add_path
            fish_add_path $p
        else
            set -gx PATH $p $PATH
        end
    end
end

# --------------------------
# Zoxide
# --------------------------
if status --is-interactive
    if type -q zoxide
        zoxide init fish | source
        alias cd='z'
    end
end

# --------------------------
# NVM (se existir)
# --------------------------
if status --is-interactive
    if type -q nvm
        nvm use default >/dev/null 2>&1
    end
end

# --------------------------
# Auto Virtualenv Python
# --------------------------
if status --is-interactive
    function auto_venv_activate --on-variable PWD
        if set -q VIRTUAL_ENV
            if functions -q deactivate
                deactivate >/dev/null 2>&1
            else
                set -e VIRTUAL_ENV
            end
        end

        if test -f ./venv/bin/activate.fish
            source ./venv/bin/activate.fish
            echo "🐍 Virtualenv ativada: (venv)"
        else if test -f ./.venv/bin/activate.fish
            source ./.venv/bin/activate.fish
            echo "🐍 Virtualenv ativada: (.venv)"
        end
    end
end

# --------------------------
# ALIASES ÚTEIS
# --------------------------
alias ll='ls -lah'
alias l='ls -l'
alias rl='source ~/.config/fish/config.fish'

alias up='sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt autoclean -y'

# Editores
alias vi='nvim'
alias nano='nvim'
alias gedit='nvim'

function deploy
    # Verifica se existe algum argumento (mensagem)
    if test -z "$argv"
        echo "❌ Erro: Você precisa digitar uma mensagem de commit."
        echo "Uso: deploy \"mensagem aqui\""
        return 1
    end

    git add .
    git commit -m "$argv"
    
    git push origin HEAD 
    
    echo "✅ Deploy concluído!"
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
alias linit='sudo systemctl list-units --type service'
alias cls='sudo apt autoremove -y && sudo apt autoclean -y'

# --------------------------
# Android Emulator (RTX 3050 otimizado)
# --------------------------
# Padrão: ANGLE (melhor desempenho e estabilidade)
alias mobile='emulator -avd Pixel_5 -gpu angle_indirect -no-snapshot'

# Fallback (caso dê problema gráfico)
alias mobile-soft='emulator -avd Pixel_5 -gpu swiftshader_indirect -no-snapshot'

# --------------------------
# Android Studio launcher
# --------------------------
function android
    set studio /opt/android-studio/bin/studio.sh

    if not test -x $studio
        echo "❌ Android Studio não encontrado em $studio"
        return 1
    end

    if test (count $argv) -eq 0
        $studio >/dev/null 2>&1 &
    else
        $studio $argv[1] >/dev/null 2>&1 &
    end
end
