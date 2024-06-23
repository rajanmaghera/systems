{
  config,
  lib,
  pkgs,
  options,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./hardware.nix
  ];

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Use the systemd-boot EFI boot loader.
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable =
    true; # Easiest to use and most distros use this by default.

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  users.mutableUsers = true;
  users.users.rajan = {
    isNormalUser = true;
    packages = with pkgs; [neovim];
    home = "/home/rajan";
    description = "Rajan Maghera";
    extraGroups = ["wheel" "networkmanager"];
    password = "rajan";
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG8ZCH5zjDnnRouiFA0QrGuygX8mi4EWGj4nsXwQyKQ+ rajanmaghera@RajansMacBookPro"];
  };

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
  ];

  services.openssh.enable = true;

  # Disable firewall
  networking.firewall.enable = false;

  # Add AFP
  services.netatalk = {
    enable = true;
    settings = {
      Global = {
        "mimic model" = "MacPro";
        "uam list" = "uams_dhx_passwd.so,uams_dhx2_passwd.so";
        "hosts allow" = "192.168.0.1/16";
      };

      "Dessert Cake" = {
        path = "/drive";
        "valid users" = "rajan";
      };
      "Photos" = {
        path = "/drive/Photos";
        "valid users" = "rajan";
	"file perm" = 0400;
	"directory perm" = 0400;
      };
      "Time Machine" = {
        path = "/drive/TimeMachine";
	"time machine" = "yes";
        "valid users" = "rajan";
      };
    };
  };

  # Add avahi (needed for AFP)
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };

  # Enable lab
  lab.enable = true;
  lab.cockpit.enable = true;
  lab.firefly.enable = true;

  system.stateVersion = "23.11"; # Did you read the comment?
}
