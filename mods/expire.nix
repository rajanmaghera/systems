{
  inputs,
  lib,
  config,
  ...
}:
let

  timeBombSubmodType = lib.types.attrsOf (
    lib.types.submodule {
      options = {
        message = lib.mkOption {
          type = lib.types.str;
          description = "The reason for this workaround and how to fix it.";
        };
        warnDate = lib.mkOption {
          type = lib.types.nullOr lib.types.int;
          default = null;
          description = "Unix timestamp to start warning the user. Switches to finalConfig.";
        };
        abortDate = lib.mkOption {
          type = lib.types.int;
          description = "Unix timestamp to strictly abort the build. Switches to finalConfig.";
        };
        tempConfig = lib.mkOption {
          type = lib.types.deferredModule;
          default = { };
          description = "The temporary module/configuration to use until the dates are hit.";
        };
        finalConfig = lib.mkOption {
          type = lib.types.deferredModule;
          default = { };
          description = "The correct module/configuration that should be enforced after the date.";
        };
      };
    }
  );

  mapSubmod =
    name:
    {
      message,
      warnDate,
      abortDate,
      tempConfig,
      finalConfig,
    }:

    # This returns a standard NixOS module
    let
      # Fallback to 0 if lastModified isn't available
      now = inputs.nixpkgs.lastModified;

      # Date Math Helper
      dateIntToUnix =
        dateInt:
        let
          y = dateInt / 10000;
          m = (dateInt / 100) - (y * 100);
          d = dateInt - (dateInt / 100) * 100;
          y_adj = if m <= 2 then y - 1 else y;
          m_adj = if m <= 2 then m + 9 else m - 3;
          era = y_adj / 400;
          yoe = y_adj - (era * 400);
          doy = ((153 * m_adj) + 2) / 5 + d - 1;
          doe = (yoe * 365) + (yoe / 4) - (yoe / 100) + doy;
        in
        ((era * 146097) + doe - 719468) * 86400;

      abortUnix = dateIntToUnix abortDate;
      warnUnix = if warnDate != null then dateIntToUnix warnDate else null;

      isFatal = now > abortUnix;
      isWarn = warnUnix != null && now > warnUnix;

      activeConfig = if (isFatal || isWarn) then finalConfig else tempConfig;
      tbConfig =
        { lib, ... }:
        {
          assertions = [
            {
              assertion = !isFatal;
              message = ''
                💥 TIME BOMB EXPIRED [${name}] 💥
                Reason: ${message}
                Action: The grace period ended. Workaround removed, please fix!
              '';
            }
          ];

          warnings = lib.optional (
            isWarn && !isFatal
          ) "⏳ TIME BOMB WARNING [${name}]: ${message}. Grace period ending soon!";
        };
    in
    [
      activeConfig
      tbConfig
    ];
in
{
  options = {
    conf.modTb = {
      darwin = lib.mkOption {
        type = timeBombSubmodType;
        default = { };
      };
      home = lib.mkOption {
        type = timeBombSubmodType;
        default = { };
      };
      only-home = lib.mkOption {
        type = timeBombSubmodType;
        default = { };
      };
      nixos = lib.mkOption {
        type = timeBombSubmodType;
        default = { };
      };
    };
  };

  config = {
    conf.mod.nixos = lib.flatten (lib.mapAttrsToList mapSubmod config.conf.modTb.nixos);
    conf.mod.darwin = lib.flatten (lib.mapAttrsToList mapSubmod config.conf.modTb.darwin);
    conf.mod.home = lib.flatten (lib.mapAttrsToList mapSubmod config.conf.modTb.home);
  };

}
