let
  mod =
    {
      lib,
      pkgs,
      ...
    }:
    {
      options.my.defaults = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };

        fullName = lib.mkOption {
          type = lib.types.str;
          default = "Rajan Maghera";
          description = "Full name of the main user";
        };

        authorizedKeys = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG8ZCH5zjDnnRouiFA0QrGuygX8mi4EWGj4nsXwQyKQ+ rajanmaghera@RajansMacBookPro"
          ];
          description = "Safe or authorized SSH keys for accessing machines";
        };

        username = lib.mkOption {
          type = lib.types.str;
          description = "User name of the main user";
        };

        avatar = lib.mkOption {
          type = lib.types.path;
          default = pkgs.fetchurl {
            url = "https://avatars.githubusercontent.com/u/16507599?v=4";
            sha256 = "sha256-WlBioUp+cH5YGS8bPZZZT/boGhZsun5wScK1AkZ6hYM=";
          };
          description = "Profile avatar source.";
        };

        packages = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
          description = "Extra packages to add to user.";
        };

        timeZone = lib.mkOption {
          type = lib.types.str;
          default = "America/Toronto";
        };

        hostName = lib.mkOption {
          type = lib.types.str;
        };

        homeDirectory = lib.mkOption {
          type = lib.types.str;
        };
      };
    };
in
{
  conf.mod.nixos = mod;
  conf.mod.darwin = mod;
  conf.mod.home = mod;
}
