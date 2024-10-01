# systems

## Machines

- `dessert`: RPI5 w/ 8GB of memory, offsite in Toronto setup as a replica of data in Edmonton
- `sourpi`: VM for testing `dessert` config
- `fruit`: 2023 MacBook Pro 14 inch (base model), personal laptop
- `banana`: iPhone 14 Pro, purple

## Commands

This flake exposes all necessary packages as its own packages. This allows us to easily run any command from this repo's version of nixpkgs, as well as any custom packages written in this repo. Switching to a configuration will ensure that the given package is available in the shell, so it's not necessary after the first run.

Switch to a standalone home-manager config.

```
nix run .#home-manager -- switch --flake .#<machine-name>
```

Switch to a macOS config.

```
nix run .#darwin-rebuild -- switch --flake .#<machine-name>
```

Switch to a NixOS config.

```
nix run .#nixos-rebuild -- switch --flake .#<machine-name>
```

Launch a shell.

```
nix develop .#<shell-name>
```

Create a temporary shell with a package available.

```
nix shell .#<package-name>
```

Run a specific package.

```
nix run .#<package-name>
```

Update all Nix dependencies.

```
nix flake update
```

Deploy all machines configured for auto-deployment.

```
nix run github:serokell/deploy-rs -- --remote-build -s
```
