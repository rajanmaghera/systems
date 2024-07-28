inp: {
  nixpkgs.overlays = [
    (import ./caddy)
    (import ./rars)
    (import ./cudatoolkit-pin)
    ((import ./my) inp)
    (import ./desktoppr)
    (import ./nix-ios)
    (import ./with-pkg)
    (import ./rust-shell)
    (import ./cuda-shell)
    ((import ./agenix) inp)
    ((import ./vscode-extensions) inp)
    ((import ./rpi) inp)
  ];
}
