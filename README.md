# Serial Converter Homebrew Tap

[![Version](https://img.shields.io/badge/Version-0.2.12-brightgreen.svg)](https://github.com/seishio/homebrew-serialconverter/releases)

This tap provides the Serial Converter application via Homebrew Cask.

## About Serial Converter

Serial Converter is a powerful tool that extracts serial numbers from PDF files and converts certificate serial numbers.

## Installation

### macOS
```bash
# Install Homebrew (if not installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Serial Converter
brew tap seishio/serialconverter
brew install --cask serialconverter
```

### Linux (DEB, AppImage)

**Install:**
```bash
curl -fsSL https://raw.githubusercontent.com/seishio/homebrew-serialconverter/main/install.sh | bash
```

## Updating & Reinstalling

### Update
```bash
# macOS
brew upgrade --cask serialconverter

# Linux (same as installation)
curl -fsSL https://raw.githubusercontent.com/seishio/homebrew-serialconverter/main/install.sh | bash
```

### Force Reinstall
```bash
# Force reinstall
brew reinstall --cask serialconverter
```

### Reinstall
```bash
# Standard reinstall
brew cleanup && brew uninstall --cask serialconverter
brew untap seishio/serialconverter
brew tap seishio/serialconverter
brew install --cask serialconverter

# Complete reinstall (with data cleanup)
brew cleanup && brew uninstall --cask serialconverter
rm -rf ~/Library/Application\ Support/SerialConverter ~/Library/Preferences/com.serialconverter.*
brew untap seishio/serialconverter
brew tap seishio/serialconverter
brew install --cask serialconverter
```

### Complete Reset
```bash
# Nuclear option - reset everything
brew uninstall --cask serialconverter
rm -rf ~/Library/Application\ Support/SerialConverter ~/Library/Preferences/com.serialconverter.*
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew tap seishio/serialconverter
brew install --cask serialconverter
```

### Troubleshooting

#### SHA-256 Mismatch Error
```bash
# Clean cache and reinstall tap
brew cleanup --prune=all
brew untap seishio/serialconverter
brew tap seishio/serialconverter
brew install --cask serialconverter
```

## License

### Homebrew Tap

This Homebrew tap is provided under the MIT License.

### Serial Converter Application

**Non-Commercial License** - This software is provided for personal use only. Commercial use, modification, and redistribution are strictly prohibited without explicit written permission.
