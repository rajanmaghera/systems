# My defaults across all machines
{
  hostName,
  system,
}:
{
  # Set your time zone.
  time.timeZone = "America/Edmonton";

  # Enable flakes.
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Set hostname.
  networking.hostName = hostName;

  # Set platform.
  nixpkgs.hostPlatform = system;

  # Auto backup HM files.
  home-manager.backupFileExtension = "bkup";
}
