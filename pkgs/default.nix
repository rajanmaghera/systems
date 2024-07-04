inp: {
  nixpkgs.overlays = [
    (import ./caddy)
    (import ./rars)
    (import ./cudatoolkit-pin)
    ((import ./my) inp)
    (import ./desktoppr)
    (import ./with-pkg)
    ((import ./agenix) inp)
    (
      f: p:
        inp.rpi5.legacyPackages.aarch64-linux
    )
  ];
}
