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

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable =
    true; # Easiest to use and most distros use this by default.

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  services.xserver.enable = true;
  services.xserver.displayManager.defaultSession = "plasma";
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;
  security.polkit.enable = true;

  # QEMU guest
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
  services.xserver.videoDrivers = ["qxl"];

  users.users.rajan = {
    isNormalUser = true;
    extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [tree neovim firefox];
  };

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    tmux
    sapling
  ];

  services.openssh.enable = true;

  system.stateVersion = "23.11"; # Did you read the comment?

  lab.enable = true;

  lab.auth.enable = false;
  lab.auth.user = "rajan";
  lab.auth.password = "$2b$10$wbGfQG89a1O8TriinDwtc.H1.MQ83/lpUALeud35qdYGZzLrna4pi";
  lab.auth.secretKey = "a-private-secret-key";

  lab.cockpit.enable = true;
}
