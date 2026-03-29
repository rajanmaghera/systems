let
  mod =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    with lib;
    {
      options.my.defaults.theme = {

        enable = mkOption {
          type = types.bool;
          default = true;
        };

        base16LightScheme = mkOption {
          type = types.str;
          default = "${pkgs.base16-schemes}/share/themes/cupertino.yaml";
        };

        base16DarkScheme = mkOption {
          type = types.str;
          default = "${pkgs.base16-schemes}/share/themes/atelier-dune.yaml";
        };

        base16LightColors = mkOption {
          type = types.anything;
          default = config.stylix.base16.mkSchemeAttrs config.my.defaults.theme.base16LightScheme;
        };

        base16DarkColors = mkOption {
          type = types.anything;
          default = config.stylix.base16.mkSchemeAttrs config.my.defaults.theme.base16DarkScheme;
        };

        fontFamily = mkOption {
          type = types.str;
          default = "Fragment Mono";
        };
      };
    };

in
{
  conf.mod.nixos = mod;
  conf.mod.darwin = mod;
  conf.mod.home = mod;
}
