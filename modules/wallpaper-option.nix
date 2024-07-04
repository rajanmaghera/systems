{
  lib,
  pkgs,
  ...
}:
with lib; let
  source = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/rajanmaghera/systems/wallpaper/austin-schmid-mZSRmKfhIkM-unsplash.jpg";
    sha256 = "sha256-CycIembvGpjRcv0+F2ThtGHrtze9waz2emmJAtxIVok=";
  };
in {
  options.my.wallpaper = {
    source = mkOption {
      type = types.path;
      default = source;
      description = "Wallpaper source.";
    };
  };
}
