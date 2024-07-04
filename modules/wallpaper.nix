{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.my.wallpaper;
in {
  options.my.wallpaper = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Download and set default wallpaper.";
    };
  };

  config = mkIf cfg.enable {
    xdg.dataFile."wallpaper".source = cfg.source;

    home.activation.setDesktopBackground = mkIf pkgs.stdenv.isDarwin (lib.hm.dag.entryAfter ["writeBoundary"] ''
      ${pkgs.desktoppr}/bin/desktoppr $XDG_DATA_HOME/wallpaper
    '');
  };
}
