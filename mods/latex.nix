{
  mods.home.my.latex =
    {
      pkgs,
      ...
    }:
    {
      home.packages = [
        pkgs.texlive.combined.scheme-full
      ];
    };
}
