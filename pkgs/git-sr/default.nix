{crane, ...}: final: prev: let
  inherit (prev) system;
  inherit (prev) lib;

  craneLib = crane.lib.${system};

  commonArgs = {
    src = craneLib.cleanCargoSource (craneLib.path ./.);
    strictDeps = true;
    buildInputs = lib.optionals prev.stdenv.isDarwin [
      prev.libiconv
    ];
  };

  cargoArtifacts = craneLib.buildDepsOnly commonArgs;

  git-sr-pkg = craneLib.buildPackage (commonArgs
    // {
      inherit cargoArtifacts;
      nativeBuildInputs = [prev.installShellFiles];
      postInstall = ''
        installShellCompletion --fish target/release/build/git-sr-*/out/git-sr.fish
        installShellCompletion --bash target/release/build/git-sr-*/out/git-sr.bash
        installShellCompletion --zsh target/release/build/git-sr-*/out/_git-sr
      '';
    });
in {
  git-sr = git-sr-pkg;
}
