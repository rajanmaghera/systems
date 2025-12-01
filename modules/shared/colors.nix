{ pkgs, lib, ... }:
with lib;
{
  options.my.defaults.theme = {

    enable = mkOption {
      type = types.bool;
      default = true;
    };

    base16Scheme = mkOption {
      type = types.str;
      default = "${pkgs.base16-schemes}/share/themes/chalk.yaml";
    };
  };

}
