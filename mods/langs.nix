{

  # Language shells for development
  # TODO: Helix configurations
  # TODO: VSCode configurations
  pkgs.call = {

    # RUST
    my-shell-rust =
      {
        mkShell,
        rustc,
        cargo,
        rust-analyzer,
        rustfmt,
        clippy,
        libiconv,
        pkg-config,
        openssl,
        rust,
        lib,
        stdenv,
        ...
      }:
      mkShell {
        packages = [
          rustc
          cargo
          rust-analyzer
          rustfmt
          clippy
        ]
        ++ lib.optionals stdenv.isDarwin [
          libiconv
          pkg-config
          openssl
        ];

        RUST_SRC_PATH = "${rust.packages.stable.rustPlatform.rustLibSrc}";
      };

    # NIX
    my-shell-nix =
      {
        mkShell,
        nixd,
        nixfmt,
        ...
      }:
      mkShell {
        packages = [
          nixd
          nixfmt
        ];

      };

    # LLVM/C++
    my-shell-llvm =
      {
        mkShell,
        llvmPackages_latest,
        cmake,
        ninja,
        zlib,
        zstd,
        python3,
        bashInteractive,
        ccache,
        pkg-config,
        apple-sdk,
        lib,
        writeShellScriptBin,
        stdenv,
        ...
      }:
      let
        # Hack to fix clang not picking up on the right packages
        clangd-wrapped = writeShellScriptBin "clangd" ''
          export CPLUS_INCLUDE_PATH="${llvmPackages_latest.libcxx.dev}/include/c++/v1:$CPLUS_INCLUDE_PATH"
          exec ${llvmPackages_latest.clang-tools}/bin/clangd "$@"
        '';
      in
      mkShell.override { stdenv = llvmPackages_latest.stdenv; } {

        nativeBuildInputs = [
          clangd-wrapped
          cmake
          ninja
          pkg-config
          ccache
        ]
        ++ lib.optionals stdenv.isDarwin [
          apple-sdk
        ];

        buildInputs = [
          python3
          bashInteractive
          zlib
          zstd
          llvmPackages_latest.llvm
          llvmPackages_latest.lld
          llvmPackages_latest.lldb
        ];

        shellHook = ''
          # Zlib needs special re-importing
          export NIX_LDFLAGS="-rpath ${zlib}/lib $NIX_LDFLAGS"
        '';
      };

  };

}
