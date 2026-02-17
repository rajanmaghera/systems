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
    environment.systemPackages = with pkgs; [
      spice-vdagent
    ];
    services.xserver.videoDrivers = [
      "qxl"
      "virtio"
    ];

    # Fix for service not starting in userspace
    systemd.user.services.spice-vdagent = {
      description = "spice-vdagent user daemon";
      after = [
        "spice-vdagentd.service"
        "graphical-session.target"
      ];
      requires = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.spice-vdagent}/bin/spice-vdagent -x";
      };
      unitConfig = {
        ConditionPathExists = "/run/spice-vdagentd/spice-vdagent-sock";
      };
    };
  };
}
