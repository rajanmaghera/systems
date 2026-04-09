{ inputs, ... }:
{
  baseMods.nixos = [
    inputs.home-manager.nixosModules.home-manager
    inputs.disko.nixosModules.disko
    inputs.nixarr.nixosModules.default
    inputs.base16.nixosModule
    inputs.vscode-server.nixosModules.default
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
