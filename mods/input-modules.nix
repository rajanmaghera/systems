{ inputs, ... }:
{
  conf.mod.nixos = [
    inputs.home-manager.nixosModules.home-manager
    inputs.stylix.nixosModules.stylix
    inputs.disko.nixosModules.disko
    inputs.nixarr.nixosModules.default
  ];
  conf.mod.darwin = [
    inputs.home-manager.darwinModules.home-manager
    inputs.stylix.darwinModules.stylix
  ];
  conf.mod.only-home = [
    inputs.stylix.homeModules.stylix
  ];
}
