{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.my.defaults;
in
{
  config = mkIf cfg.enable {

    home.stateVersion = "25.11";
    home.username = cfg.username;
    home.homeDirectory = cfg.homeDirectory;

    xdg.enable = true;
    my.cli.enable = true;
    my.dev-env.enable = true;
    my.shell.zsh.enable = true;
    my.passwords.enable = true;
  };
}
