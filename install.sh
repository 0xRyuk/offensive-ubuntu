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

# Function to install apt packages
install_apt_packages() {
    log_status "Starting APT package installation..."
    sleep 1
    
    $SUDO add-apt-repository universe -y > /dev/null 2>&1
    $SUDO apt-get update > /dev/null 2>&1
    log_info "Upgrading system packages..."
    $SUDO apt-get upgrade -y > /dev/null 2>&1
    
    local PACKAGES=("recordmydesktop" "python3" "python2" "hashcat" "vim" "net-tools" "aircrack-ng" "traceroute" "python3-pip" "python-setuptools" "libimage-exiftool-perl" "binwalk" "steghide" "libldns-dev" "nmap" "build-essential" "libssl-dev" "libffi-dev" "python-dev" "hydra-gtk" "reaver" "wifite" "pixiewps" "cowpatty" "netcat" "ettercap-graphical" "btscanner" "dnsmap" "dnsenum" "dnsrecon" "dnswalk" "wafw00f" "mitmproxy" "macchanger" "dsniff" "chkrootkit" "backdoor-factory" "netsniff-ng" "iputils-arping" "sleuthkit" "xprobe" "masscan" "netdiscover" "netmask" "nbtscan" "hexedit" "proxytunnel" "foremost" "recoverjpeg" "smbmap" "dmitry" "sqlmap" "recon-ng" "autopsy" "hashdeep" "httrack" "burp" "wfuzz" "beef" "perl" "openjdk-11-jre" "libcurl4-openssl-dev" "ruby-full" "libxml2" "libxml2-dev" "libxslt1-dev" "ruby-dev" "libgmp-dev" "zlib1g-dev" "git" "curl" "wget" "openvpn" "openssh" "wireshark-qt" "openjdk-8-jdk" "libssl-dev" "jq" "python-dnspython" "rename")
    
    local total=${#PACKAGES[@]}
    local current=0
    
    for PKG in "${PACKAGES[@]}"; do
        ((current++))
        local IS_INSTALLED=$($SUDO dpkg-query -W --showformat='${Status}\n' "${PKG}" 2>/dev/null | grep "install ok installed")
        
        if [ -n "$IS_INSTALLED" ]; then
            log_status "[${current}/${total}] ${PKG} already installed"
        else
            log_info "[${current}/${total}] Installing ${PKG}..."
            if $SUDO apt-get install -y "${PKG}" > /dev/null 2>&1; then
                log_info "[${current}/${total}] ✓ ${PKG} installed"
            else
                log_warn "[${current}/${total}] ✗ Failed to install ${PKG}"
            fi
        fi
    done
}

# Function to install snap packages
install_snap_packages() {
    log_status "Starting SNAP package installation..."
    sleep 1
    
    local SNAP_PACKAGES=("john-the-ripper" "volatility-phocean" "chromium" "amass")
    local total=${#SNAP_PACKAGES[@]}
    local current=0
    
    for PKG in "${SNAP_PACKAGES[@]}"; do
        ((current++))
        log_info "[${current}/${total}] Installing ${PKG} from snap..."
        if $SUDO snap install "${PKG}" > /dev/null 2>&1; then
            log_info "[${current}/${total}] ✓ ${PKG} installed"
        else
            log_warn "[${current}/${total}] ✗ Failed to install ${PKG}"
        fi
    done
}

# Function to install go-based tools
install_go_tools() {
    log_status "Installing Go-based tools..."
    sleep 1
    
    export GOROOT=/usr/local/go
    export GOPATH=$HOME/go-workspace
    export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
    
    mkdir -p ~/go-workspace/bin ~/go-workspace/src ~/go-workspace/pkg
    cd ~/go-workspace/bin || return 1
    
    local GO_TOOLS=(
        "aquatone:github.com/michenriksen/aquatone@latest"
        "httprobe:github.com/tomnomnom/httprobe@latest"
        "unfurl:github.com/tomnomnom/unfurl@latest"
        "waybackurls:github.com/tomnomnom/waybackurls@latest"
        "gobuster:github.com/OJ/gobuster@latest"
        "ffuf:github.com/ffuf/ffuf@latest"
        "nuclei:github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest"
    )
    
    local total=${#GO_TOOLS[@]}
    local current=0
    
    for tool_pair in "${GO_TOOLS[@]}"; do
        ((current++))
        local tool_name="${tool_pair%%:*}"
        local tool_url="${tool_pair##*:}"
        
        if [ -e ~/go-workspace/bin/"${tool_name}" ]; then
            log_status "[${current}/${total}] ${tool_name} is already installed"
        else
            log_info "[${current}/${total}] Installing ${tool_name}..."
            if $GOROOT/bin/go install "${tool_url}" > /dev/null 2>&1; then
                log_info "[${current}/${total}] ✓ ${tool_name} installed"
                
                if [ "${tool_name}" = "nuclei" ]; then
                    log_info "Downloading nuclei templates..."
                    ~/go-workspace/bin/nuclei -update-templates > /dev/null 2>&1 && log_info "✓ Nuclei templates downloaded"
                fi
            else
                log_warn "[${current}/${total}] ✗ Failed to install ${tool_name}"
            fi
        fi
    done
}

# Function to install github tools
install_github_tools() {
    log_status "Installing tools from GitHub repositories..."
    sleep 1
    
    mkdir -p ~/arsenal
    cd ~/arsenal || return 1
    
    local GITHUB_REPOS=(
        "teh_s3_bucketeers:https://github.com/tomdev/teh_s3_bucketeers.git"
        "JSParser:https://github.com/nahamsec/JSParser.git"
        "Sublist3r:https://github.com/aboul3la/Sublist3r.git"
        "dirsearch:https://github.com/maurosoria/dirsearch.git"
        "lazys3:https://github.com/nahamsec/lazys3.git"
        "virtual-host-discovery:https://github.com/jobertabma/virtual-host-discovery.git"
        "knock:https://github.com/guelfoweb/knock.git"
        "lazyrecon:https://github.com/nahamsec/lazyrecon.git"
        "massdns:https://github.com/blechschmidt/massdns.git"
        "asnlookup:https://github.com/yassineaboukir/asnlookup.git"
        "crtndstry:https://github.com/nahamsec/crtndstry.git"
        "enum4linux:https://github.com/CiscoCXSecurity/enum4linux.git"
    )
    
    local total=${#GITHUB_REPOS[@]}
    local current=0
    
    for repo_pair in "${GITHUB_REPOS[@]}"; do
        ((current++))
        local repo_name="${repo_pair%%:*}"
        local repo_url="${repo_pair##*:}"
        
        if [ -d ~/arsenal/"${repo_name}" ]; then
            log_status "[${current}/${total}] ${repo_name} already installed"
        else
            log_info "[${current}/${total}] Installing ${repo_name}..."
            if git clone "${repo_url}" ~/arsenal/"${repo_name}" > /dev/null 2>&1; then
                log_info "[${current}/${total}] ✓ ${repo_name} cloned"
                
                case "${repo_name}" in
                    JSParser)
                        if cd ~/arsenal/JSParser && pip3 install -r requirements.txt > /dev/null 2>&1 && python3 setup.py install > /dev/null 2>&1; then
                            log_info "[${current}/${total}] ✓ JSParser dependencies installed"
                        fi
                        ;;
                    Sublist3r)
                        if cd ~/arsenal/Sublist3r && pip3 install -r requirements.txt > /dev/null 2>&1 && python3 setup.py install > /dev/null 2>&1; then
                            log_info "[${current}/${total}] ✓ Sublist3r dependencies installed"
                        fi
                        ;;
                    massdns)
                        if cd ~/arsenal/massdns && make > /dev/null 2>&1 && $SUDO make install > /dev/null 2>&1; then
                            log_info "[${current}/${total}] ✓ massdns compiled and installed"
                        fi
                        ;;
                    asnlookup)
                        if cd ~/arsenal/asnlookup && pip3 install -r requirements.txt > /dev/null 2>&1; then
                            log_info "[${current}/${total}] ✓ asnlookup dependencies installed"
                        fi
                        ;;
                    enum4linux)
                        if cd ~/arsenal/enum4linux && chmod +x enum4linux.pl; then
                            log_info "[${current}/${total}] ✓ enum4linux permissions set"
                        fi
                        ;;
                esac
            else
                log_warn "[${current}/${total}] ✗ Failed to clone ${repo_name}"
            fi
        fi
    done
    
    log_info "Downloading SecLists..."
    if [ ! -d ~/arsenal/SecLists ]; then
        if git clone https://github.com/danielmiessler/SecLists.git ~/arsenal/SecLists > /dev/null 2>&1; then
            log_info "✓ SecLists downloaded"
            if [ -f ~/arsenal/SecLists/Discovery/DNS/dns-Jhaddix.txt ]; then
                head -n -14 ~/arsenal/SecLists/Discovery/DNS/dns-Jhaddix.txt > ~/arsenal/SecLists/Discovery/DNS/clean-jhaddix-dns.txt
            fi
        else
            log_warn "✗ Failed to download SecLists"
        fi
    else
        log_status "SecLists already installed"
    fi
    
    log_info "Installing Spiderfoot..."
    if [ ! -d ~/arsenal/spiderfoot-3.3 ]; then
        if wget -q https://github.com/smicallef/spiderfoot/archive/v3.3.tar.gz -O /tmp/spiderfoot.tar.gz; then
            tar -xzf /tmp/spiderfoot.tar.gz -C ~/arsenal
            if cd ~/arsenal/spiderfoot-3.3 && pip3 install -r requirements.txt > /dev/null 2>&1; then
                log_info "✓ Spiderfoot installed"
            fi
            rm -f /tmp/spiderfoot.tar.gz
        else
            log_warn "✗ Failed to download Spiderfoot"
        fi
    else
        log_status "Spiderfoot already installed"
    fi
}

# Function to install additional security tools
install_security_tools() {
    log_status "Installing additional security tools..."
    sleep 1
    
    log_info "Installing Metasploit Framework..."
    if curl -s https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > /tmp/msfinstall && chmod 755 /tmp/msfinstall; then
        if /tmp/msfinstall > /dev/null 2>&1; then
            log_info "✓ Metasploit Framework installed"
        else
            log_warn "✗ Metasploit installation had issues"
        fi
        rm -f /tmp/msfinstall
    else
        log_warn "✗ Failed to download Metasploit installer"
    fi
    
    log_info "Installing Maltego..."
    if wget -q https://maltego-downloads.s3.us-east-2.amazonaws.com/linux/Maltego.v4.3.1.deb -O /tmp/Maltego.deb; then
        if $SUDO dpkg -i /tmp/Maltego.deb > /dev/null 2>&1; then
            log_info "✓ Maltego installed"
        else
            log_warn "✗ Maltego installation had issues"
        fi
        rm -f /tmp/Maltego.deb
    else
        log_warn "✗ Failed to download Maltego"
    fi
    
    log_info "Installing WPScan..."
    if $SUDO gem install wpscan > /dev/null 2>&1; then
        log_info "✓ WPScan installed"
    else
        log_warn "✗ Failed to install WPScan"
    fi
    
    log_info "Installing Social Engineer Toolkit..."
    if git clone https://github.com/trustedsec/social-engineer-toolkit.git /tmp/setoolkit > /dev/null 2>&1; then
        if cd /tmp/setoolkit && pip3 install -r requirements.txt > /dev/null 2>&1 && $SUDO python3 setup.py > /dev/null 2>&1; then
            log_info "✓ Social Engineer Toolkit installed"
        else
            log_warn "✗ Social Engineer Toolkit installation had issues"
        fi
        rm -rf /tmp/setoolkit
    else
        log_warn "✗ Failed to clone Social Engineer Toolkit"
    fi
}

# Function to display completion message
show_completion_message() {
    clear
    show_banner
    echo ""
    echo -e "${green}╔════════════════════════════════════════════╗${reset}"
    echo -e "${green}║     INSTALLATION COMPLETED SUCCESSFULLY!   ║${reset}"
    echo -e "${green}╚════════════════════════════════════════════╝${reset}"
    echo ""
    echo -e "${cyan}Your Ubuntu system is ready for offensive security testing!${reset}"
    echo ""
    echo -e "${yellow}Important Information:${reset}"
    echo "  • Go tools installed in: ~/go-workspace/bin"
    echo "  • Arsenal tools installed in: ~/arsenal"
    echo "  • Apply environment variables: ${cyan}source ~/.bash_aliases${reset}"
    echo ""
    echo -e "${blue}Github: https://github.com/0xRyuk${reset}"
    echo ""
}

# Main execution loop
main() {
    while true; do
        show_main_menu
        local choice=$(get_user_choice)
        
        case "$choice" in
            1) install_apt_packages ;;
            2) install_snap_packages ;;
            3) install_golang && install_go_tools ;;
            4) install_github_tools ;;
            5) install_security_tools ;;
            6)
                log_info "Installing ALL components..."
                install_apt_packages
                install_snap_packages
                install_golang
                install_go_tools
                install_github_tools
                install_security_tools
                show_completion_message
                exit 0
                ;;
            7)
                log_info "Exiting installation script"
                exit 0
                ;;
            *)
                log_error "Invalid choice. Please enter a number between 1 and 7"
                ;;
        esac
        
        echo ""
        read -p "Press Enter to continue..."
    done
}

# Run the script
initialize_setup
main
