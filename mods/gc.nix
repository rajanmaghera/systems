{ inputs, ... }:
{

  # Automatic garbage collection services
  #
  # In general, run once a week deleting anything older than 7 days

  # Darwin
  mods.darwin.my.gc =
    {
      ...
    }:
    {
      programs.nh.enable = true;
      programs.nh.clean.enable = true;
      programs.nh.clean.extraArgs = "--keep-since 7d";
      programs.nh.clean.interval = [
        {
          Hour = 4;
          Minute = 30;
          Weekday = 7;
        }
      ];
    };

  # NixOS
  mods.nixos.my.gc =
    {
      ...
    }:
    {
      programs.nh.enable = true;
      programs.nh.clean.enable = true;
      programs.nh.clean.extraArgs = "--keep-since 7d";
      programs.nh.clean.dates = "weekly";
    };

  # Home-manager
  mods.home.my.gc =
    { ... }:
    {
      programs.nh.enable = true;
      programs.nh.clean.enable = true;
      programs.nh.clean.extraArgs = "--keep-since 7d";
      programs.nh.clean.dates = "weekly";
    };

  # Custom darwin module for nh to mirror nixos and home manager
  # (until this does/doesn't get merged into upstream)
  conf.mod.darwin =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.programs.nh;
      launchdTypes = import "${inputs.darwin}/modules/launchd/types.nix" { inherit config lib; };
    in

    {
      imports = [
        (lib.mkRemovedOptionModule [
          "programs"
          "nh"
          "clean"
          "dates"
        ] "Use `programs.nh.clean.interval` instead.")
      ];

      ###### interface

      options = {

        programs.nh = {
          enable = lib.mkEnableOption "nh, yet another Nix CLI helper";

          package = lib.mkPackageOption pkgs "nh" { };

          flake = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = ''
              The string that will be used for the `NH_FLAKE` environment variable.

              `NH_FLAKE` is used by nh as the default flake for performing actions, such as
              `nh os switch`. This behaviour can be overriden per-command with environment
              variables that will take priority.

              - `NH_OS_FLAKE`: will take priority for `nh os` commands.
              - `NH_HOME_FLAKE`: will take priority for `nh home` commands.
              - `NH_DARWIN_FLAKE`: will take priority for `nh darwin` commands.

              The formerly valid `FLAKE` is now deprecated by nh, and will cause hard errors
              in future releases if `NH_FLAKE` is not set.
            '';
          };

          clean = {
            enable = lib.mkEnableOption "periodic garbage collection with nh clean all";

            interval = lib.mkOption {
              type = launchdTypes.StartCalendarInterval;
              default = [
                {
                  Weekday = 7;
                  Hour = 3;
                  Minute = 15;
                }
              ];
              description = ''
                The calendar interval at which the garbage collector will run.
                See the {option}`serviceConfig.StartCalendarInterval` option of
                the {option}`launchd` module for more info.
              '';
            };

            extraArgs = lib.mkOption {
              type = lib.types.singleLineStr;
              default = "";
              example = "--keep 5 --keep-since 3d";
              description = ''
                Options given to nh clean when the service is run automatically.

                See `nh clean all --help` for more information.
              '';
            };
          };
        };
      };

      ###### implementation

      config = {

        warnings =
          if (!(cfg.clean.enable -> !config.nix.gc.automatic)) then
            [
              "programs.nh.clean.enable and nix.gc.automatic are both enabled. Please use one or the other to avoid conflict."
            ]
          else
            [ ];

        assertions = [
          # Not strictly required but probably a good assertion to have
          {
            assertion = cfg.clean.enable -> cfg.enable;
            message = "programs.nh.clean.enable requires programs.nh.enable";
          }

          {
            assertion = (cfg.flake != null) -> !(lib.hasSuffix ".nix" cfg.flake);
            message = "nh.flake must be a directory, not a nix file";
          }
          {
            assertion = cfg.clean.enable -> config.nix.enable;
            message = "programs.nh.clean.enable requires nix.enable";
          }
        ];

        environment = lib.mkIf cfg.enable {
          systemPackages = [ cfg.package ];
          variables = lib.mkIf (cfg.flake != null) {
            NH_FLAKE = cfg.flake;
          };
        };

        launchd.daemons.nh-clean = lib.mkIf cfg.clean.enable {
          path = [ config.nix.package ];
          command = "${lib.getExe cfg.package} clean all ${cfg.clean.extraArgs}";
          serviceConfig.RunAtLoad = false;
          serviceConfig.StartCalendarInterval = cfg.clean.interval;
        };
      };
    };
}
