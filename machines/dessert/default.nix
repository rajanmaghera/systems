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

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Use the systemd-boot EFI boot loader.
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  security.initialRootPassword = "rootrajan";

  # Enable sound.
  hardware.pulseaudio.enable = true;
  users.mutableUsers = true;
  users.users.rajan = {
    isNormalUser = true;
    packages = with pkgs; [ neovim ];
    home = "/home/rajan";
    description = "Rajan Maghera";
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    password = "rajan";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG8ZCH5zjDnnRouiFA0QrGuygX8mi4EWGj4nsXwQyKQ+ rajanmaghera@RajansMacBookPro"
    ];
  };

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
  ];

  services.openssh.enable = true;

}
