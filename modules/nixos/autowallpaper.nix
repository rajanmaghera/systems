{ lib, ... }:
with lib;
{
  options.my.autowallpaper = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable the custom wallpaper setter for Linux.";
    };
  };
}
