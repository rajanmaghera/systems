let
  cfg = import ./config.nix;
in {
  system = userName: {config, ...}: {
    imports = [./wallpaper-option.nix];
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users."${userName}" =
      cfg
      // {
        my.wallpaper.source = config.my.wallpaper.source;
      };
  };
  config = cfg;
}
