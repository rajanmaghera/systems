let
  home = import ./home.nix;
in {
  home = home;
  darwin = {config, ...}: {
    imports = [
      ./darwin.nix
    ];
    home-manager.users."${config.my.profile.user}" = home // config.my.home.config;
  };
  nixos = {config, ...}: {
    imports = [
      ./nixos.nix
    ];
    home-manager.users."${config.my.profile.user}" = home // config.my.home.config;
  };
}
