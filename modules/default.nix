let
  config = import ./config.nix;
in {
  system = userName: {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users."${userName}" = config;
  };
  config = config;
}
