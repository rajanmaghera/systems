{ config, ... }:
{
  home-manager.users."${config.my.defaults.username}" = import ./home-module.nix;
}
