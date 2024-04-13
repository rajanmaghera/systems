{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.my.direnv;
in {
  options.my.direnv = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    programs.direnv = {
      enable = true;
    };
  };
}
