{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.my.kde;
in {
  options.my.kde = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Use the KDE desktop";
    };
  };

  config = mkIf cfg.enable {
    services.xserver.enable = true;
    services.xserver.displayManager.defaultSession = "plasma";
    services.xserver.displayManager.sddm.enable = true;
    services.xserver.displayManager.sddm.wayland.enable = true;
    services.desktopManager.plasma6.enable = true;
  };
}
