# My defaults across all machines
{
  # Set your time zone.
  time.timeZone = "America/Toronto";
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";
}
