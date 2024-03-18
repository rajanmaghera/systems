{
  description = "Simple OS flake";
  inputs = {nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";};

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "aarch64-linux";
  in {
    formatter.aarch64-linux = nixpkgs.legacyPackages.aarch64-linux.alejandra;
    formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.alejandra;
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;

    nixosConfigurations.nixos-rmaghera-vm = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./pkgs
        ./lab
        ./services
        ./hardware-configuration.nix
        ./configuration.nix
      ];
    };
  };
}
