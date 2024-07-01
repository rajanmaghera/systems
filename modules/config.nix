{
  imports = [
    ./cli.nix
    ./dev-env.nix
    ./llm.nix
    ./fish.nix
    ./adw-gtk3.nix
    ./secrets.nix
  ];
  home.stateVersion = "24.05";
}
