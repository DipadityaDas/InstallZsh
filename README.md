# ZSH Manager (Fedora-based Systems)

A robust shell management utility to **install, configure, track, and revert ZSH environments** for users on Fedora-based Linux distributions.

---

## 📦 Features

- Per-user installation and rollback
- State tracking for safe revert
- Automatic `.zshrc` deployment
- Starship prompt integration
- Plugin configuration (autosuggestions, syntax highlighting)
- Optional full cleanup mode
- Logging and error handling

---

## 📁 Script Reference

Source script included in this project.

---

## ⚙️ Requirements

- Fedora / RHEL / AlmaLinux / Rocky Linux
- Root privileges
- Internet connectivity

---

## 🚀 Installation Guide

### 1. Download the Script

```bash
curl -O https://your-repo/zsh_manager.sh
chmod +x zsh_manager.sh
```

---

### 2. Run Installation

```bash
sudo ./zsh_manager.sh install <username>
```

Example:

```bash
sudo ./zsh_manager.sh install dipaditya
```

---

## 🔧 What Happens During Install

The script will:

- Save current user shell state
- Install required packages:
  - zsh
  - git
  - fzf
  - curl
- Enable COPR repo for starship
- Add repositories for:
  - zsh-autosuggestions
  - zsh-syntax-highlighting
- Install starship and plugins
- Deploy:
  - /etc/starship/starship.toml
  - ~/.zshrc
- Change user shell to ZSH

---

## 🔍 Check Status

```bash
sudo ./zsh_manager.sh status <username>
```

---

## 🔄 Revert Changes

### Basic Revert

```bash
sudo ./zsh_manager.sh revert <username>
```

---

### Full Cleanup Mode

```bash
sudo ./zsh_manager.sh revert <username> --full-cleanup
```

---

## 📂 File Locations

| Path | Purpose |
|------|--------|
| /var/lib/zsh_manager/ | State tracking |
| /var/log/zsh_manager.log | Execution logs |
| /etc/starship/starship.toml | Global prompt config |
| ~/.zshrc | User ZSH configuration |

---

## 🛡️ Safety Design

- Uses state files to ensure safe rollback
- Does not overwrite existing `.zshrc` blindly
- Skips system users during global revert
- Uses strict error handling

---

## ⚠️ Important Notes

- Must be run as root
- Designed for Fedora-based systems only
- Internet is required for repo and config downloads

---

## 🧪 Example Workflow

```bash
sudo ./zsh_manager.sh install dipaditya
sudo ./zsh_manager.sh status dipaditya
sudo ./zsh_manager.sh revert dipaditya
sudo ./zsh_manager.sh revert dipaditya --full-cleanup
```

---

## 📜 License

MIT License

---

## 👨‍💻 Author

Dipaditya Das
