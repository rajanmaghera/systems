{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.my.gnome;
in {
  options.my.gnome = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Use the GNOME desktop";
    };
  };

  config = mkIf cfg.enable {
    services.xserver.enable = true;
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;
    security.polkit.enable = true;
  };
}
