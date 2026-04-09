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
      cargoHash = "sha256-CnGMrcF8Hrkhk0qRT8L8C1vix+C50lyBjqhj6nXLRxI=";

      nativeBuildInputs = [ installShellFiles ];
      postInstall = ''
        installShellCompletion --fish target/release/build/my-*/out/my.fish
        installShellCompletion --bash target/release/build/my-*/out/my.bash
        installShellCompletion --zsh target/release/build/my-*/out/_my
      '';
    });
}
