{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.linux-builder;
in
{
  options.my.linux-builder = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };
  config = mkIf cfg.enable {
    nix.linux-builder = {
      enable = true;
    };
  };
}
