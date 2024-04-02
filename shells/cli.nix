pkgs:
pkgs.mkShell {
  packages = with pkgs;
    [
      rustc
      cargo
      rust-analyzer
      rustfmt
      clippy
      pkg-config
      openssl
    ]
    ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
      pkgs.libiconv
      pkgs.darwin.apple_sdk.frameworks.Security
    ];

  shellHook = ''
    PS1="[rust] $PS1"
  '';
}
