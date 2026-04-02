{ inputs, ... }:
{
  conf.mod.home =
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

        # Add this flake to the local registry as 's'
        # (so it's never lost)
        nix.registry.s.flake = inputs.self;
        # To run any package (default or customized), use `nix run s#...`
      };
    };
}
