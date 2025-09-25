#!/bin/bash
#
#

# Color definitions
green='\033[1;32m'
red='\033[1;31m'
cyan="\033[0;36m\]"
yellow="\033[0;33m\]"
blue='\033[1;34m'
reset='\033[0m'

# Logging functions
log_info() {
    echo -e "${green}[INFO]${reset} $1"
}

log_warn() {
    echo -e "${yellow}[WARN]${reset} $1"
}

log_error() {
    echo -e "${red}[ERROR]${reset} $1"
}

log_status() {
    echo -e "${cyan}[STATUS]${reset} $1"
}

# Get the architecture of the system
get_architecture() {
    local architecture=$(uname -m)
    
    case "$architecture" in
        x86_64)
            echo "amd64"
            ;;
        i686|i386)
            echo "386"
            ;;
        arm64|aarch64)
            echo "arm64"
            ;;
        *)
            log_error "Unable to determine system architecture: $architecture"
            return 1
            ;;
    esac
}

AARCH=$(get_architecture) || exit 1

# Check if running as non-root (will use sudo when needed)
if [ "$EUID" -eq 0 ]; then
    SUDO=""
else
    SUDO="sudo"
fi

# Display banner
show_banner() {
    clear
    echo -e "${red}"
    if command -v figlet &> /dev/null; then
        figlet "Offensive Ubuntu"
    else
        echo "╔════════════════════════════════════════════╗"
        echo "║       OFFENSIVE UBUNTU SETUP SCRIPT       ║"
        echo "╚════════════════════════════════════════════╝"
    fi
    echo -e "${reset}"
}

# Installation menu
show_main_menu() {
    echo -e "${blue}╔════════════════════════════════════════════╗${reset}"
    echo -e "${blue}║          INSTALLATION COMPONENTS          ║${reset}"
    echo -e "${blue}╚════════════════════════════════════════════╝${reset}"
    echo "1) Install system packages (apt)"
    echo "2) Install tools from snap"
    echo "3) Install golang and go tools"
    echo "4) Install tools from GitHub repositories"
    echo "5) Install additional security tools (Metasploit, WPScan, etc)"
    echo "6) Install ALL components"
    echo "7) Exit"
    echo ""
}

# Get user choice
get_user_choice() {
    local choice
    read -p "Enter your choice [1-7]: " choice
    echo "$choice"
}

# Initialize setup
initialize_setup() {
    show_banner
    log_info "System architecture detected: ${AARCH}"
    log_info "Preparing setup..."
    
    $SUDO apt-get update 2>&1 | grep -q "done" || true
    
    # Install figlet if not present
    if ! command -v figlet &> /dev/null; then
        log_status "Installing figlet..."
        $SUDO apt-get install -y figlet > /dev/null 2>&1
    fi
    
    show_banner
}

# Function to detect latest golang version from golang.org
get_latest_golang_version() {
    log_status "Fetching latest golang version..."
    local latest_version

    latest_version=$(curl -s https://go.dev/VERSION?auto=1 2>/dev/null | head -n1 | sed 's/go//')
    
    if [ -z "$latest_version" ]; then
        log_warn "Could not fetch latest golang version, using default: v1.25.5"
        latest_version="1.25.5"
    fi
    
    echo "$latest_version"
}

# Function to get installed golang version
get_installed_golang_version() {
    if [ -f /usr/local/go/bin/go ]; then
        /usr/local/go/bin/go version 2>/dev/null | awk '{print $3}' | sed 's/go//'
    fi
}

# Function to install golang
install_golang() {
    log_status "Starting Go installation..."
    sleep 1
    
    local installed_version=$(get_installed_golang_version)
    local latest_version=$(get_latest_golang_version)
    
    if [ -n "$installed_version" ]; then
        log_info "Go is already installed: version ${installed_version}"
        read -p "Do you want to update to version ${latest_version}? (y/n): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_status "Skipping golang installation"
            return 0
        fi
        # Backup existing installation
        log_info "Backing up existing Go installation..."
        $SUDO mv /usr/local/go /usr/local/go.backup.${installed_version}
    fi
    
    log_info "Downloading Go ${latest_version} for ${AARCH}..."
    local download_url="https://dl.google.com/go/go${latest_version}.linux-${AARCH}.tar.gz"
    local temp_file="/tmp/go${latest_version}.linux-${AARCH}.tar.gz"
    
    if wget -q "${download_url}" -O "${temp_file}"; then
        log_info "✓ Downloaded successfully"
        log_info "Extracting Go to /usr/local/..."
        if $SUDO tar -C /usr/local/ -xzf "${temp_file}"; then
            rm -f "${temp_file}"
            log_info "✓ Go ${latest_version} installed successfully"
            
            # Setup environment
            setup_golang_env
            return 0
        else
            log_error "Failed to extract Go archive"
            if [ -d /usr/local/go.backup.${installed_version} ]; then
                log_warn "Restoring previous installation..."
                $SUDO mv /usr/local/go.backup.${installed_version} /usr/local/go
            fi
            return 1
        fi
    else
        log_error "Failed to download Go from ${download_url}"
        if [ -d /usr/local/go.backup.${installed_version} ]; then
            log_warn "Restoring previous installation..."
            $SUDO mv /usr/local/go.backup.${installed_version} /usr/local/go
        fi
        return 1
    fi
}

# Function to setup golang environment
setup_golang_env() {
    log_status "Setting up Go environment..."
    
    # Create bash_aliases if it doesn't exist
    if [ ! -f ~/.bash_aliases ]; then
        log_info "Creating ~/.bash_aliases"
        touch ~/.bash_aliases
        chmod 644 ~/.bash_aliases
    fi
    
    # Remove existing golang paths if present
    sed -i '/GOROOT/d' ~/.bash_aliases
    sed -i '/GOPATH/d' ~/.bash_aliases
    sed -i '/:\/usr\/local\/go/d' ~/.bash_aliases
    
    # Add new golang configuration
    echo "export GOROOT=/usr/local/go" >> ~/.bash_aliases
    echo "export GOPATH=\$HOME/go-workspace" >> ~/.bash_aliases
    echo "export PATH=\$GOPATH/bin:\$GOROOT/bin:\$PATH" >> ~/.bash_aliases

    source ~/.bash_aliases 2>/dev/null || true
    
    mkdir -p ~/go-workspace/bin ~/go-workspace/src ~/go-workspace/pkg
    
    log_info "✓ Go environment configured"
}
