{
  mods.home.cli.conf =
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
