{
  mods.home.adw-gtk3.conf =
    {
      pkgs,
      ...
    }:
    {
      gtk = {
        enable = true;
        theme = {
          name = "adw-gtk3";
          package = pkgs.adw-gtk3;
        };
      };
    };
}
