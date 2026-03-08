{
  pkgs.call.cuda-shell =
    {
      mkShell,
      bazelisk,
      buildifier,
      nodePackages,
      cudatoolkit-pin,
      ...
    }:
    mkShell {
      packages = [
        bazelisk
        buildifier
        nodePackages.cspell
        cudatoolkit-pin
      ];
    };
}
