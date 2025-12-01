{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.defaults;
in
{
  options.my.home = mkOption {
    type = types.anything;
  };

  config = mkIf cfg.enable {

    # Nix configuration
    users.users."${cfg.username}" = {
      home = cfg.homeDirectory;
      shell = pkgs.zsh;
    };
    system.primaryUser = cfg.username;
    time.timeZone = cfg.timeZone;
    networking.hostName = cfg.hostName;
    nixpkgs.hostPlatform = pkgs.stdenv.hostPlatform.system;
    ids.gids.nixbld = 350;
    system.stateVersion = 6;
    nix.settings.extra-trusted-users = [ cfg.username ];
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    home-manager.backupFileExtension = "bkup";
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users."${cfg.username}" = config.my.home // {
      my.defaults = cfg;
    };

    # Use Nix's shell instead of default
    # TODO move to own file
    programs.zsh.enable = true;
    environment.shells = [ pkgs.zsh ];

    # Theming config
    stylix.enable = mkIf cfg.theme.enable true;
    stylix.base16Scheme = cfg.theme.base16Scheme;

  };
}
