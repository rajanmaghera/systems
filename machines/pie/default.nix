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

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    tmux
  ];

  services.openssh.enable = true;

  system.stateVersion = "24.05";

  my.tailscale.enable = true;
  my.docker.enable = true;
  my.profile.enable = true;
  my.profile.packages = with pkgs; [ firefox ];
  my.shell.zsh.enable = true;

}
