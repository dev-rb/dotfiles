#!/bin/bash

pkgs=(zsh curl)
sudo apt install "${pkgs[@]}" 
curl -L https://nixos.org/nix/install | sh -s -- --daemon
nix-shell '<home-manager>' -A install

home-manager switch --flake home-manager/#dev-rb

ln -s .zsh/.zshrc ~/.zshrc
