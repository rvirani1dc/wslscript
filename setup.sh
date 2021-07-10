#!/bin/bash

: '

	Script created so CEIT can install all the ubuntu packages we need while Im on vacation
	
	1. Check the OS Version
	2. Update the apt database
	3. Install the requiered command line utilities
		* tmux
		* powerline
		* git

	4. Install the JDK and Maven
	5. Install Node and NodeJS
	6. Install nodemon
	7. Setup the vim Config for Java
	8. Add Powerline to the .bashrc
'

APT_FLAGS="-y"
VALID_RELEASE="Ubuntu"
VALID_VERSION="20.04"

# This function checks the operating system and version is the correct one for our script.
function check_os_ver()	{

	 release=$(lsb_release -i | awk '{print $3}')	
	 version=$(lsb_release -r | awk '{print $2}')


	 if [ $version == $VALID_VERSION ] && [ $release == $VALID_RELEASE ]
	 then
		 echo "Operating System version check passed"
		 return 0 
	 else
		 echo "This script was created for Ubuntu 20.04 on Ubuntu Linux."
		 return 1 
	 fi

}

# This function just installs all the software we want for each course
function install_software() {

	apt-get update $APT_FLAGS

	echo "Installing command line utilities, tmux, powerline and git"
	apt-get install powerline powerline-gitstatus $APT_FLAGS

	echo "Installing software for CSIS 3275..."
	apt-get install openjdk-14-jdk $APT_FLAGS
	apt-get install nodejs npm $APT_FLAGS

	echo "Installing nodemon globally"
	npm install -g nodemon

	echo "Installing software for CSIS 3560..."
	apt install python3 python3-pip ipython3 powershell $APT_FLAGS
}

# Install powershell: https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-linux?view=powershell-7.1
function install_powershell() {

	# Install pre-requisite packages.
	sudo apt-get install $APT_FLAGS wget apt-transport-https software-properties-common

	# Download the Microsoft repository GPG keys
	wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb
	#Check if the file came down
	if [ -f packages-microsoft-prod.deb ]; 
	then

		# Register the Microsoft repository GPG keys
		sudo dpkg -i packages-microsoft-prod.deb
		# Update the list of products
		sudo apt-get update
		# Enable the "universe" repositories
		sudo add-apt-repository universe
		# Install PowerShell
		sudo apt-get install $APT_FLAGS powershell
	else
		echo "Problem downloading microsoft packages from packages.microsoft.com"
		exit;
	fi
}

function setup_vim()	{
cat << EOF > /home/csis/.vimrc
set ts=4 sw=4
syntax on
set nu
EOF

chown csis /home/csis/.vimrc
	
}

if check_os_ver

then
	install_software
	install_powershell
	setup_vim
else
	exit;
fi
