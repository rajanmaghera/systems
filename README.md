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

## Direnv shells

In any folder, create `.envrc` and point it to your desired shell. For example, `s#my-shell-nix`

```
nix_direnv_disallow_fallback
nix_direnv_manual_reload
use flake s#my-shell-nix  
```

If it's the first time, enable direnv.
```shell
direnv allow
````

If the flake changes, rebuild the cache.
```shell
nix-direnv-allow
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

Set password for nixos user and determine machine info as necessary.
```shell
passwd
lsblk
```

Generate new host key.

```shell
mkdir -p ./tmp_extra/etc/ssh
ssh-keygen -t ed25519 -f ./tmp_extra/etc/ssh/ssh_host_ed25519_key -N "" -C "root@<machine-name>"
chmod 600 ./tmp_extra/etc/ssh/ssh_host_ed25519_key
chmod 644 ./tmp_extra/etc/ssh/ssh_host_ed25519_key.pub
```

Get age key for sops.

```shell
nix run nixpkgs#ssh-to-age -- -i ./tmp_extra/etc/ssh/ssh_host_ed25519_key.pub
```

Update keys in `.sops.yaml` to point to new key.

Create/edit sops file.
```shell
nix run nixpkgs#sops -- ./secrets/<machine-name>.yml
```

Ensure that the host keys are explicitly defined in your config and that sops points to it.
Ensure that hardware config is being imported.
```nix
imports = [
  ./_<machine-name>-hardware-config.nix
];

services.openssh.enable = true;
services.openssh.hostKeys = [
  {
    path = "/etc/ssh/ssh_host_ed25519_key";
    type = "ed25519";
  }
];

sops.defaultSopsFile = ../secrets/<machine-name>.yaml;
sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];  

```

Touch hardware configuration, add it to git, and import it.
```shell
touch ./mods/_<machine-name>-hardware-config.nix
git add ./mods/_<machine-name>-hardware-config.nix
```
Run nixos-anywhere on machine.
```
nix run github:nix-community/nixos-anywhere -- \
  --flake '.#<machine-name>' \
  --target-host nixos@<IP-ADDR> \
  --extra-files ./tmp_extra \
  --generate-hardware-config nixos-generate-config ./mods/_<machine-name>-hardware-config.nix \
  --build-on remote # optional
```

Remove temp files.
```
rm -rf ./tmp_extra
```
