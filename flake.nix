{
  description = "Simple OS flake";

  nixConfig = {
    extra-trusted-substituters = "https://rajan.cachix.org";
    extra-trusted-public-keys = "rajan.cachix.org-1:WdBz6DVZhJafNOoIHXsTfikZTvQHvhUo71+pEi1LqEw=";
    extra-experimental-features = "nix-command flakes";
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    crane.url = "github:ipetkov/crane";
    rpi5.url = "gitlab:vriska/nix-rpi5";
    rpi5.inputs.nixpkgs.follows = "nixpkgs";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-vscode-extensions.inputs.nixpkgs.follows = "nixpkgs";
    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      darwin,
      home-manager,
      crane,
      rpi5,
      nix-vscode-extensions,
      deploy-rs,
    }:
    let
      # Unfree packages allowed
      unfree = [
        "vscode"
        "vscode-extension-github-copilot"
        "android-sdk-cmdline-tools"
        "android-sdk-tools"
        "jetbrains"
        "jetbrains.clion"
        "clion"
      ];

      # Nixpkgs overlays
      overlays = (import ./pkgs) inputs;

      # System configuration module with overlays
      overlaysModule =
        { lib, ... }:
        {
          nixpkgs.overlays = overlays;
          nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) unfree;
        };

      # Function to generate configurations for each system
      each =
        f:
        builtins.listToAttrs (
          builtins.map
            (system: {
              name = system;
              value = f system;
            })
            [
              "x86_64-linux"
              "aarch64-darwin"
              "aarch64-linux"
            ]
        );

      # Function to generate configurations and nixpkgs for each system
      eachPkgs =
        f:
        (each (
          system:
          f {
            pkgs = import nixpkgs {
              inherit system overlays;
              config = {
                android_sdk.accept_license = true;
                allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) unfree;
              };
            };
            system = system;
          }
        ));

      # Builder for NixOS config
      makeNixos =
        configModule:
        nixpkgs.lib.nixosSystem {
          modules = [
            overlaysModule
            home-manager.nixosModules.home-manager
            ./modules/home/system-module.nix
            ./modules/nixos
            ./modules/shared/module.nix
            ./modules/shared/nested-home-module.nix
            configModule
          ];
        };

      # Builder for Darwin config
      makeDarwin =
        configModule:
        darwin.lib.darwinSystem {
          modules = [
            overlaysModule
            home-manager.darwinModules.home-manager
            ./modules/home/system-module.nix
            ./modules/darwin
            ./modules/shared/module.nix
            ./modules/shared/nested-home-module.nix
            configModule
          ];
        };

      # Builder for standalone HM configurations
      makeHome =
        configModule:
        home-manager.lib.homeManagerConfiguration {
          modules = [
            overlaysModule
            ./modules/home/home-module.nix
            ./modules/shared/module.nix
            ./modules/shared/nested-home-module.nix
            configModule
          ];

        };

    in
    {
      # Nix file formatter
      formatter = eachPkgs (
        { pkgs, ... }:
        pkgs.nixfmt-tree.override {
          runtimeInputs = [ pkgs.nixfmt-rfc-style ];
        }
      );

      # All nixpkgs + custom packages + flake input packages
      packages = eachPkgs (
        {
          pkgs,
          system,
        }:
        pkgs // home-manager.packages.${system} // (darwin.packages.${system} or { })
      );

      # NixOS configuration
      nixosConfigurations = {
        sourfruit = makeNixos ./machines/sourfruit;

      };

      # Darwin (macOS) configuration
      darwinConfigurations = {
        fruit = makeDarwin ./machines/fruit;
      };

      # Home Manager configuration
      homeConfigurations = {
        precision = makeHome ./machines/precision;
      };
    };

}
