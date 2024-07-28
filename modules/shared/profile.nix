{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  baseConfg = builtins.fromJSON (builtins.readFile ../../configuration.json);
  source = pkgs.fetchurl {
    url = baseConfg.profile.url;
    sha256 = baseConfg.profile.sha256;
  };
  cfg = config.my.profile;
in {
  options.my.profile = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable automatic setting of user profile information.";
    };

    fullName = mkOption {
      type = types.str;
      default = "Rajan Maghera";
      description = "Full name of the main user";
    };

    user = mkOption {
      type = types.str;
      default = "rajan";
      description = "User name of the main user";
    };

    avatar = mkOption {
      type = types.path;
      default = source;
      description = "Profile avatar source.";
    };

    packages = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "Extra packages to add to user.";
    };
  };
}
