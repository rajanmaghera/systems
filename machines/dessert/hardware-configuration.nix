{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    "${modulesPath}/installer/sd-card/sd-image.nix"
    "${modulesPath}/profiles/base.nix"
  ];

  nixpkgs.overlays = [
    (final: super: {
      makeModulesClosure = x:
        super.makeModulesClosure (x // {allowMissing = true;});
    })
  ];

  nixpkgs.config.allowUnsupportedSystem = true;

  boot.loader.grub.enable = false;
  boot.loader.systemd-boot.enable = false;
  boot.loader.raspberryPi.enable = true;
  boot.loader.raspberryPi.version = 4;
  boot.kernelPackages = pkgs.linuxPackages_rpi5;

  boot.consoleLogLevel = lib.mkDefault 7;

  # The serial ports listed here are:
  # - ttyS0: for Tegra (Jetson TX1)
  # - ttyAMA0: for QEMU's -machine virt
  boot.kernelParams = ["console=ttyS1,115200n8" "console=ttyAMA0,115200n8" "console=tty0"];

  sdImage = {
    firmwareSize = 1024;
    firmwarePartitionName = "NIXOS_BOOT";
    populateFirmwareCommands = "${config.system.build.installBootLoader} ${config.system.build.toplevel} -d ./firmware";
    populateRootCommands = "";
  };

  fileSystems."/boot/firmware" = {
    mountPoint = "/boot";
    neededForBoot = true;
  };
}
