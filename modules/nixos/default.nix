{ ... }:
{
  imports = [
    ./kde.nix
    ./gnome.nix
    ./laptop-defaults.nix
    ./qemu-guest.nix
    ./docker.nix
    ./autowallpaper.nix
    ./profile.nix
    ./gui.nix
    ./tailscale.nix
    ./zsh.nix
  ];
}
