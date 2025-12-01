{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.qemu-guest;
in
{
  options.my.qemu-guest = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable configuration for a QEMU guest with video drivers.";
    };
    sharedFolder = mkOption {
      type = types.bool;
      default = true;
      description = "Enable shared folder via VirtFS. The permissions of the shared folder might not be correct. To fix this, run `sudo fix-virtfs-permissions`.";
    };
  };

  config = mkIf cfg.enable {

    # Boot packages
    boot.initrd.availableKernelModules = [
      "virtio_net"
      "virtio_pci"
      "virtio_mmio"
      "virtio_blk"
      "virtio_scsi"
      "9p"
      "9pnet_virtio"
    ];
    boot.initrd.kernelModules = [
      "virtio_balloon"
      "virtio_console"
      "virtio_rng"
      "virtio_gpu"
    ];

    # QEMU guest services
    services.qemuGuest.enable = true;
    services.spice-vdagentd.enable = true;
    services.xserver.videoDrivers = [ "qxl" ];

    # VirtFs
    system.activationScripts.makeMountFolderForVirtFs = mkIf cfg.sharedFolder {
      text = ''
        mkdir -p /mnt/virtfs
      '';
    };

    fileSystems."/mnt/virtfs" = mkIf cfg.sharedFolder {
      device = "share";
      fsType = "9p";
      options = [
        "trans=virtio"
        "version=9p2000.L"
        "rw"
        "_netdev"
        "nofail"
      ];
    };

    environment.systemPackages = mkIf cfg.sharedFolder [
      (pkgs.writeScriptBin "fix-virtfs-permissions" ''
        chown -R ${config.my.defaults.username}:users /mnt/virtfs
      '')
    ];
  };
}
