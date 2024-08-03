{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.my.system;
in {
  options.my.system = {
    hostName = mkOption {
      type = types.str;
      description = "System hostname.";
    };
  };
}
