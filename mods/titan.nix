{
  sys.titan.system = "aarch64-linux";
  sys.titan.class = "nixos";

  sys.titan.mod =
    {
      lib,
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

      # DISK CONFIG

      disko.devices = {
        disk.disk1 = {
          device = lib.mkDefault "/dev/sda";
          type = "disk";
          content = {
            type = "gpt";
            partitions = {
              boot = {
                name = "boot";
                size = "1M";
                type = "EF02";
              };
              esp = {
                name = "ESP";
                size = "500M";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                };
              };
              root = {
                name = "root";
                size = "100%";
                content = {
                  type = "lvm_pv";
                  vg = "pool";
                };
              };
            };
          };
        };
        lvm_vg = {
          pool = {
            type = "lvm_vg";
            lvs = {
              root = {
                size = "100%FREE";
                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/";
                  mountOptions = [
                    "defaults"
                  ];
                };
              };
            };
          };
        };
      };

    };
}
