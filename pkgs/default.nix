inp: {
  nixpkgs.overlays = [
    (import ./caddy)
    (import ./rars)
    ((import ./my) inp)
  ];
}
