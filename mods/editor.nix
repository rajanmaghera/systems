{
  mods.home.my.editor =
    {
      pkgs,
      ...
    }:
    {
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
