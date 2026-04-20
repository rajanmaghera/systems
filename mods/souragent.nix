{

  sys.souragent.system = "x86_64-linux";
  sys.souragent.class = "nixos";
  # TODO: eliminate below
  pkgs.allUnfree = true;

  sys.souragent.mod =
    {
      lib,
      ...
    }:
    {
      my.defaults.enable = true;
      my.defaults.homeDirectory = "/home/rajan";
      my.defaults.hostName = "souragent";

      my.gc.enable = true;
      my.deployment-user.enable = true;

      my.headless-rdp-kde.enable = true;
      my.shell.enable = true;
      my.autologin.enable = true;

      my.defaults.authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG8ZCH5zjDnnRouiFA0QrGuygX8mi4EWGj4nsXwQyKQ+ rajanmaghera@RajansMacBookPro"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC9y0BMvduJSoIIQ+bTixWSkdDD3/nt01jTtBXBeDbqf rajan@rajan-precision"
      ];

      my.defaults.home = {
        my.gc.enable = true;
        my.cli.enable = true;
        my.dev-env.enable = true;
        my.shell.enable = true;
        my.passwords.enable = true;
        my.theming.enable = true;
        my.agent-cli.enable = true;
      };
      my.force-cuda-env.enable = true;

      # DISK CONFIG

      disko.devices = {
        disk.disk1 = {
          device = lib.mkDefault "/dev/vda";
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
