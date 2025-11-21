{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.defaults;
in
{
  options.my.home = mkOption {
    type = types.anything;
  };

  config = mkIf cfg.enable {

    i18n.defaultLocale = "en_CA.UTF-8";
    system.stateVersion = "25.11";

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    networking.networkmanager.enable = true;
    time.timeZone = cfg.timeZone;
    networking.hostName = cfg.hostName;
    nix.settings.extra-trusted-users = [ cfg.username ];
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    home-manager.backupFileExtension = "bkup";
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users."${cfg.username}" = config.my.home // {
      my.defaults = cfg;
    };

    users.users."${cfg.username}" = {
      isNormalUser = true;
      description = "${cfg.fullName}";
      extraGroups = [
        "wheel"
      ];
      openssh.authorizedKeys.keys = cfg.authorizedKeys;
    };

    system.activationScripts.setProfileImage = mkIf config.my.gui.enable (
      lib.stringAfter [ "var" ] ''
        mkdir -p /var/lib/AccountsService/{icons,users}
        cp ${cfg.avatar} /var/lib/AccountsService/icons/${cfg.username}
        echo -e "[User]\nIcon=/var/lib/AccountsService/icons/${cfg.username}\n" > /var/lib/AccountsService/users/${cfg.username}
      ''
    );

  };
}
