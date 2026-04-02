let
  opt_mod =
    {
      lib,
      ...
    }:
    with lib;
    {
      options.my.defaults = {
        enableCaches = mkOption {
          type = types.bool;
          default = true;
          description = "Enable external caches";
        };
      };
    };
  mod =
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
      config = mkIf (cfg.enable && cfg.enableCaches) {
        nix.settings.substituters = [
          "https://cache.nixos.org/"
          "https://k-framework.cachix.org/"
          "https://rajan.cachix.org/"
          "https://nix-community.cachix.org/"
        ];

        nix.settings.trusted-public-keys = [
          "k-framework.cachix.org-1:jeyMXB2h28gpNRjuVkehg+zLj62ma1RnyyopA/20yFE="
          "rajan.cachix.org-1:WdBz6DVZhJafNOoIHXsTfikZTvQHvhUo71+pEi1LqEw="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };
    };
in
{
  conf.mod.home = [ opt_mod ];
  conf.mod.nixos = [
    opt_mod
    mod
  ];
  conf.mod.darwin = [
    opt_mod
    mod
  ];
}
