{ pkgs, ... }:
{
  my.defaults.enable = true;
  my.defaults.username = "rajan";
  my.defaults.homeDirectory = "/Users/rajan";
  my.defaults.hostName = "fruit";

  # Enable custom window management
  my.security.pam.enable = true;
  my.aerospace.enable = true;

  my.home = {
    my.editor.enable = true;
    my.term-editor.enable = false;
    home.packages = with pkgs; [
      sketchybar-app-font
      sbmenus
    ];
  };
}
