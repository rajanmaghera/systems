{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.my.devenv;
in {
  options.my.devenv = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.git-branchless
    ];
  };
}
