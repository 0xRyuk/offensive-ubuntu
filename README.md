# Offensive-Ubuntu v2.0

A comprehensive, interactive installation script for setting up an Ubuntu system with security testing tools, offensive security applications, and bug hunting utilities. This script automates the installation of 87+ packages including Kali Linux tools, penetration testing frameworks, and other third-party tools useful for CTFs, hacking, and security research.

## Features

✅ **Interactive Menu System** - Choose what to install or install everything at once  
✅ **Auto-Detection** - Automatically detects system architecture (x86_64, i386, arm64)  
✅ **Dynamic Go Version Detection** - Fetches and installs the latest Go version automatically  
✅ **Tool Updates** - Easy updating of all installed tools and packages  
✅ **Colored Output** - Enhanced readability with color-coded logging  
✅ **Progress Tracking** - Real-time progress indicators for all installations  
✅ **Error Handling** - Comprehensive error checking and recovery  
✅ **Backup & Recovery** - Automatic backups before updates with rollback support  

## Installation

### Quick Start

```bash
git clone https://github.com/0xRyuk/offensive-ubuntu.git
cd offensive-ubuntu
chmod +x install.sh
sudo ./install.sh
```

### Prerequisites

- Ubuntu 18.04 LTS or later
- Internet connection
- sudo privileges (required for package installation)
- At least 50GB free disk space (recommended)

## Usage

### Main Menu Options

Run the script to access the interactive menu:

```
╔════════════════════════════════════════════╗
║          OFFENSIVE UBUNTU INSTALLER       ║
╚════════════════════════════════════════════╝

Installation Components:
1) Install system packages (apt)
2) Install tools from snap
3) Install golang and go tools
4) Install tools from GitHub repositories
5) Install additional security tools (Metasploit, WPScan, etc)
6) Install ALL components

Maintenance & Updates:
7) Check and update this script
8) Update installed tools
9) Exit
```

### Option 1: Install System Packages (APT)
Installs 60+ essential packages including:
- Programming tools (python3, python2, perl, ruby, build-essential)
- Networking tools (nmap, net-tools, traceroute, dnsmap, dnsenum, dnsrecon)
- Penetration testing (aircrack-ng, hashcat, sqlmap, wfuzz, ettercap)
- Forensics & analysis (binwalk, steghide, foremost, sleuthkit, autopsy)
- Web testing (burp, ffuf, recon-ng, wafw00f, mitmproxy)
- Development (git, curl, wget, vim, sublime-text, openvpn)
- And many more specialized tools

### Option 2: Install Snap Packages
Installs tools from the Snap store:
- John the Ripper
- Volatility Framework
- Chromium Browser
- Amass (OWASP)

### Option 3: Install Go and Go-Based Tools
- Automatically detects the latest Go version from go.dev
- Installs/updates Go to the latest version
- Installs popular Go security tools:
  - **aquatone** - Web screenshot tool
  - **httprobe** - HTTP prober
  - **unfurl** - URL parsing
  - **waybackurls** - Wayback Machine URLs
  - **gobuster** - Directory and DNS brute-forcing
  - **ffuf** - Fast web fuzzer
  - **nuclei** - Vulnerability scanner with templates

### Option 4: Install GitHub Repository Tools
Clones and installs tools from GitHub repositories into `~/arsenal`:
- **JSParser** - JavaScript parser
- **Sublist3r** - Subdomain enumeration
- **dirsearch** - Directory brute-forcing
- **lazys3** - S3 bucket enumeration
- **virtual-host-discovery** - Virtual host discovery
- **knock** - Knockpy subdomain scanner
- **lazyrecon** - Automated reconnaissance
- **massdns** - DNS mass resolution
- **asnlookup** - ASN lookup tool
- **crtndstry** - Certificate transparency
- **enum4linux** - Linux/Samba enumeration
- **SecLists** - Common security lists
- **Spiderfoot** - OSINT automation framework (v4.0 latest)

### Option 5: Install Additional Security Tools
Installs advanced security frameworks:
- **Metasploit Framework** - Penetration testing framework
- **Maltego** - OSINT tool
- **WPScan** - WordPress vulnerability scanner
- **Social Engineer Toolkit** - Social engineering framework

### Option 6: Install ALL Components
Executes all installation options sequentially.

### Option 7: Check and Update Script
- Checks GitHub for newer versions of the script
- Compares versions automatically
- Creates timestamped backups before updating
- Updates and restarts with the latest version

### Option 8: Update Installed Tools
Opens a submenu to selectively update:
- System packages (apt upgrade)
- Snap packages
- Go and Go-based tools (with version checking)
- GitHub repositories (git pull + dependency reinstall)
- All tools at once

## Directory Structure

After installation, tools are organized as follows:

```
~
├── arsenal/                          # GitHub-cloned tools
│   ├── JSParser/
│   ├── Sublist3r/
│   ├── dirsearch/
│   ├── SecLists/
│   ├── spiderfoot-4.0/
│   └── ... (other repositories)
│
├── go-workspace/                     # Go workspace
│   ├── bin/                          # Go binaries
│   │   ├── aquatone
│   │   ├── ffuf
│   │   ├── gobuster
│   │   ├── nuclei
│   │   └── ... (other go tools)
│   ├── src/                          # Go source code
│   └── pkg/                          # Go packages
│
└── .bash_aliases                     # Environment variables
```

## Environment Setup

After installation, source the aliases to apply Go environment variables:

```bash
source ~/.bash_aliases
```

Or add to your shell profile (~/.bashrc, ~/.zshrc):

```bash
export GOROOT=/usr/local/go
export GOPATH=$HOME/go-workspace
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
```

## Logging

The script provides color-coded output:

- **[INFO]** - Informational messages and successful operations
- **[WARN]** - Warnings and non-critical issues
- **[ERROR]** - Error messages
- **[STATUS]** - Status updates

Each installation shows progress: `[current/total]` with ✓ for success and ✗ for failures.

## Packages Installed (87+)

### System & Development
recordmydesktop, python3, python2, vim, python3-pip, python-setuptools, build-essential, perl, ruby-full, git, curl, wget, rename, jq

### Networking & Reconnaissance
net-tools, traceroute, nmap, aircrack-ng, dnsmap, dnsenum, dnsrecon, dnswalk, netdiscover, netmask, nbtscan, xprobe, masscan, iputils-arping, arping, netsniff-ng

### Web Testing & Fuzzing
burp, wfuzz, wafw00f, mitmproxy, ffuf, dirbuster, sqlmap, recon-ng, httrack, httpprobe, unfurl, waybackurls

### Cryptography & Hashing
hashcat, john-the-ripper, openjdk-11-jre, openjdk-8-jdk

### Wireless & Network
reaver, wifite, pixiewps, cowpatty, ettercap-graphical, btscanner

### Security & Analysis
hydra-gtk, steghide, binwalk, stegoveritas, libimage-exiftool-perl, backdoor-factory, chkrootkit, sleuthkit, foremost, recoverjpeg

### File & Data Analysis
hexedit, smbmap, dsniff, dmitry, beef, hashdeep, autopsy, libldns-dev, libcurl4-openssl-dev, libssl-dev, libffi-dev, libxml2, libxml2-dev, libxslt1-dev, libgmp-dev, zlib1g-dev

### VPN & Security Services
openvpn, openssh, wireshark-qt

### Additional Tools
sublime-text, chromium, amass, volatility-phocean, metasploit-framework, maltego, wpscan, spiderfoot (v4.0), crt.sh

## Troubleshooting

### Go Installation Issues

If Go installation fails, check:
- Internet connection: `ping go.dev`
- Available disk space: `df -h /usr/local`
- Permissions: Ensure sudo access

### Package Installation Failures

Some packages may fail due to:
- Missing dependencies: Install manually with `sudo apt-get install <package>`
- Repository issues: Update repositories with `sudo apt-get update`
- Deprecated packages: Check if they're still maintained

### Python 2 Deprecation

Python 2 is deprecated. If installation fails:
- This is expected on newer Ubuntu versions
- The script will skip Python 2 pip if unavailable
- Use Python 3 alternatives when possible

### Snap Installation Issues

If snap packages fail:
- Ensure snapd is installed: `sudo apt-get install snapd`
- Check snap permissions: `sudo usermod -aG snap $USER`

## Performance Tips

1. **Run on fresh Ubuntu install** - Fewer conflicts and faster installation
2. **Use SSD** - Significantly faster than HDD for installations
3. **Close other applications** - Free up system resources
4. **Run during off-peak hours** - Better download speeds
5. **Use `screen` or `tmux`** - Keeps installation running if SSH disconnects

```bash
screen -S install
sudo ./install.sh
# Press Ctrl+A then D to detach
screen -r install  # To reattach
```

## Updates & Maintenance

### Auto-Update Script

The script checks for updates on GitHub. To manually check:

```bash
./install.sh
# Select option 7
```

### Update All Tools

```bash
./install.sh
# Select option 8
# Then select option 5 for all updates
```

### Update Specific Categories

Update individual categories without full reinstallation:
- Option 8.1 - APT packages
- Option 8.2 - Snap packages
- Option 8.3 - Go tools
- Option 8.4 - GitHub repositories

## Uninstallation

To remove tools:

```bash
# Remove system packages
sudo apt-get remove <package-name>

# Remove Go tools
rm ~/go-workspace/bin/<tool-name>

# Remove GitHub tools
rm -rf ~/arsenal/<repo-name>

# Remove Go
sudo rm -rf /usr/local/go
```

## System Requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| OS | Ubuntu 18.04 LTS | Ubuntu 20.04 LTS+ |
| RAM | 2GB | 8GB+ |
| Disk Space | 20GB | 50GB+ |
| Internet | 1Mbps | 10Mbps+ |
| CPU | 2 cores | 4+ cores |

## Compatibility

- ✅ Ubuntu 18.04 LTS
- ✅ Ubuntu 20.04 LTS
- ✅ Ubuntu 22.04 LTS
- ✅ Debian 10+
- ⚠️ WSL 2 (requires some adaptations)
- ✅ ARM64 (Raspberry Pi, Apple Silicon via UTM)
- ✅ x86_64
- ✅ i386

## Security Notes

⚠️ This script installs penetration testing tools that can be misused. Use responsibly and only on systems you own or have permission to test.

- Never use these tools for unauthorized access
- Ensure proper authorization before testing
- Follow responsible disclosure guidelines
- Check local laws and regulations

## Contributing

Found a bug or want to add a tool? Please create an issue or pull request on GitHub.

## License

This project is open source and available under the MIT License.

## Author

**Ryuk** - [GitHub](https://github.com/0xRyuk)

## Support

For issues, questions, or suggestions:
1. Check existing issues on GitHub
2. Create a new issue with detailed information
3. Include your Ubuntu version and error messages

---

**Last Updated:** December 6, 2025  
**Version:** 2.0  
**Status:** Active & Maintained
