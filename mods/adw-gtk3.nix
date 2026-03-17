{
  mods.home.my.adw-gtk3 =
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
