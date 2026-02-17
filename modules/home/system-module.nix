{ config, lib, ... }:
{

  home-manager.users = lib.mkIf config.my.defaults.enable {
    "${config.my.defaults.username}" = import ./base-module.nix;
  };
}
