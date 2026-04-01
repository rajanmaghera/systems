{
  mods.home.my.passwords =
    {
      pkgs,
      ...
    }:
    {
      home.packages = with pkgs; [
        bitwarden-cli
        bitwarden-desktop
      ];
    };
}
