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
    my.gui.enable = true;
    services.xserver.enable = true;
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;
    services.xserver.desktopManager.wallpaper.mode = "fill";
    security.polkit.enable = true;
    system.userActivationScripts.setDesktopWallpaper = mkIf config.my.autowallpaper.enable {
      text = ''
        if [ -e "$XDG_DATA_HOME/wallpaper" ]; then
          ${pkgs.glib}/bin/gsettings set org.gnome.desktop.background picture-uri file://$XDG_DATA_HOME/wallpaper
          ${pkgs.glib}/bin/gsettings set org.gnome.desktop.background picture-uri-dark file://$XDG_DATA_HOME/wallpaper
        fi
      '';
    };
  };
}
