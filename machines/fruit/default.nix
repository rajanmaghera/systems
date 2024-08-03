{pkgs, ...}: {
  # Enable Nix darwin defaults.
  services.nix-daemon.enable = true;
  system.stateVersion = 4;

  # Enable Linux builder
  nix.linux-builder.enable = true;
  nix.linux-builder.maxJobs = 8;
  nix.settings.extra-trusted-users = ["rajan"];

  # Use Touch ID for sudo
  security.pam.enableSudoTouchIdAuth = true;
  # TODO: add pam_reattach support

  # Add home configuration
  users.users.rajan.home = "/Users/rajan";

  my.shell.zsh.enable = true;
  my.home.config = {
    my.editor.enable = true;
  };
}
