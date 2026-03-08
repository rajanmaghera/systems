{
  pkgs.call.my-tex =
    {
      texlive,
      ...
    }:
    texlive.combined.scheme-full;
}
