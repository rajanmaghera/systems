# Adwaita-GTK3 theme for home
{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.my.adw-gtk3;
in {
  options.my.adw-gtk3 = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    gtk = {
      enable = true;
      theme = {
        name = "adw-gtk3";
        package = pkgs.adw-gtk3;
      };
    };
  };
}
