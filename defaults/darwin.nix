{config, ...}: {
  my.shell.zsh.enable = true;
  nixpkgs.hostPlatform = config.my.system.platform;
  networking.hostName = config.my.system.hostName;
}
