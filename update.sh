#!/bin/bash
set -x

unamestr=$(uname)
if [[ "$unamestr" == 'Darwin' ]]; then
    #
    # Ensure Brew is installed and updated
    # 
    which -s brew
    if [[ $? != 0 ]] ; then
        # Install Homebrew
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Run the Brewfile
        brew bundle install --file=Brewfile
    else
       brew update && brew upgrade && brew cleanup
       brew cu -a -f
       #brew bundle dump
    fi

    #
    # Update all apps from the Apple App Store
    #
    mas upgrade

    brew services start tailscale

    #
    # MacOS Software Update 
    #
    softwareupdate -ia --verbose
    
elif [[ "$unamestr" == 'Linux' ]]; then
    # For Debian 12 / Raspberry PI

    # Export list of packages
    # dpkg --get-selections > rpi-packages.txt

    # Install baseline packages
    sudo dpkg --set-selections < rpi-packages.txt 
    sudo apt-get -y install

    # Update the list of available packages and their versions
    sudo apt-get update

    # Install available upgrades of all packages currently installed on the system
    sudo apt-get upgrade

    # Handle changing dependencies with new versions of packages
    sudo apt-get dist-upgrade

    # Perform a full upgrade, this may remove some packages in certain situations
    sudo apt full-upgrade

    # Update the Raspberry Pi firmware
    sudo rpi-update

    # Update the Raspberry Pi EEPROM images
    sudo rpi-eeprom-update
fi

#
# Common
# 
npm install npm@latest -g
npm update -g
npx npm-check --global --update-all
