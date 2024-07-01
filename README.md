# systems

## Machines

- `dessert`: RPI5 w/ 8GB of memory, offsite in Toronto setup as a replica of data in Edmonton
- `sourpi`: VM for testing `dessert` config
- `fruit`: 2023 MacBook Pro 14 base model, personal laptop
- `work`: Work machines, standalone home-manager only

## Commands

Switch to a standalone home-manager config.

```
nix run home-manager/master -- switch --flake .#<machine-name>
```

Switch to a macOS config.

```
nix run nix-darwin -- switch --flake .#<machine-name>
```

Switch to a NixOS config.

```
nixos-rebuild switch --flake .#<machine-name>
```

Launch a shell.

```
nix develop .#<shell-name>
```
