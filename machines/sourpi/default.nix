{
  config,
  lib,
  pkgs,
  options,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  i18n.defaultLocale = "en_CA.UTF-8";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;

  my.laptop-defaults.enable = true;
  my.kde.enable = true;
  my.qemu-guest.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    tmux
    sapling
  ];

  services.openssh.enable = true;

  system.stateVersion = "24.05";

  my.docker.enable = true;

  my.autowallpaper.enable = true;
  my.profile.enable = true;
  my.profile.packages = with pkgs; [ firefox ];
  my.shell.zsh.enable = true;

  lab.enable = true;
  lab.auth.enable = false;
  lab.auth.password = "$2b$10$wbGfQG89a1O8TriinDwtc.H1.MQ83/lpUALeud35qdYGZzLrna4pi";
  lab.auth.secretKey = config.age.secrets.lab-key.path;

  lab.cockpit.enable = true;
}
