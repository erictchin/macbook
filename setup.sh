#!/bin/sh

###############################################################################
# Install xcode command line tools if necessary
###############################################################################

# Ask for the administrator password upfront.
sudo -v

# Keep Sudo Until Script is finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Ensure Xcode Command line tools are installed
if ! (type xcode-select >&- && xpath=$( xcode-select --print-path ) && test -d "${xpath}" && test -x "${xpath}") ; then
    echo "Installing `xcode` command line tools"

    # Install XCODE Command Line Tools
    xcode-select --install
fi

###############################################################################
# Install or upgrade homebrew
###############################################################################

which -s brew
if [[ $? != 0 ]] ; then
    echo "Installing Homebrew"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    echo "Updating Homebrew"
    brew update
fi