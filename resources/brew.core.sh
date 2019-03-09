#!/bin/bash

###############################################################################
# `brew install` packages that are "essential"
###############################################################################

packages=(
    autojump
    bash
    bash-completion
    bat
    coreutils
    curl
    exa
    git
    gnupg
    jq
    openssl
    pstree
    ripgrep
    rlwrap
    the_silver_searcher
    tree
    vim
    watch
    wget
)

cask=(
    iterm2
    the-unarchiver
)

# Install the packages defined in `packages`
for package in ${packages[@]}; do
    brew install $package || true
done

# Install the packages defined in `cask`
for package in ${cask[@]}; do
    brew cask install $package || true
done