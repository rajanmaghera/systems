{
  description = "Simple OS flake";

  nixConfig = {
    extra-trusted-substituters = "https://rajan.cachix.org";
    extra-trusted-public-keys = "rajan.cachix.org-1:WdBz6DVZhJafNOoIHXsTfikZTvQHvhUo71+pEi1LqEw=";
    extra-experimental-features = "nix-command flakes";
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    crane.url = "github:ipetkov/crane";
    rpi5.url = "gitlab:vriska/nix-rpi5";
    rpi5.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.darwin.follows = "darwin";
    agenix.inputs.home-manager.follows = "home-manager";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-vscode-extensions.inputs.nixpkgs.follows = "nixpkgs";
    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    darwin,
    agenix,
    home-manager,
    crane,
    rpi5,
    nix-vscode-extensions,
    deploy-rs,
  }: let
    # Unfree packages allowed
    unfree = [
      "vscode"
      "android-sdk-cmdline-tools"
      "android-sdk-tools"
    ];

    # Nixpkgs overlays
    overlays = (import ./pkgs) inputs;

    # System configuration module with overlays
    overlaysModule = {lib, ...}: {
      nixpkgs.overlays = overlays;
      nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) unfree;
    };

    # Function to generate configurations for each system
    each = f:
      builtins.listToAttrs (builtins.map (system: {
        name = system;
        value = f system;
      }) ["x86_64-linux" "aarch64-darwin" "aarch64-linux"]);

    # Function to generate configurations and nixpkgs for each system
    eachPkgs = f: (each (
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
  in {
    # Nix file formatter
    formatter = eachPkgs ({pkgs, ...}: pkgs.alejandra);

    # All nixpkgs + custom packages + flake input packages
    packages = eachPkgs (
      {
        pkgs,
        system,
      }:
        pkgs // home-manager.packages.${system} // (darwin.packages.${system} or {})
    );

    # NixOS configuration
    nixosConfigurations = (import ./machines).nixos {
      configNixos = nixpkgs.lib.nixosSystem;
      overlayHome = (import ./home).overlayHome;
      modules = [
        overlaysModule
        home-manager.nixosModules.home-manager
        agenix.nixosModules.default
        (import ./secrets)
        (import ./home).system
        (import ./modules/home).system
        (import ./modules/nixos-homelab)
        (import ./modules/nixos)
        (import ./modules/shared)
      ];
    };

    # Darwin (macOS) configuration
    darwinConfigurations = (import ./machines).darwin {
      configDarwin = darwin.lib.darwinSystem;
      overlayHome = (import ./home).overlayHome;
      modules = [
        overlaysModule
        home-manager.darwinModules.home-manager
        agenix.darwinModules.default
        (import ./secrets)
        (import ./home).system
        (import ./modules/home).system
        (import ./modules/darwin)
        (import ./modules/shared)
      ];
    };

    # Home Manager configuration
    homeConfigurations = (import ./standalone) {
      inherit nixpkgs;
      configHome = home-manager.lib.homeManagerConfiguration;
      modules = [
        overlaysModule
        agenix.homeManagerModules.default
        (import ./secrets)
        (import ./home).config
        (import ./modules/home).config
      ];
    };

    # SD card images, hardcoded for now
    images = {
      dessert = self.nixosConfigurations.dessert.config.system.build.sdImage;
    };

    # iOS configuration
    iosConfigurations = (import ./machines).ios;

    # Automated deployments
    deploy = {
      remoteBuild = true;
      nodes.pie = {
        interactiveSudo = true;
        hostname = "pie.tail122a7f.ts.net";
        profiles.system = {
          user = "root";
          path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.pie;
        };
      };
    };
  };
}
