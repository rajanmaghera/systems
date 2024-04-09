pkgs: {
  my-cli = import ./cli.nix pkgs;
  cuda-shell = import ./cuda.nix pkgs;
}
