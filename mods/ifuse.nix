{
  mods.home.ifuse.conf =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.libimobiledevice
        pkgs.ifuse
        pkgs.usbmuxd
      ];
    };
}
