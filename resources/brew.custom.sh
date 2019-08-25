#!/bin/bash

###############################################################################
# `brew install` packages based on personal preference
###############################################################################

packages=(
    joplin
    pass
)

cask=(
    1password
    calibre
    dozer
    gas-mask
    spectacle
    spotify
    vlc
)

# Install the packages defined in `packages`
for package in ${packages[@]}; do
    brew install $package || true
done

brew tap caskroom/cask || true

# Install the packages defined in `cask`
for package in ${cask[@]}; do
    brew cask install $package || true
done
