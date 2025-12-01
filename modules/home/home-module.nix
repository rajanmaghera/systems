{ config, lib, ... }:
{

  imports = [
    ./base-module.nix
  ];

  # Theming config
  stylix.enable = lib.mkIf config.my.defaults.theme.enable true;
  stylix.base16Scheme = config.my.defaults.theme.base16Scheme;

}
