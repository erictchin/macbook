#!/bin/bash

###############################################################################
# `brew install` packages for development
###############################################################################

packages=(
    awscli
    azure-cli
    b2-tools
    docker-completion
    docker-machine-completion
    docker-compose-completion
    helmfile
    kubectl
    kubectx
    kubernetes-helm
    pyenv
    pipenv
    tfenv
)

cask=(
    docker
    iterm2
    minikube
    virtualbox
    visual-studio-code
)

# Install the packages defined in `packages`
for package in ${packages[@]}; do
    brew install $package || true
done

# Install the packages defined in `cask`
for package in ${cask[@]}; do
    brew cask install $package || true
done

