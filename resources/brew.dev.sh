#!/bin/bash

###############################################################################
# `brew install` packages for development
###############################################################################

packages={
    awscli
    azure-cli
    docker-completion
    docker-machine-completion
    docker-compose-completion
    kubectl
    kubernetes-helm
    pipenv
    pyenv
    terraform
    vault
}

cask=(
    docker
    google-cloud-sdk
    iterm2
    # jetbrains-toolbox
    minikube
    vagrant
    vagrant-manager
    virtualbox
    visual-studio-code
    xquartz
)

# Install the packages defined in `packages`
for package in ${packages[@]}; do
    brew install $package || true
done

# Install the packages defined in `cask`
for package in ${cask[@]}; do
    brew cask install $package || true
done

