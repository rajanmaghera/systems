{ inputs, ... }:
{
  pkgs.def.my-cli =
    prev:
    let
      inherit (prev) system;
      inherit (prev) lib;

      craneLib = inputs.crane.mkLib prev;

      commonArgs = {
        src = craneLib.cleanCargoSource (craneLib.path ./my);
        strictDeps = true;
        buildInputs = lib.optionals prev.stdenv.isDarwin [
          prev.libiconv
        ];
      };

      cargoArtifacts = craneLib.buildDepsOnly commonArgs;
    in
    craneLib.buildPackage (
      commonArgs
      // {
        inherit cargoArtifacts;
        nativeBuildInputs = [ prev.installShellFiles ];
        postInstall = ''
          installShellCompletion --fish target/release/build/my-*/out/my.fish
          installShellCompletion --bash target/release/build/my-*/out/my.bash
          installShellCompletion --zsh target/release/build/my-*/out/_my
        '';
      }
    );
}
