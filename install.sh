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
