{ pkgs, ... }:
{
  # Enable Nix darwin defaults.
  system.stateVersion = 4;
  nix.settings.extra-trusted-users = [ "rajan" ];

  # Use Touch ID for sudo
  my.security.pam.enable = true;

  # Add home configuration
  users.users.rajan.home = "/Users/rajan";
  system.primaryUser = "rajan";
  ids.gids.nixbld = 350;

  # Enable zsh shell
  programs.zsh.enable = true;
  environment.shells = [ pkgs.zsh ];
  users.users.rajan.shell = pkgs.zsh;

  # Enable custom window management
  my.aerospace.enable = true;

}
