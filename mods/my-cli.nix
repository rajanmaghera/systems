{
  pkgs.call.my-cli =
    {
      rustPlatform,
      installShellFiles,
      ...
    }:
    rustPlatform.buildRustPackage (finalAttrs: {
      pname = "my";
      version = "0.1.0";

      src = ./my;
      cargoHash = "sha256-kHB5rQHhP4tnuAbBpekiWIwl/6U/UkBIARJQAEa3ifk=";

      nativeBuildInputs = [ installShellFiles ];
      postInstall = ''
        installShellCompletion --fish target/release/build/my-*/out/my.fish
        installShellCompletion --bash target/release/build/my-*/out/my.bash
        installShellCompletion --zsh target/release/build/my-*/out/_my
      '';
    });
}
