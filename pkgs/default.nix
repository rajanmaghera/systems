inp: {
  nixpkgs.overlays = [
    (import ./caddy)
    (import ./rars)
    ((import ./my) inp)
    (
      f: p:
        inp.rpi5.legacyPackages.aarch64-linux
    )
  ];
}
