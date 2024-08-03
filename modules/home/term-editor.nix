{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.my.term-editor;
in {
  options.my.term-editor= {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      custom-nerdfonts
      python39
      python39Packages.pip
      python39Packages.virtualenv
      nodejs
      cargo
      ripgrep
    ];

    programs.neovim = {
      enable = true;
    };
  };
}
