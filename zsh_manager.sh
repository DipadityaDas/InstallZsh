#!/usr/bin/env bash

set -Eeuo pipefail

STATE_DIR="/var/lib/zsh_manager"
LOG_FILE="/var/log/zsh_manager.log"

mkdir -p "$STATE_DIR"

# -------------------------------
# Logging
# -------------------------------
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') : $*" | tee -a "$LOG_FILE"
}

trap 'log "ERROR at line $LINENO"; exit 1' ERR

# -------------------------------
# Usage
# -------------------------------
usage() {
    cat <<EOF
Usage:
  $0 install <username>
  $0 revert <username> [--full-cleanup]
  $0 status <username>
EOF
    exit 1
}

# -------------------------------
# Validate
# -------------------------------
[[ $# -lt 2 ]] && usage

ACTION="$1"
TARGET_USER="$2"
FLAG="${3:-}"

if ! id "$TARGET_USER" &>/dev/null; then
    log "User does not exist"
    exit 1
fi

USER_HOME=$(getent passwd "$TARGET_USER" | cut -d: -f6)
STATE_FILE="$STATE_DIR/${TARGET_USER}.state"

if [[ "$EUID" -ne 0 ]]; then
    log "Run as root"
    exit 1
fi

# -------------------------------
# Save State
# -------------------------------
save_state() {
    log "Saving state"

    CURRENT_SHELL=$(getent passwd "$TARGET_USER" | cut -d: -f7)

    cat > "$STATE_FILE" <<EOF
USER=$TARGET_USER
HOME=$USER_HOME
OLD_SHELL=$CURRENT_SHELL
ZSHRC_EXISTED=$( [[ -f "$USER_HOME/.zshrc" ]] && echo yes || echo no )
EOF
}

# -------------------------------
# Load State
# -------------------------------
load_state() {
    if [[ ! -f "$STATE_FILE" ]]; then
        log "No state found. Cannot safely revert."
        exit 1
    fi
    source "$STATE_FILE"
}

# -------------------------------
# INSTALL
# -------------------------------
install() {
    log "Starting install for $TARGET_USER"

    save_state

    dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-$(grep '^VERSION_ID=' /etc/os-release | cut -d= -f2 | tr -d '"' | cut -d. -f1).noarch.rpm || true

    #dnf install -y epel-release || true
    dnf install -y git fzf zsh curl || true

    dnf -y copr enable atim/starship || true

    dnf config-manager --add-repo https://download.opensuse.org/repositories/shells:zsh-users:zsh-autosuggestions/Fedora_Rawhide/shells:zsh-users:zsh-autosuggestions.repo || true

    dnf config-manager --add-repo https://download.opensuse.org/repositories/shells:zsh-users:zsh-syntax-highlighting/Fedora_Rawhide/shells:zsh-users:zsh-syntax-highlighting.repo || true

    dnf install -y zsh-syntax-highlighting zsh-autosuggestions starship

    mkdir -p /etc/starship

    curl -fsSL https://raw.githubusercontent.com/DipadityaDas/InstallZsh/refs/heads/main/starship.toml -o /etc/starship/starship.toml

    curl -fsSL https://raw.githubusercontent.com/DipadityaDas/InstallZsh/refs/heads/main/ZSHconfig -o "$USER_HOME/.zshrc"

    chown "$TARGET_USER:$TARGET_USER" "$USER_HOME/.zshrc"

    ZSH_PATH=$(command -v zsh)

    if [[ -n "$ZSH_PATH" ]]; then
        chsh -s "$ZSH_PATH" "$TARGET_USER"
    fi

    log "================================== Install completed =================================="
}

# -------------------------------
# REVERT
# -------------------------------
revert() {
    log "Starting revert for $TARGET_USER"

    load_state

    # Restore shell
    if [[ -n "${OLD_SHELL:-}" && -x "$OLD_SHELL" ]]; then
        log "Restoring shell to $OLD_SHELL"
        chsh -s "$OLD_SHELL" "$TARGET_USER"
    fi

    # Restore/remove .zshrc
    if [[ "$ZSHRC_EXISTED" == "no" ]]; then
        log "Removing .zshrc"
        rm -f "$USER_HOME/.zshrc"
    else
        log "User had existing .zshrc, leaving untouched"
    fi

    rm -f "$STATE_FILE"

    BASH_PATH=$(command -v bash)

    if [[ -n "$BASH_PATH" ]]; then
        chsh -s "$BASH_PATH" "$TARGET_USER"
    fi

    # Optional full cleanup
    if [[ "$FLAG" == "--full-cleanup" ]]; then
        log "Performing full cleanup"

        # Remove starship config
        rm -f /etc/starship/starship.toml 2>/dev/null || true
        rmdir /etc/starship 2>/dev/null || true

        # Remove packages (safe)
        dnf remove -y zsh-autosuggestions zsh-syntax-highlighting starship fzf zsh || true

        # Disable packages (safe)
        dnf copr disable -y atim/starship || true

        rm -f /etc/yum.repos.d/*zsh-autosuggestions.repo || true
        rm -f /etc/yum.repos.d/*zsh-syntax-highlighting.repo || true
        rm -rf /var/lib/zsh_manager || true
        rm -f /var/log/zsh_manager.log || true

        # Revert all users
        revert_all_zsh_users

        exec bash
    fi

    log "================================== Revert completed =================================="
}

# -------------------------------
# Revert ZSH shell for ALL users
# -------------------------------
revert_all_zsh_users() {
    log "Reverting all users with ZSH shell to /bin/bash"

    DEFAULT_SHELL="/bin/bash"

    if [[ ! -x "$DEFAULT_SHELL" ]]; then
        log "ERROR: $DEFAULT_SHELL not found. Aborting global shell revert."
        return 1
    fi

    # Get all users with valid shells (ignore nologin/false)
    while IFS=: read -r username _ uid _ _ home shell; do

        # Skip system users (UID < 1000) unless explicitly needed
        if [[ "$uid" -lt 1000 ]]; then
            continue
        fi

        # Check if shell is zsh
        if [[ "$shell" == *zsh ]]; then
            log "Changing shell for user '$username' from $shell → $DEFAULT_SHELL"

            chsh -s "$DEFAULT_SHELL" "$username" || \
                log "WARNING: Failed to change shell for $username"
        fi

    done < /etc/passwd

    log "Global ZSH shell revert completed"
}

# -------------------------------
# STATUS
# -------------------------------
status() {
    log "Checking status for $TARGET_USER"

    echo "User: $TARGET_USER"
    echo "Home: $USER_HOME"

    echo -n "Shell: "
    getent passwd "$TARGET_USER" | cut -d: -f7

    echo -n "Zsh Config File: "
    [[ -f "$USER_HOME/.zshrc" ]] && echo "Present" || echo "Absent"

    echo -n "Starship: "
    command -v starship &>/dev/null && echo "Installed" || echo "Not installed"

    echo -n "State file: "
    [[ -f "$STATE_FILE" ]] && echo "Tracked" || echo "Not tracked"
}

# -------------------------------
# Dispatcher
# -------------------------------
case "$ACTION" in
    install) install ;;
    revert) revert ;;
    status) status ;;
    *) usage ;;
esac
