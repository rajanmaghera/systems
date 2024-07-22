let
  cfg = import ./config.nix;
in {
  system = {config, ...}: {
    imports = [./wallpaper-option.nix];
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users."${config.my.profile.user}" =
      cfg
      // {
        my.wallpaper.source = config.my.wallpaper.source;
      };
  };
  config = cfg;
}
