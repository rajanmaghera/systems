{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.cli;
in
{
  options.my.cli = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.my-cli
    ];
  };
}
