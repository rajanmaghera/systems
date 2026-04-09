{ inputs, config, ... }:
{

  conf.mod.home =
    {
      lib,
      config,
      ...
    }:
    let
      cfg = config.my.defaults;
    in
    {
      config = lib.mkIf cfg.enable {

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

  # Add home manager modules to nixos and darwin configs
  conf.mod.nixos = [
    {
      home-manager.sharedModules = config.conf.mod.home;
    }
  ];

  conf.mod.darwin = [

    {
      home-manager.sharedModules = config.conf.mod.home;
    }
  ];

}
