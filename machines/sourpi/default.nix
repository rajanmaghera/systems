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

  my.docker.enable = true;

  my.autowallpaper.enable = true;
  my.profile.enable = true;
  my.profile.packages = with pkgs; [ firefox ];
  my.shell.zsh.enable = true;

}
