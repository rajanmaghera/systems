{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.my.defaults;
in
{
  options.my.defaults = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    fullName = mkOption {
      type = types.str;
      default = "Rajan Maghera";
      description = "Full name of the main user";
    };

    authorizedKeys = mkOption {
      type = types.listOf types.str;
      default = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG8ZCH5zjDnnRouiFA0QrGuygX8mi4EWGj4nsXwQyKQ+ rajanmaghera@RajansMacBookPro"
      ];
      description = "Safe or authorized SSH keys for accessing machines";
    };

    username = mkOption {
      type = types.str;
      description = "User name of the main user";
    };

    avatar = mkOption {
      type = types.path;
      default = pkgs.fetchurl {
        url = "https://avatars.githubusercontent.com/u/16507599?v=4";
        sha256 = "sha256-WlBioUp+cH5YGS8bPZZZT/boGhZsun5wScK1AkZ6hYM=";
      };
      description = "Profile avatar source.";
    };

    packages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "Extra packages to add to user.";
    };

    timeZone = mkOption {
      type = types.str;
      default = "America/Toronto";
    };

    hostName = mkOption {
      type = types.str;
    };

    system = mkOption {
      type = types.str;
    };

    homeDirectory = mkOption {
      type = types.str;
    };
  };
}
