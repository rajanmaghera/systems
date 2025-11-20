{
  imports = [
    ./cli.nix
    ./dev-env.nix
    ./llm.nix
    ./fish.nix
    ./adw-gtk3.nix
    ./wallpaper.nix
    ./wallpaper-option.nix
    ./zsh.nix
    ./editor.nix
    ./term-editor.nix
    ./ifuse.nix
    ./latex.nix
    ./fonts.nix
  ];
  home.stateVersion = "24.05";
}
