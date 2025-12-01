{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.editor;
in
{
  options.my.editor = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    my.fonts.enable = true;

    programs.vscode = {
      enable = true;
      mutableExtensionsDir = true;
      profiles.default = {
        enableUpdateCheck = false;
        enableExtensionUpdateCheck = false;
        extensions = with pkgs.vscode-marketplace; [
          rust-lang.rust-analyzer
          github.vscode-pull-request-github
          usernamehw.errorlens
          vscodevim.vim
          bbenoist.nix
          github.copilot
        ];
        userSettings = builtins.fromJSON (builtins.readFile ./vscode.json);

      };
    };
  };
}
