{
  lib,
  mkShell,
  llvmPackages_latest,
  cmake,
  ninja,
  python3,
  bashInteractive,
  ccache,
  libgccjit,
  jetbrains,
  ...
}:
with lib;
mkShell {

  buildInputs = [
    llvmPackages_latest.llvm
    cmake
    ninja
    python3
    bashInteractive
    ccache
    llvmPackages_latest.clang
    llvmPackages_latest.lld
    llvmPackages_latest.libcxx
    llvmPackages_latest.libunwind
    jetbrains.clion
    libgccjit
  ];
}
