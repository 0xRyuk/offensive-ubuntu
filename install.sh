#!/bin/bash
#
#
green='\033[1;32m'
red='\033[1;31m'
cyan="\[\033[0;36m\]"
yellow="\[\033[0;33m\]"
reset='\033[0m'

# Get the architecture of the system
architecture=$(uname -m)

# Check the architecture and print a message
if [ "$architecture" == "x86_64" ]; then
    AARCH="amd64"
    elif [ "$architecture" == "i686" || "$architecture" == "i386" ]; then
    AARCH="386"
    elif [ "$architecture" == "arm64" ]; then
    AARCH="arm64"
else
    echo -e "$red Unable to determine system architecture. $reset"
fi

sudo apt-get update && apt-get upgrade -y
sleep 2
sudo apt install figlet
clear

echo -e "$red"
figlet "Offensive Ubuntu"
echo -e "$reset"
echo -e "$green preparing setup please wait..$reset"

sleep 5

#Installing packages using "apt package manager"

PACKAGES=("recordmydesktop" "python3" "python2" "hashcat" "vim" "net-tools" "aircrack-ng" "traceroute" "python3-pip" "python-setuptools" "libimage-exiftool-perl" "binwalk" "steghide" "libldns-dev" "nmap" "build-essential" "libssl-dev" "libffi-dev" "python-dev" "hydra-gtk" "reaver" "wifite" "pixiewps" "cowpatty" "netcat" "ettercap-graphical" "btscanner" "dnsmap" "dnsenum" "dnsrecon" "dnswalk" "wafw00f" "mitmproxy" "macchanger" "dsniff" "chkrootkit" "backdoor-factory" "netsniff-ng" "iputils-arping" "sleuthkit" "xprobe" "masscan" "netdiscover" "netmask" "nbtscan" "hexedit" "proxytunnel" "foremost" "recoverjpeg" "smbmap" "dmitry" "sqlmap" "recon-ng" "autopsy" "hashdeep" "httrack" "burp" "wfuzz" "beef" "perl" "openjdk-11-jre" "libcurl4-openssl-dev" "ruby-full" "libxml2" "libxml2-dev" "libxslt1-dev" "ruby-dev" "libgmp-dev" "zlib1g-dev" "git" "curl" "wget" "openvpn" "openssh" "wireshark-qt" "openjdk-8-jdk" "libcurl4-openssl-dev" "libssl-dev" "jq" "python-dnspython" "rename")

for PKG in ${PACKAGES[@]}
do
    IS_INSTALLED=$(sudo dpkg-query -W --showformat='${Status}\n' ${PKG} | grep "install ok installed")
    if [ "${IS_INSTALLED}" == "install ok installed" ]
    then
        echo -e "$cyan ${PKG} is already installed. $reset"
    else
        echo -e "$green Installing ${PKG}. $reset"
        sudo apt install -y ${PKG}
    fi
done

echo -e "$green Installing sublime-text3 $reset"
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo apt-get install -y apt-transport-https
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt-get update
sudo apt-get install -y sublime-text
echo -e "$green Done $reset"

echo -e "$green Installing python2-pip $reset"
curl -LO https://bootstrap.pypa.io/get-pip.py --output get-pip.py
python2 get-pip.py
sleep 1
rm get-pip.py
echo -e "$green Done $reset"

echo -e "$green Installing stegoveritas $reset"
pip3 install stegoveritas
stegoveritas_install_deps
echo -e "$green Done $reset"

#Install using "snap store"


echo -e "$green Installing JohnTheRipper $reset"
sudo snap install john-the-ripper
echo -e "$green Done $reset"

echo -e "$green Installing volatility $reset"
sudo snap install volatility-phocean
echo -e "$green Done $reset"

echo -e "$green Installing Chromium $reset"
sudo snap install chromium
echo -e "$green Done $reset"

echo -e "$green Installing Amass $reset"
sudo snap install amass
echo -e "$green Done $reset"

# setup file for aliases

if [ ! -f "~/.bash_aliases" ]
then
	echo -e "Creating file $yellow .bash_aliases$reset!"
    touch ~/.bash_aliases
    sudo chmod 644 ~/.bash_aliases
fi

#Checking for golang

if [ ! -d /usr/local/go ]
then
    echo -e "$green Installing golang! $reset"
    #sudo snap install go --classic
    wget https://dl.google.com/go/go1.23.3.linux-${AARCH}.tar.gz
    sudo tar -C /usr/local/ -xzf go1.23.3.linux-${AARCH}.tar.gz
    echo "export GOROOT=/usr/local/go">>~/.bash_aliases
    echo "export GOPATH=$HOME/go-workspace">>~/.bash_aliases
    echo "export PATH=$GOPATH/bin:$GOROOT/bin:$PATH">>~/.bash_aliases
    source ~/.bashrc
    echo -e "$green Done $reset"
    sleep 2
else
    echo "Golang already installed!"
fi

if [ ! -d "~/arsenal" ]
then
    echo -e "$cyan Creating directory for 'arsenal'. $reset"
    mkdir ~/arsenal
fi
cd ~/arsenal/

echo -e "$yellow Checking for existing go packages... $reset"

#Installing golang based tools using "go install <package-url>" these tools can be find in "~/go-workspace/bin"

if [ ! -e ~/go-workspace/bin/aquatone ]
then
    #install aquatone
    echo -e "$green Installing Aquatone $reset"
    go install github.com/michenriksen/aquatone@latest
    echo -e "$green Done $reset"
else
    echo -e "$yellow Aquatone is already installed $reset"
fi

if [ ! -e ~/go-workspace/bin/httprobe ]
then
    echo -e "$green Installing httprobe $reset"
    go install github.com/tomnomnom/httprobe@latest
    echo -e "$green Done $reset"
else
    echo -e "$yellow httprobe is already installed $reset"
fi

if [ ! -e ~/go-workspace/bin/unfurl ]
then
    echo -e "$green Installing unfurl $reset"
    go install github.com/tomnomnom/unfurl@latest
    echo -e "$green Done $reset"
else
    echo -e "$yellow unfurl is already installed $reset"
fi

if [ ! -e ~/go-workspace/bin/waybackurls ]
then
    echo "Installing waybackurls"
    go install github.com/tomnomnom/waybackurls@latest
    echo -e "$green Done $reset"
else
    echo -e "$yellow waybackurls is already installed $reset"
fi

if [ ! -e ~/go-workspace/bin/gobuster ]
then
    echo -e "$green Instaling gobuster $reset"
    go install github.com/OJ/gobuster@latest
    echo -e "$green Done $reset"
else
    echo -e "$yellow gobuster is already installed $reset"
fi

if [ ! -e ~/go-workspace/bin/ffuf ]
then
    echo -e "$green Installing ffuf $reset"
    go install github.com/ffuf/ffuf@latest
    echo -e "$green Done $reset"
else
    echo -e "$yellow ffuf is already installed $reset"
fi

if [ ! -e ~/go-workspace/bin/nuclie ]
then
    echo -e "$green Installing nuclie $reset"
    go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
    echo -e "$green Installing nuclie templets $reset"
    nuclie -update-templates
    echo -e "$green Done $reset"
else
    echo -e "$yellow nuclie is already installed $reset"
fi


#Installing packages from github, these packages can be find in "~/arsenal"

cd ~/arsenal

if [ ! -d ~/arsenal/teh_s3_bucketeers ]
then
    echo -e "$green Installing teh_s3_bucketeers $reset"
    git clone https://github.com/tomdev/teh_s3_bucketeers.git
    echo -e "$green Done $reset"
else
    echo -e "$yellow JSParser is already installed $reset"
fi

if [ ! -d ~/arsenal/JSParser ]
then
    echo -e "$green Installing JSParser $reset"
    git clone https://github.com/nahamsec/JSParser.git
    cd JSParser*
    sudo python setup.py install
    cd ~/arsenal/
    echo -e "$green Done $reset"
else
    echo -e "$yellow JSParser is already installed $reset"
fi

if [ ! -d ~/arsenal/Sublist3r ]
then
    echo -e "$green Installing Sublist3r $reset"
    git clone https://github.com/aboul3la/Sublist3r.git
    cd Sublist3r*
    pip install -r requirements.txt
    python3 setup.py install
    cd ~/arsenal/
    echo -e "$green Done $reset"
else
    echo -e "$yellow Sublist3r is already installed $reset"
fi

if [ ! -d ~/arsenal/dirsearch ]
then
    echo -e "$green Installing dirsearch $reset"
    git clone https://github.com/maurosoria/dirsearch.git
    cd ~/arsenal/
    echo -e "$green Done $reset"
else
    echo -e "$yellow dirsearch is already installed $reset"
fi

if [ ! -d ~/arsenal/lazys3 ]
then
    echo -e "$green Installing lazys3 $reset"
    git clone https://github.com/nahamsec/lazys3.git
    cd ~/arsenal/
    echo -e "$green Done $reset"
else
    echo -e "$yellow lazys3 is already installed $reset"
fi

if [ ! -d ~/arsenal/virtual-host-discovery ]
then
    echo -e "$green Installing virtual host discovery $reset"
    git clone https://github.com/jobertabma/virtual-host-discovery.git
    cd ~/arsenal/
    echo -e "$green Done $reset"
else
    echo -e "$yellow virtual-host-discovery is already installed $reset"
fi

if [ ! -d ~/arsenal/knock ]
then
    echo -e "$green Installing knock.py $reset"
    git clone https://github.com/guelfoweb/knock.git
    cd ~/arsenal/
    echo -e "$green Done $reset"
else
    echo -e "$yellow knock.py is already installed $reset"
fi

if [ ! -d ~/arsenal/lazyrecon ]
then
    echo -e "$green Installing lazyrecon $reset"
    git clone https://github.com/nahamsec/lazyrecon.git
    cd ~/arsenal/
    echo -e "$green Done $reset"
else
    echo -e "$yellow lazyrecon is already installed $reset"
fi

if [ ! -d ~/arsenal/massdns ]
then
    echo -e "$green Installing massdns $reset"
    git clone https://github.com/blechschmidt/massdns.git
    cd ~/arsenal/massdns
    make
    make install
    cd ~/arsenal/
    echo -e "$green Done $reset"
else
    echo -e "$yellow massdns is already installed $reset"
fi

if [ ! -d ~/arsenal/asnlookup ]
then
    echo -e "$green Installing asnlookup $reset"
    git clone https://github.com/yassineaboukir/asnlookup.git
    cd ~/arsenal/asnlookup
    pip install -r requirements.txt
    cd ~/arsenal/
    echo -e "$green Done $reset"
else
    echo -e "$yellow asnlookup is already installed $reset"
fi

if [ ! -d ~/arsenal/crtndstry ]
then
    echo -e "$green Installing crtndstry $reset"
    git clone https://github.com/nahamsec/crtndstry.git
    echo -e "$green Done $reset"
else
    echo -e "$yellow crtndstry is already installed $reset"
fi

if [ ! -d ~/arsenal/Seclists ]
then
    echo -e "$green Downloading Seclists $reset"
    cd ~/arsenal/
    git clone https://github.com/danielmiessler/SecLists.git
    cd ~/arsenal/SecLists/Discovery/DNS/
    ##THIS FILE BREAKS MASSDNS AND NEEDS TO BE CLEANED
    cat dns-Jhaddix.txt | head -n -14 > clean-jhaddix-dns.txt
    cd ~/arsenal/
    echo -e "$green Done $reset"
else
    echo -e "$yellow SecLists are already installed $reset"
fi

if [ ! -d ~/arsenal/Spiderfoot ]
then
    echo -e "$green Installing Spiderfoot $reset"
    cd ~/arsenal/
    wget https://github.com/smicallef/spiderfoot/archive/v3.3.tar.gz
    tar zxvf v3.3.tar.gz
    cd ~/arsenal/spiderfoot-3.3
    pip3 install -r requirements.txt
    cd ~/arsenal/
    rm v3.3.tar.gz
    echo -e "$green Done $reset"
else
    echo -e "$yellow Spiderfoot is already installed $reset"
fi

if [ ! -d ~/arsenal/enum4linux ]
then
    echo -e "$green Installing enum4linux $reset"
    git clone https://github.com/CiscoCXSecurity/enum4linux.git
    chmod +x enum4linux/enum4linux.pl
    echo -e "$green Done $reset"
else
    echo -e "$yellow enum4linux is already installed $reset"
fi

if [ ! -d ~/opt/dirbuster ]
then
    echo -e "$green Installing Dirbuster $reset"
    cd ~/arsenal/
    git clone https://gitlab.com/kalilinux/packages/dirbuster.git
    sudo mv dirbuster /opt
    alias dirbuster="source /opt/dirbuster/DirBuster-1.0-RC1.sh"
    echo -e "$green Done $reset"
else
    echo -e "$yellow Dirbuster is already installed $reset"
fi

echo -e "$green Installing Metasploit-framework $reset"
curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && chmod 755 msfinstall && ./msfinstall
rm msfinstall
echo -e "$green Done $reset"

echo -e "$green Installing Maletgo $reset"
curl -LO https://maltego-downloads.s3.us-east-2.amazonaws.com/linux/Maltego.v4.3.1.deb
sudo dpkg -i Maltego.v4.3.1.deb
sleep 1
echo -e "$green Done $reset"

echo -e "$green Installing wpscan $reset"
sudo gem install wpscan
echo -e "$green Done $reset"

echo -e "$green Installing SEToolkit $reset"
git clone https://github.com/trustedsec/social-engineer-toolkit/ setoolkit/
cd setoolkit
pip3 install -r requirements.txt
sudo python3 setup.py
rm -rf setoolkit
echo -e "$green Done $reset"
clear

echo -e "$red"
figlet "Offensive Ubuntu"
echo "Github : https://github.com/0xRyuk"
echo -e "$reset"
echo -e "$green Installation compeleted. $reset"
echo -e "$cyan Your ubuntu is ready to use! $reset"
sleep 5
exit 0
