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
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;

    nixosConfigurations.nixos-rmaghera-vm = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ({...}: {nixpkgs.overlays = [(import ./caddy)];})
        ./services.nix
        ./cockpit.nix
        ./hardware-configuration.nix
        ./configuration.nix
      ];
    };
  };
}
