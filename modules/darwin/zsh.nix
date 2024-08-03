{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.my.shell.zsh;
in {
  options.my.shell.zsh = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    programs.zsh.enable = true;
    environment.shells = [pkgs.zsh];
    users.users.${config.my.profile.user}.shell = pkgs.zsh;
  };
}
