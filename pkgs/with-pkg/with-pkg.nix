{writeShellScriptBin, ...}: let
  projectRootString = builtins.toString ../..;
in
  writeShellScriptBin "with-pkg" ''
    nix shell ${projectRootString}#$1
  ''
