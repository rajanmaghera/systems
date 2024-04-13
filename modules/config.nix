{
  imports = [
    ./cli.nix
    ./dev-env.nix
    ./direnv.nix
    ./llm.nix
    ./fish.nix
    ./adw-gtk3.nix
  ];
  home.stateVersion = "24.05";
}
