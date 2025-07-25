{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.term-editor;
in
{
  options.my.term-editor = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.cousine
      nerd-fonts.iosevka
      nerd-fonts.jetbrains-mono
      nerd-fonts.geist-mono
      nerd-fonts.im-writing
      python39
      python39Packages.pip
      python39Packages.virtualenv
      python39Packages.pynvim
      nodejs
      ripgrep
      lunarvim
      yarn
    ];

    programs.neovim = {
      enable = true;
      withNodeJs = true;
      withPython3 = true;
    };
  };
}
