{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.ifuse;
in
{
  options.my.ifuse = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.libimobiledevice
      pkgs.ifuse
      pkgs.usbmuxd
    ];
  };
}
