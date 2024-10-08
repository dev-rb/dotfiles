#!/bin/bash

pkgs=(zsh curl)
sudo apt install "${pkgs[@]}" 
curl -L https://nixos.org/nix/install | sh -s -- --daemon
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update

source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh

nix-shell --run 'home-manager switch --flake home-manager/#dev-rb'

# home-manager switch --flake home-manager/#dev-rb

ln -s .zsh/.zshrc ~/.zshrc
