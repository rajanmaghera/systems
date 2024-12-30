{pkgs, ...}: {
  # Enable Nix darwin defaults.
  services.nix-daemon.enable = true;
  system.stateVersion = 4;
  nix.settings.extra-trusted-users = ["rajan"];

  # Enable Linux builder
  nix.linux-builder.enable = true;
  nix.linux-builder.maxJobs = 1;

  # Use Touch ID for sudo
  security.pam.enableSudoTouchIdAuth = true;

  # Add home configuration
  users.users.rajan.home = "/Users/rajan";

  # Enable zsh shell
  programs.zsh.enable = true;
  environment.shells = [pkgs.zsh];
  users.users.rajan.shell = pkgs.zsh;

  # Enable custom window management
  my.yabai.enable = true;
  my.sketchybar.enable = true;
  my.skhd.enable = true;
}
