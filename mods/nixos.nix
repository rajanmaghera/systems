{
  conf.mod.nixos =
    {
      lib,
      config,
      ...
    }:
    let
      cfg = config.my.defaults;
    in
    {
      options.my.home = lib.mkOption {
        type = lib.types.anything;
      };

      config = lib.mkIf cfg.enable {

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
        home-manager.users."${cfg.username}" = lib.recursiveUpdate config.my.home {
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

        services.openssh.settings.AllowUsers = [ cfg.username ];

      };
    };
}
