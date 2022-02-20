# nixpkgs-opt
This is a optional nixpkgs package input by boppyt, based on fortuneteller2k's nixpkgs-f2k.

## This repository is superseded by chaotic-nixpkgs.

# Usage

Flake enabled Nix:

```nix
{
  inputs.nixpkgs-opt.url = "github:boppyt/nixpkgs-opt";

  outputs = { self, nixpkgs-opt, ... }@inputs: {
    nixosConfigurations.desktop = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        { nixpkgs.overlays = [ nixpkgs-opt.overlay ]; }
        ./configuration.nix
      ];
    };
  }
}
```

I also provide a `defaultPackage` attribute (default is `eww`), and a `packages` attribute if overlays aren't your thing.

Non-flake enabled Nix, append to `configuration.nix`, or `home.nix`:
```nix
{
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/boppyt/nixpkgs-opt/archive/master.tar.gz;
    }))
  ];
}
```
