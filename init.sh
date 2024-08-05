#!/bin/bash

pkgs=(zsh curl)
sudo apt install "${pkgs[@]}" 
curl -L https://nixos.org/nix/install | sh -s -- --daemon

ln -s .zsh/.zshrc ~/.zshrc
