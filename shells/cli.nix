pkgs:
pkgs.mkShell {
  packages = with pkgs;
    [
      rustc
      cargo
      rust-analyzer
      rustfmt
      clippy
    ]
    ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
      pkgs.libiconv
    ];
  shellHook = ''
    PS1="[rust] $PS1"
  '';
}
