{
  imports = [
    ./cli.nix
    ./dev-env.nix
    ./llm.nix
    ./fish.nix
    ./adw-gtk3.nix
  ];
  home.stateVersion = "24.05";
}
