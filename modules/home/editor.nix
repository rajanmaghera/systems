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
      nerd-fonts.fira-code
      nerd-fonts.cousine
      nerd-fonts.iosevka
      nerd-fonts.jetbrains-mono
      nerd-fonts.im-writing
      custom-google-fonts
    ];

    programs.vscode = {
      enable = true;
      mutableExtensionsDir = true;
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      extensions = with pkgs.vscode-marketplace; [
        rust-lang.rust-analyzer
        github.vscode-pull-request-github
        mkhl.direnv
        usernamehw.errorlens
        github.github-vscode-theme
        vscodevim.vim
        bbenoist.nix
        github.copilot
        chadalen.vscode-jetbrains-icon-theme
        miguelsolorio.symbols
      ];
      userSettings = builtins.fromJSON (builtins.readFile ./vscode.json);
    };
  };
}
