{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.my.editor;
in {
  options.my.editor = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      nerdfonts
    ];

    programs.vscode = {
      enable = true;
      mutableExtensionsDir = true;
      userSettings = builtins.fromJSON (builtins.readFile ./vscode.json);
      package = pkgs.vscodium;
    };
  };
}
