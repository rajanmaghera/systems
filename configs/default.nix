{...}: {
  imports = [
    ./kde.nix
    ./gnome.nix
    ./laptop-defaults.nix
    ./qemu-guest.nix
    ./docker.nix
  ];
}
