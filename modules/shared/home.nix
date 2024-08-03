{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.my.home;
in {
  options.my.home = {
    config = mkOption {
      type = types.anything;
      default = {};
      description = "Extra home configuration.";
    };
  };
}
