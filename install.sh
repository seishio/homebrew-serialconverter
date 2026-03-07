#!/bin/bash
#
# install.sh — Serial Converter installer for Linux (DEB/RPM)
# Usage: curl -fsSL https://raw.githubusercontent.com/seishio/homebrew-serialconverter/main/install.sh | bash [-s VERSION]
#

# Enable strict error handling
set -euo pipefail

# Colors with fallback for terminals without color support
if [[ -t 1 ]] && command -v tput >/dev/null 2>&1 && tput colors >/dev/null 2>&1 && [[ $(tput colors) -ge 8 ]]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    BLUE='\033[0;34m'
    YELLOW='\033[1;33m'
    NC='\033[0m'
else
    RED=''
    GREEN=''
    BLUE=''
    YELLOW=''
    NC=''
fi

# Simple logging
log()     { echo -e "${BLUE}==>${NC} $1"; }
success() { echo -e "${GREEN}✅${NC} $1"; }
warning() { echo -e "${YELLOW}⚠️${NC} $1"; }
error()   { echo -e "${RED}❌${NC} $1" >&2; }

# Get latest version from GitHub API
get_latest_version() {
    local api_url="https://api.github.com/repos/seishio/homebrew-serialconverter/releases/latest"
    local response

    if ! response=$(timeout 10s curl -s "$api_url" 2>/dev/null); then
        error "Could not reach GitHub API"
        error "Specify version manually: curl ... | bash -s 1.2.3"
        exit 1
    fi

    local version
    version=$(echo "$response" | grep -Po '"tag_name": "v\K[^"]*' 2>/dev/null || echo "")
    if [[ -z "$version" ]]; then
        error "Could not determine latest version from GitHub API"
        error "Specify version manually: curl ... | bash -s 1.2.3"
        exit 1
    fi

    echo "$version"
}

# Determine version
VERSION="${1:-$(get_latest_version)}"
if [[ ! "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    error "Invalid version: $VERSION"
    exit 1
fi

# Check required tools
check_tools() {
    local missing_tools=()
    for tool in curl timeout; do
        if ! command -v "$tool" >/dev/null 2>&1; then
            missing_tools+=("$tool")
        fi
    done

    if [[ ${#missing_tools[@]} -gt 0 ]]; then
        error "Missing required tools: ${missing_tools[*]}"
        exit 1
    fi
}

# Check sudo availability
check_sudo() {
    if ! sudo -n true 2>/dev/null; then
        log "sudo access required for package installation"
        if [[ -t 0 ]]; then
            if ! sudo -v; then
                error "sudo access denied"
                exit 1
            fi
        else
            error "sudo access required but running in non-interactive mode"
            error "Please run with: curl -fsSL ... | sudo bash"
            exit 1
        fi
    fi
}

# Check network connectivity
check_network() {
    if ! timeout 5s ping -c 1 8.8.8.8 >/dev/null 2>&1; then
        error "No network connectivity"
        exit 1
    fi
}

# Download file with progress
download_file() {
    local file="$1"
    local url="$2"

    if [[ -f "$file" ]] && [[ -s "$file" ]]; then
        log "File $file already exists, skipping download"
        return 0
    fi

    log "Downloading $file..."
    if curl --progress-bar -L -o "$file" "$url"; then
        if [[ -f "$file" ]] && [[ -s "$file" ]]; then
            success "Download completed"
        else
            error "Downloaded file is empty or corrupted"
            exit 1
        fi
    else
        error "Failed to download $file"
        exit 1
    fi
}

# Verify checksum if .sha256 file is available
verify_checksum() {
    local file="$1"
    local url="$2"

    local sha256_file="${file}.sha256"
    log "Downloading checksum..."
    if ! curl -sf -L -o "$sha256_file" "${url}.sha256" 2>/dev/null; then
        warning "Checksum file not available, skipping verification"
        return 0
    fi

    if command -v sha256sum >/dev/null 2>&1; then
        if sha256sum -c "$sha256_file" >/dev/null 2>&1; then
            success "Checksum verified"
        else
            error "Checksum mismatch for $file"
            exit 1
        fi
    else
        warning "sha256sum not available, skipping verification"
    fi
}

# Detect system type
detect_system() {
    if [[ "$OSTYPE" != "linux-gnu"* ]]; then
        error "Unsupported operating system: $OSTYPE"
        error "For macOS, use: brew install --cask serialconverter"
        error "For Windows, download from: https://github.com/seishio/homebrew-serialconverter/releases"
        exit 1
    fi

    if command -v apt-get >/dev/null 2>&1; then
        echo "debian"
    elif command -v zypper >/dev/null 2>&1; then
        echo "suse"
    elif command -v dnf >/dev/null 2>&1 || command -v yum >/dev/null 2>&1; then
        echo "rpm"
    elif [[ -f /etc/os-release ]]; then
        local distro
        distro=$(grep "^ID=" /etc/os-release | cut -d= -f2 | tr -d '"')
        case "$distro" in
            opensuse*) echo "suse" ;;
            ubuntu|debian|linuxmint|pop) echo "debian" ;;
            fedora|rhel|centos|almalinux|rocky) echo "rpm" ;;
            *) echo "unsupported" ;;
        esac
    else
        echo "unsupported"
    fi
}

# Install DEB package
install_deb() {
    local version="$1"
    local file="SerialConverter-${version}-amd64.deb"
    local url="$BASE_URL/$file"

    download_file "$file" "$url"
    verify_checksum "$file" "$url"

    log "Installing DEB package..."
    check_sudo
    if ! sudo apt-get install -y "./$file" 2>/dev/null; then
        log "Trying dpkg fallback..."
        sudo dpkg -i "$file" || true
        sudo apt-get -f install -y
    fi

    success "Serial Converter installed successfully!"
    log "Run: serialconverter"
}

# Install RPM package
install_rpm() {
    local version="$1"
    local file="SerialConverter-${version}-x86_64.rpm"
    local url="$BASE_URL/$file"

    download_file "$file" "$url"
    verify_checksum "$file" "$url"

    log "Installing RPM package..."
    check_sudo
    if command -v dnf >/dev/null 2>&1; then
        sudo dnf install -y "./$file"
    elif command -v yum >/dev/null 2>&1; then
        sudo yum install -y "./$file"
    elif command -v zypper >/dev/null 2>&1; then
        sudo zypper --non-interactive install "./$file"
    else
        sudo rpm -i "$file"
    fi

    success "Serial Converter installed successfully!"
    log "Run: serialconverter"
}

# Main
check_network
check_tools

log "Installing Serial Converter v$VERSION"

# Check architecture
ARCHITECTURE=$(uname -m)
if [[ "$ARCHITECTURE" != "x86_64" ]] && [[ "$ARCHITECTURE" != "amd64" ]]; then
    error "Unsupported architecture: $ARCHITECTURE"
    error "Only x86_64 is supported. Download manually from:"
    error "https://github.com/seishio/homebrew-serialconverter/releases"
    exit 1
fi

# Create temp directory
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT
cd "$TEMP_DIR"

BASE_URL="https://github.com/seishio/homebrew-serialconverter/releases/download/v$VERSION"
SYSTEM_TYPE=$(detect_system)

log "Detected system: $SYSTEM_TYPE"

case "$SYSTEM_TYPE" in
    debian)
        install_deb "$VERSION"
        ;;
    rpm|suse)
        install_rpm "$VERSION"
        ;;
    unsupported)
        error "Unsupported Linux distribution"
        error "Download manually from: https://github.com/seishio/homebrew-serialconverter/releases"
        exit 1
        ;;
esac

success "Installation completed!"
