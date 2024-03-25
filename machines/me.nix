# My defaults across all machines
{
  hostName,
  system,
}: {
  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Enable flakes.
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Set hostname.
  networking.hostName = hostName;

  # Set platform.
  nixpkgs.hostPlatform = system;
}
