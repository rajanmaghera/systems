{
  mods.home.passwords.conf =
    {
      pkgs,
      ...
    }:
    {
      home.packages = [
        pkgs.bitwarden-cli
        pkgs.bitwarden-desktop
      ];
    };
}
