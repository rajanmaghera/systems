# systems

[![Nix CI](https://github.com/rajanmaghera/systems/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/rajanmaghera/systems/actions/workflows/ci.yml)

This repo should live at `~/systems`.


## Commands

This flake exposes all necessary packages as its own packages. This allows us to easily run any command from this repo's version of nixpkgs, as well as any custom packages written in this repo. Switching to a configuration will ensure that the given package is available in the shell, so it's not necessary after the first run.

Switch to a standalone home-manager config.

```
nix run ~/systems#home-manager -- switch --flake ~/systems#<machine-name>
```

Switch to a macOS config.

```
nix run ~/systems#darwin-rebuild -- switch --flake ~/systems#<machine-name>
```

Switch to a NixOS config.

```
nix run ~/systems#nixos-rebuild -- switch --flake ~/systems#<machine-name>
```

Create a temporary shell with a package available.

```
nix shell ~/systems#<package-name>
```

Run a specific package.

```
nix run ~/systems#<package-name>
```

Update all Nix dependencies.

```
nix flake update
```

Remove all garbage on a Darwin config.

```
nix-collect-garbage -d
sudo nix-collect-garbage -d
```

## Development shells

Launch a shell.

```
nix develop ~/systems#<shell-name> -c zsh
```

As much as possible, try to keep all development dependencies in shells to keep them as portable and clean as possible. The base system should ideally have no build tools.

### Development environment quick setup

Have a shell ready.

Setup direnv.

```
echo "use flake ~/systems#<shell-name>" >> .envrc && direnv allow
```

Setup a _justfile_ for the basic commands.

```
just setup
just build
just clean
just run
```

Force rebuild the direnv shell if needed.

```
rm -rf .direnv && direnv allow
```
