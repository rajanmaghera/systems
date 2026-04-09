{
  mods.home.latex.conf =
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
