{
  mods.home.my.cli =
    {
      pkgs,
      ...
    }:
    {
      home.packages = [
        pkgs.my-cli
      ];
    };
}
