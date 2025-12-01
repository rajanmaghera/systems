{ config, ... }:
{
  home-manager.users."${config.my.defaults.username}" = import ./base-module.nix;
}
