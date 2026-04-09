{ inputs, ... }:
{
  conf.mod.nixos = [
    inputs.home-manager.nixosModules.home-manager
    inputs.disko.nixosModules.disko
    inputs.nixarr.nixosModules.default
    inputs.base16.nixosModule
  ];
  conf.mod.darwin = [
    inputs.home-manager.darwinModules.home-manager
    inputs.base16.nixosModule
  ];
  conf.mod.home = [
    inputs.base16.nixosModule
  ];
}
