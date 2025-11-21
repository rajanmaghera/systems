{ config, ... }:
{
  home-manager.users."${config.my.defaults.username}" = {
    imports = [
      ./module.nix
    ];
  };
}
