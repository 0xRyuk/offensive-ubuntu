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
