{ inputs, ... }:
{
  baseMods.nixos = [
    inputs.home-manager.nixosModules.home-manager
    inputs.disko.nixosModules.disko
    inputs.base16.nixosModule
    inputs.impermanence.nixosModules.impermanence
    inputs.sops-nix.nixosModules.sops
    inputs.nixflix.nixosModules.default
  ];
  baseMods.darwin = [
    inputs.home-manager.darwinModules.home-manager
    inputs.base16.nixosModule
  ];
  baseMods.home = [
    inputs.base16.nixosModule
    inputs.plasma-manager.homeModules.plasma-manager
  ];
}
