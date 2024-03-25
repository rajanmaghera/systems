let
  config = import ./config.nix;
in {
  inherit config;
  system = userName: {
    home-manager.users."${userName}" = config;
  };
}
