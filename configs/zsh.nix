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
      description = "Use the ZSH shell as the default.";
    };
  };

  config = mkIf cfg.enable {
    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;
  };
}
