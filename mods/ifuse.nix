{
  mods.home.my.ifuse =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.libimobiledevice
        pkgs.ifuse
        pkgs.usbmuxd
      ];
    };
}
