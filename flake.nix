{
  description = "Simple OS flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    darwin,
    home-manager,
  }: let
    # Function to generate configurations for each system
    each = f:
      builtins.listToAttrs (builtins.map (system: {
        name = system;
        value = f system;
      }) ["x86_64-linux" "aarch64-darwin" "aarch64-linux"]);
  in {
    ### REPO CONFIGURATIONS ###

    formatter = each (
      system:
        (import nixpkgs {
          inherit system;
        })
        .alejandra
    );

    # Custom shells
    packages = each (
      system: (import ./shells (import nixpkgs {
        inherit system;
      }))
    );

    ### SYSTEM CONFIGURATIONS ###

    # NixOS configuration
    nixosConfigurations = (import ./machines).nixos {
      configNixos = nixpkgs.lib.nixosSystem;
      modules = [
        ./pkgs
        ./lab
        ./services
        home-manager.nixosModules.home-manager
        ((import ./modules).system "rajan")
        ((import ./home).system "rajan")
      ];
    };

    # Darwin (macOS) configuration
    darwinConfigurations = (import ./machines).darwin {
      configDarwin = darwin.lib.darwinSystem;
      modules = [
        ./pkgs
        home-manager.darwinModules.home-manager
        ((import ./modules).system "rajan")
        ((import ./home).system "rajan")
      ];
    };

    # Home Manager configuration
    homeConfigurations = (import ./standalone) {
      inherit nixpkgs;
      configHome = home-manager.lib.homeManagerConfiguration;
      overlays = (import ./pkgs).nixpkgs.overlays;
      modules = [
        (import ./modules).config
        (import ./home).config
      ];
    };
  };
}
