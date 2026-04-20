{
  sys.titan.system = "aarch64-linux";
  sys.titan.class = "nixos";

  sys.titan.mod =
    {
      ...
    }:
    {

      my.defaults.enable = true;
      my.defaults.homeDirectory = "/home/rajan";
      my.defaults.hostName = "titan";

      my.qemu-guest.enable = true;

      my.shell.enable = true;
      my.deployment-user.enable = true;
      my.gc.enable = true;
      my.tailscale.enable = true;

      my.defaults.home = {
        my.gc.enable = true;
        my.shell.enable = true;
        my.sync.enable = true;
        my.sync.publicGui = true;
        my.theming.enable = true;
      };

      my.immich.enable = true;
      my.home-assistant.enable = true;
      my.samba.enable = true;

    };
}
