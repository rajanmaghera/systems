# systems

[![Nix CI](https://github.com/rajanmaghera/systems/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/rajanmaghera/systems/actions/workflows/ci.yml)

When installed, this flake lives at the registry path `flake:s`.

## Installation from GitHub

Switch to a standalone home-manager config.

```
nix run github:rajanmaghera/systems#home-manager -- switch --flake github:rajanmaghera/systems#<machine-name>
```

Switch to a macOS config.

```
nix run github:rajanmaghera/systems#darwin-rebuild -- switch --flake github:rajanmaghera/systems#<machine-name>
```

Switch to a NixOS config.

```
nix run github:rajanmaghera/systems#nixos-rebuild -- switch --flake github:rajanmaghera/systems#<machine-name>
```


## Commands

Create a temporary shell with a package available.

```
nix shell s#<package-name>
```

Run a specific package.

```
nix run s#<package-name>
```

Update all Nix dependencies.

```
nix flake update
```

Remove all garbage.

```
sudo nh clean all
```

## Development shells

Launch a shell.

```
nix develop s#<shell-name> -c zsh
```

### Adding new nix machine to deploy stack

Have config ready for machine with disko setup.

Boot minimal (non-graphical) Nix machine.

Have SSH ability into the machine from this machine. Alternatively, install Tailscale.

Set password for nixos user.
```
passwd
```

Touch hardware configuration, add it to git, and import it.
```
touch ./machines/<machine-name>/hardware-configuration.nix
git add ./machines/<machine-name>/hardware-configuration.nix
```

Get block devices from machine and use it to construct local `disk-config.nix`
```
lsblk
```

Run nixos-anywhere on machine.
```
nix run github:nix-community/nixos-anywhere -- \
  --flake '.#<machine-name>' \
  --target-host nixos@<IP-ADDR> \
  --generate-hardware-config nixos-generate-config ./machines/<machine-name>/hardware-configuration.nix
```

(WIP)

