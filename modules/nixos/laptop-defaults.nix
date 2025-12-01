{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.laptop-defaults;
in
{
  options.my.laptop-defaults = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable default configuration options for devices with laptop-like features";
    };

  };

  config = mkIf cfg.enable {
    services.libinput.enable = true;
  };
}
