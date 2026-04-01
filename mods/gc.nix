{

  # Automatic garbage collection services
  #
  # In general, run once a week deleting anything older than 7 days

  # Darwin
  mods.darwin.my.gc =
    { ... }:
    {
      nix.gc.automatic = true;
      nix.gc.interval = [
        {
          Hour = 4;
          Minute = 30;
          Weekday = 7;
        }
      ];
      nix.gc.options = "--delete-older-than 7d";
    };

  # NixOS
  mods.nixos.my.gc =
    {
      ...
    }:
    {
      nix.gc.automatic = true;
      nix.gc.dates = [ "weekly" ];
      nix.gc.options = "--delete-older-than 7d";
    };

  # Home-manager
  mods.home.my.gc =
    { ... }:
    {
      nix.gc.automatic = true;
      nix.gc.dates = "weekly";
      nix.gc.options = "--delete-older-than 7d";

      programs.nh.enable = true;
    };

}
