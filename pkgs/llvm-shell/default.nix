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
}
