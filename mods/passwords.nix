{

  conf.modTb.home.broken-electron = {
    message = "Electron fails to build, causing Bitwarden to fail. Should be auto-fixed soon";
    warnDate = 20260401;
    abortDate = 20260415;
    tempConfig =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      let
        cfg = config.my.passwords;
      in
      {
        config = lib.mkIf cfg.enable {
          home.packages =
            if pkgs.stdenv.isLinux then
              [ ]
            else
              with pkgs;
              [
                bitwarden-cli
                bitwarden-desktop
              ];
        };
      };

    finalConfig =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      let
        cfg = config.my.passwords;
      in
      {
        config = lib.mkIf cfg.enable {
          home.packages = with pkgs; [
            bitwarden-cli
            bitwarden-desktop
          ];
        };
      };

  };

  mods.home.my.passwords =
    {
      pkgs,
      ...
    }:
    {
      # home.packages = with pkgs; [
      #   bitwarden-cli
      #   bitwarden-desktop
      # ];

    };
}
