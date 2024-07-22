{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  source = pkgs.fetchurl {
    url = "https://avatars.githubusercontent.com/u/16507599?v=4";
    sha256 = "sha256-WlBioUp+cH5YGS8bPZZZT/boGhZsun5wScK1AkZ6hYM=";
  };
  authorizedKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG8ZCH5zjDnnRouiFA0QrGuygX8mi4EWGj4nsXwQyKQ+ rajanmaghera@RajansMacBookPro"
  ];
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

  config = mkIf cfg.enable {
    users.users."${cfg.user}" = {
      isNormalUser = true;
      description = "${cfg.fullName}";
      extraGroups = ["wheel" "docker"]; # Enable ‘sudo’ for the user.
      packages = with pkgs; [neovim] ++ cfg.packages;
      openssh.authorizedKeys.keys = authorizedKeys;
    };

    system.activationScripts.setProfileImage = mkIf config.my.gui.enable (lib.stringAfter ["var"]
      ''
        mkdir -p /var/lib/AccountsService/{icons,users}
        cp ${config.my.profile.avatar} /var/lib/AccountsService/icons/${config.my.profile.user}
        echo -e "[User]\nIcon=/var/lib/AccountsService/icons/${config.my.profile.user}\n" > /var/lib/AccountsService/users/${config.my.profile.user}
      '');
  };
}
