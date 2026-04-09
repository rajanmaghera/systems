{
  mods.home.my.passwords =
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
