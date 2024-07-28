{
  description = "Simple OS flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    crane.url = "github:ipetkov/crane";
    crane.inputs.nixpkgs.follows = "nixpkgs";
    rpi5.url = "gitlab:vriska/nix-rpi5";
    rpi5.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.darwin.follows = "darwin";
    agenix.inputs.home-manager.follows = "home-manager";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-vscode-extensions.inputs.nixpkgs.follows = "nixpkgs";
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
  }: let
    # Nixpkgs overlays
    overlays = (import ./pkgs) inputs;

    # System configuration module with overlays
    overlaysModule = {
      nixpkgs.overlays = overlays;
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
        (import ./lab)
        (import ./services)
        (import ./secrets)
        (import ./modules/home).system
        (import ./home).system
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
        (import ./modules/home).system
        (import ./home).system
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
        (import ./modules/home).config
        (import ./home).config
      ];
    };

    # SD card images, hardcoded for now
    images = {
      dessert = self.nixosConfigurations.dessert.config.system.build.sdImage;
    };

    # iOS configuration
    iosConfigurations = (import ./machines).ios;
  };
}
