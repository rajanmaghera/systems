{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.fonts;
in
{
  options.my.fonts = {
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
      (google-fonts.override { fonts = [ "Fragment Mono" ]; })
    ];

  };
}
