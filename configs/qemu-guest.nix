{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.my.qemu-guest;
in {
  options.my.qemu-guest = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable configuration for a QEMU guest with video drivers.";
    };
  };

  config = mkIf cfg.enable {
    services.qemuGuest.enable = true;
    services.spice-vdagentd.enable = true;
    services.xserver.videoDrivers = ["qxl"];
  };
}
