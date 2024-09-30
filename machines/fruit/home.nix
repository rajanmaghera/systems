{pkgs, ...}: {
  my.editor.enable = true;
  my.term-editor.enable = false;
  home.packages = with pkgs; [
    sketchybar-app-font
    sbmenus
  ];
}
