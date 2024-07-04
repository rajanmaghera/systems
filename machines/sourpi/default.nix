{
  config,
  lib,
  pkgs,
  options,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable =
    true; # Easiest to use and most distros use this by default.

  my.laptop-defaults.enable = true;
  my.kde.enable = true;
  my.qemu-guest.enable = true;

  users.users.rajan = {
    isNormalUser = true;
    extraGroups = ["wheel" "docker"]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [tree neovim firefox];
  };

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    tmux
    sapling
    vscodium
  ];

  services.openssh.enable = true;

  system.stateVersion = "23.11"; # Did you read the comment?

  my.docker.enable = true;

  lab.enable = true;
  my.autowallpaper.enable = true;
  my.shell.zsh.enable = true;

  lab.auth.enable = false;
  lab.auth.user = "rajan";
  lab.auth.password = "$2b$10$wbGfQG89a1O8TriinDwtc.H1.MQ83/lpUALeud35qdYGZzLrna4pi";
  lab.auth.secretKey = config.age.secrets.lab-key.path;

  lab.cockpit.enable = true;
  lab.firefly.enable = true;
}
