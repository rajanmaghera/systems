{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.my.shell.fish;
in {
  options.my.shell.fish = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting # Disable greeting
      '';
    };
  };
}
