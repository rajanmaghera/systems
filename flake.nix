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
  }: {
    # Formatter for this nix flake
    formatter.aarch64-linux = nixpkgs.legacyPackages.aarch64-linux.alejandra;
    formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.alejandra;
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;

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
