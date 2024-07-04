{
  lib,
  pkgs,
  ...
}:
with lib; let
  baseConfg = builtins.fromJSON (builtins.readFile ../configuration.json);
  source = pkgs.fetchurl {
    url = baseConfg.wallpaper.url;
    sha256 = baseConfg.wallpaper.sha256;
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
