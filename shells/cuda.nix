pkgs:
pkgs.mkShell {
  packages = with pkgs; [
    bazelisk
    buildifier
    nodePackages.cspell
    cudatoolkit-pin
  ];

  shellHook = ''
    PS1="[cuda] $PS1"
  '';
}
