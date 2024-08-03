{config, ...}: {
  time.timeZone = "America/Toronto";
  nix.settings.experimental-features = ["nix-command" "flakes"];
  home-manager.backupFileExtension = "bkup";
  nixpkgs.hostPlatform = "aarch64-linux";
  networking.hostName = config.my.system.hostName;
}
