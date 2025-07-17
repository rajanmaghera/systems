{
  mkShell,
  bazelisk,
  buildifier,
  nodePackages,
  cudatoolkit-pin,
  ...
}:
with lib;
mkShell {
  packages = [
    bazelisk
    buildifier
    nodePackages.cspell
    cudatoolkit-pin
  ];
}
