#!/bin/bash
#
#
green='\033[1;32m'
red='\033[1;31m'
reset='\033[0m'

sudo apt-get update && apt-get upgrade -y
sleep 2
sudo apt install figlet
clear

echo -e "$red"
figlet "Offensive Ubuntu"
echo -e "$reset"
echo -e "$green preparing setup please wait..$reset"

sleep 5

#Installing tools using "sudo apt update"

PACKAGES=("recordmydesktop" "python3" "python2" "hashcat" "vim" "net-tools" "aircrack-ng" "traceroute" "python3-pip" "python-setuptools" "libimage-exiftool-perl" "binwalk" "steghide" "libldns-dev" "nmap" "build-essential" "libssl-dev" "libffi-dev" "python-dev" "hydra-gtk" "reaver" "wifite" "pixiewps" "cowpatty" "netcat" "ettercap-graphical" "btscanner" "dnsmap" "dnsenum" "dnsrecon" "dnswalk" "wafw00f" "mitmproxy" "macchanger" "dsniff" "chkrootkit" "backdoor-factory" "netsniff-ng" "iputils-arping" "sleuthkit" "xprobe" "masscan" "netdiscover" "netmask" "nbtscan" "hexedit" "proxytunnel" "foremost" "recoverjpeg" "smbmap" "dmitry" "sqlmap" "recon-ng" "autopsy" "hashdeep" "httrack" "burp" "wfuzz" "beef" "perl" "openjdk-11-jre" "libcurl4-openssl-dev" "ruby-full" "libxml2" "libxml2-dev" "libxslt1-dev" "ruby-dev" "libgmp-dev" "zlib1g-dev" "git" "curl" "wget" "openvpn" "openssh" "wireshark-qt" "openjdk-8-jdk" "libcurl4-openssl-dev" "libssl-dev" "jq" "python-dnspython" "rename")

for PKG in ${PACKAGES[@]}

do
	IS_INSTALLED=$(sudo dpkg-query -W --showformat='${Status}\n' ${PKG} | grep "install ok installed")
	if [ "${IS_INSTALLED}" == "install ok installed" ]
	then
		echo -e "${PKG} is installed."
	else
		sudo apt install -y ${PKG}
	fi
done

echo "Installing sublime text3"
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo apt-get install apt-transport-https
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt-get update
sudo apt-get install sublime-text
echo "Done"

echo "Installing python2-pip"
curl -LO https://bootstrap.pypa.io/get-pip.py --output get-pip.py
python2 get-pip.py
sleep 1
rm get-pip.py
echo "Done"

echo "Installing stegoveritas"
pip3 install stegoveritas
stegoveritas_install_deps
echo "Done"

#Install using "sudo snap install <package-name>""


echo "Installing JohnTheRipper"
sudo snap install john-the-ripper
echo "Done"

echo "Installing volatility"
sudo snap install volatility-phocean
echo "Done"

echo "Installing Chromium"
sudo snap install chromium
echo "Done"

echo "Installing Amass"
sudo snap install amass
echo "Done"



#Checking for golang

if [ ! -d /usr/local/go ]
then
	echo "Installing golang!!"
	#sudo snap install go --classic
	wget https://dl.google.com/go/go1.15.7.linux-amd64.tar.gz
	sudo tar -C /usr/local/ -xzf go1.15.7.linux-amd64.tar.gz
	export GOROOT=/usr/local/go
	export GOPATH=$HOME/go-workspace
	export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
	echo "export GOROOT=/usr/local/go">>~/.profile
	echo "export GOPATH=$HOME/go-workspace">>~/.profile
	echo "export PATH=$GOPATH/bin:$GOROOT/bin:$PATH">>~/.profile
	source ~/.profile
	echo "Done"
	sleep 2
else
	echo "Golang already installed!"
fi
mkdir ~/tools
cd ~/tools/

echo "Checking for existing packages"

#Installing golang based tools using "go get <package-url>" these tools can be find in "~/go-workspace/bin"

if [ ! -e ~/go-workspace/bin/aquatone ]
then
	#install aquatone
	echo "Installing Aquatone"
	go get github.com/michenriksen/aquatone
	echo "Done"
else
	echo "Aquatone already installed"
fi

if [ ! -e ~/go-workspace/bin/httprobe ]
then
	echo "Installing httprobe"
	go get -u github.com/tomnomnom/httprobe 
	echo "Done"
else
	echo "httprobe already installed"
fi

if [ ! -e ~/go-workspace/bin/unfurl ]
then
	echo "Installing unfurl"
	go get -u github.com/tomnomnom/unfurl 
	echo "Done"
else
	echo "unfurl already installed"
fi

if [ ! -e ~/go-workspace/bin/waybackurls ]
then
	echo "Installing waybackurls"
	go get github.com/tomnomnom/waybackurls
	echo "Done"
else
	echo "waybackurls already installed"
fi

if [ ! -e ~/go-workspace/bin/gobuster ]
then
	echo "Instaling gobuster"
	go get github.com/OJ/gobuster
	echo "Done"
else
	echo "gobuster already installed"
fi

if [ ! -e ~/go-workspace/bin/ffuf ]
then
	echo "Installing ffuf"
	go get -u github.com/ffuf/ffuf
	echo "Done"
else
	echo "ffuf already installed"
fi

if [ ! -e ~/go-workspace/bin/nuclie ]
then
	echo "Installing ffuf"
	echo "Installing nuclie"
	sudo GO111MODULE=on go get -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei
	echo "Installing nuclie templets"
	nuclie -update-templates
	echo "Done"
else
	echo "nuclie already installed"
fi


#Installing packages from github, these packages can be find in "~/tools"

cd ~/tools

if [ ! -d ~/tools/teh_s3_bucketeers ]
then
	echo "Installing teh_s3_bucketeers"
	git clone https://github.com/tomdev/teh_s3_bucketeers.git
	echo "Done"
else
	echo "JSParser already installed"
fi

if [ ! -d ~/tools/JSParser ]
then
	echo "Installing JSParser"
	git clone https://github.com/nahamsec/JSParser.git
	cd JSParser*
	sudo python setup.py install
	cd ~/tools/
	echo "Done"
else
	echo "JSParser already installed"
fi

if [ ! -d ~/tools/Sublist3r ]
then
	echo "Installing Sublist3r"
	git clone https://github.com/aboul3la/Sublist3r.git
	cd Sublist3r*
	pip install -r requirements.txt
	python3 setup.py install
	cd ~/tools/
	echo "Done"
else
	echo "Sublist3r already installed"
fi

if [ ! -d ~/tools/dirsearch ]
then
	echo "Installing dirsearch"
	git clone https://github.com/maurosoria/dirsearch.git
	cd ~/tools/
	echo "Done"
else
	echo "dirsearch already installed"
fi

if [ ! -d ~/tools/lazys3 ]
then
	echo "Installing lazys3"
	git clone https://github.com/nahamsec/lazys3.git
	cd ~/tools/
	echo "Done"
else
	echo "lazys3 already installed"
fi

if [ ! -d ~/tools/virtual-host-discovery ]
then
	echo "Installing virtual host discovery"
	git clone https://github.com/jobertabma/virtual-host-discovery.git
	cd ~/tools/
	echo "Done"
else
	echo "virtual-host-discovery already installed"
fi

if [ ! -d ~/tools/knock ]
then
	echo "Installing knock.py"
	git clone https://github.com/guelfoweb/knock.git
	cd ~/tools/
	echo "Done"
else
	echo "knock.py already installed"
fi

if [ ! -d ~/tools/lazyrecon ]
then
	echo "Installing lazyrecon"
	git clone https://github.com/nahamsec/lazyrecon.git
	cd ~/tools/
	echo "Done"
else
	echo "lazyrecon already installed"
fi

if [ ! -d ~/tools/massdns ]
then
	echo "Installing massdns"
	git clone https://github.com/blechschmidt/massdns.git
	cd ~/tools/massdns
	make
	make install
	cd ~/tools/
	echo "Done"
else
	echo "massdns already installed"
fi

if [ ! -d ~/tools/asnlookup ]
then
	echo "Installing asnlookup"
	git clone https://github.com/yassineaboukir/asnlookup.git
	cd ~/tools/asnlookup
	pip install -r requirements.txt
	cd ~/tools/
	echo "Done"
else
	echo "asnlookup already installed"
fi

if [ ! -d ~/tools/crtndstry ]
then
	echo "Installing crtndstry"
	git clone https://github.com/nahamsec/crtndstry.git
	echo "Done"
else
	echo "crtndstry already installed"
fi

if [ ! -d ~/tools/Seclists ]
then
	echo "Downloading Seclists"
	cd ~/tools/
	git clone https://github.com/danielmiessler/SecLists.git
	cd ~/tools/SecLists/Discovery/DNS/
	##THIS FILE BREAKS MASSDNS AND NEEDS TO BE CLEANED
	cat dns-Jhaddix.txt | head -n -14 > clean-jhaddix-dns.txt
	cd ~/tools/
	echo "Done"
else
	echo "Seclists already installed"
fi

if [ ! -d ~/tools/Spiderfoot ]
then
	echo "Installing Spiderfoot"
	cd ~/tools/
	wget https://github.com/smicallef/spiderfoot/archive/v3.3.tar.gz
	tar zxvf v3.3.tar.gz
	cd ~/tools/spiderfoot
	pip3 install -r requirements.txt
	cd ~/tools/
	rm v3.3.tar.gz
	echo "Done"
else
	echo "Spiderfoot already installed"
fi

if [ ! -d ~/tools/enum4linux ]
then
	echo "Installing enum4linux"
	git clone https://github.com/CiscoCXSecurity/enum4linux.git
	chmod +x enum4linux/enum4linux.pl
	echo "Done"
else
	echo "enum4linux already installed"
fi

if [ ! -d ~/opt/dirbuster ]
then
	echo "Installing Dirbuster"
	cd ~/tools/
	git clone https://gitlab.com/kalilinux/packages/dirbuster.git
	sudo mv dirbuster /opt
	alias dirbuster="source /opt/dirbuster/DirBuster-1.0-RC1.sh"
	echo "Done"
else
	echo "Dirbuster already installed"
fi

echo "Installing Metasploit-framework"
curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && chmod 755 msfinstall && ./msfinstall
rm msfinstall
echo "Done"

echo "Installing Maletgo"
curl -LO https://maltego-downloads.s3.us-east-2.amazonaws.com/linux/Maltego.v4.2.15.13632.deb
sudo dpkg -i Maltego.v4.2.15.13632.deb
sleep 1
echo "Done"

echo "Installing wpscan"
sudo gem install wpscan
echo "Done"

echo "Installing SEToolkit"
git clone https://github.com/trustedsec/social-engineer-toolkit/ setoolkit/
cd setoolkit
pip3 install -r requirements.txt
sudo python3 setup.py
rm -rf setoolkit
echo "Done"
clear

echo -e "$red"
figlet "Offensive Ubuntu"
echo "Github : https://github.com/Ryuk0x01"
echo -e "$reset"
echo "Installation compeleted."
echo "Your ubuntu is ready to use!"
sleep 5
exit
