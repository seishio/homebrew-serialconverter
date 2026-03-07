# Serial Converter Homebrew Tap

[![Version](https://img.shields.io/github/v/release/seishio/homebrew-serialconverter?label=version&color=brightgreen)](https://github.com/seishio/homebrew-serialconverter/releases)

Homebrew Cask for Serial Converter — a tool that extracts serial numbers from PDF files and converts certificate serial numbers. Also provides a native Linux installer and Windows builds.

## Installation

### macOS
```bash
# Install Homebrew if not installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew tap seishio/serialconverter
brew install --cask serialconverter
```

### Linux (DEB, RPM)
**Requirements:** `curl`, `sudo`

```bash
curl -fsSL https://raw.githubusercontent.com/seishio/homebrew-serialconverter/main/install.sh | bash
```

The script automatically detects your distribution (Debian/Ubuntu, Fedora/RHEL/CentOS, openSUSE) and installs the appropriate package.

### Windows
Download the latest `.exe` from the [Releases](https://github.com/seishio/homebrew-serialconverter/releases) page.

---

<details>
<summary><b>Updating</b></summary>

**macOS:**
```bash
brew upgrade --cask serialconverter
```

**Linux:**
```bash
curl -fsSL https://raw.githubusercontent.com/seishio/homebrew-serialconverter/main/install.sh | bash
```
</details>

<details>
<summary><b>Uninstalling</b></summary>

**macOS:**
```bash
brew uninstall --cask serialconverter
```

**Debian/Ubuntu:**
```bash
sudo apt-get remove serialconverter
```

**Fedora/RHEL/CentOS:**
```bash
sudo dnf remove serialconverter
```

**openSUSE:**
```bash
sudo zypper remove serialconverter
```
</details>

<details>
<summary><b>Troubleshooting</b></summary>

#### Complete Removal (macOS)
If something went wrong, remove the app along with all its data:
```bash
brew uninstall --zap --cask serialconverter
brew untap seishio/serialconverter
```

#### SHA-256 Mismatch Error (macOS)
```bash
brew cleanup --prune=all
brew untap seishio/serialconverter
brew tap seishio/serialconverter
brew install --cask serialconverter
```

#### Dependency Issues (Linux DEB)
```bash
sudo apt-get install -f
```

#### Permission Denied (Linux)
```bash
curl -fsSL https://raw.githubusercontent.com/seishio/homebrew-serialconverter/main/install.sh | sudo bash
```
</details>

