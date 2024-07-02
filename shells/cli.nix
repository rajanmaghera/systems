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
    ++ pkgs.lib.optionals pkgs.stdenv.isDarwin (with pkgs; [
      libiconv
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.SystemConfiguration
      darwin.apple_sdk.frameworks.CoreServices
      darwin.apple_sdk.frameworks.CoreFoundation
      pkg-config
      openssl
    ]);

  RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";

  shellHook = ''
    PS1="[rust] $PS1"
  '';
}
