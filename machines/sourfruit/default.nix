{ pkgs, ... }:
{
  my.defaults = {
    enable = true;
    username = "rajan";
    system = "aarch64-linux";
    homeDirectory = "/home/rajan";
    hostName = "sourfruit";
  };
  my.kde.enable = true;

  my.laptop-defaults.enable = true;
  my.qemu-guest.enable = true;
  services.openssh.enable = true;

  my.docker.enable = true;

  my.shell.zsh.enable = true;
  my.autowallpaper.enable = true;

  my.home = {
    my.editor.enable = true;
    my.term-editor.enable = false;
  };
}
