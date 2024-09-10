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
      new_wallpaper_path="${config.xdg.dataHome}/wallpaper"; \
      /usr/libexec/PlistBuddy -c "set AllSpacesAndDisplays:Desktop:Content:Choices:0:Files:0:relative file:///$new_wallpaper_path" ~/Library/Application\ Support/com.apple.wallpaper/Store/Index.plist && \
      ${pkgs.killall}/bin/killall WallpaperAgent
    '');
  };
}
