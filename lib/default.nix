{ inputs, lib }:
(import ./features.nix { inherit lib; }) // (import ./hosts.nix { inherit inputs; })
