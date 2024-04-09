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
  };

  outputs = inp @ {
    self,
    nixpkgs,
    darwin,
    home-manager,
    crane,
    rpi5,
  }: let
    my-pkgs = (import ./pkgs) inp;

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
        overlays = my-pkgs.nixpkgs.overlays;
      }))
    );

    ### SYSTEM CONFIGURATIONS ###

    # NixOS configuration
    nixosConfigurations = (import ./machines).nixos {
      configNixos = nixpkgs.lib.nixosSystem;
      modules = [
        my-pkgs
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
        my-pkgs
        home-manager.darwinModules.home-manager
        ((import ./modules).system "rajan")
        ((import ./home).system "rajan")
      ];
    };

    # Home Manager configuration
    homeConfigurations = (import ./standalone) {
      inherit nixpkgs;
      configHome = home-manager.lib.homeManagerConfiguration;
      modules = [
        my-pkgs
        (import ./modules).config
        (import ./home).config
      ];
    };

    # SD card images, hardcoded for now
    images = {
      dessert = self.nixosConfigurations.dessert.config.system.build.sdImage;
    };
  };
}
