{
  mkShell,
  rustc,
  cargo,
  rust-analyzer,
  rustfmt,
  clippy,
  libiconv,
  darwin,
  pkg-config,
  openssl,
  rust,
  lib,
  stdenv,
  ...
}:
with lib;
  mkShell {
    packages =
      [
        rustc
        cargo
        rust-analyzer
        rustfmt
        clippy
      ]
      ++ lib.optionals stdenv.isDarwin [
        libiconv
        darwin.apple_sdk.frameworks.Security
        darwin.apple_sdk.frameworks.SystemConfiguration
        darwin.apple_sdk.frameworks.CoreServices
        darwin.apple_sdk.frameworks.CoreFoundation
        pkg-config
        openssl
      ];

    RUST_SRC_PATH = "${rust.packages.stable.rustPlatform.rustLibSrc}";
  }
