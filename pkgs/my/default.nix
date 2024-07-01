{
  crane,
  nixpkgs,
  ...
}: final: prev: let
  inherit (prev) system;
  inherit (prev) lib;

  craneLib = crane.mkLib nixpkgs.legacyPackages.${system};

  commonArgs = {
    src = craneLib.cleanCargoSource (craneLib.path ./.);
    strictDeps = true;
    buildInputs = lib.optionals prev.stdenv.isDarwin [
      prev.libiconv
    ];
  };

  cargoArtifacts = craneLib.buildDepsOnly commonArgs;

  my-cli-pkg = craneLib.buildPackage (commonArgs
    // {
      inherit cargoArtifacts;
      nativeBuildInputs = [prev.installShellFiles];
      postInstall = ''
        installShellCompletion --fish target/release/build/my-*/out/my.fish
        installShellCompletion --bash target/release/build/my-*/out/my.bash
        installShellCompletion --zsh target/release/build/my-*/out/_my
      '';
    });
in {
  my-cli = my-cli-pkg;
}
