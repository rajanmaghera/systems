{
  lib,
  inputs,
  config,
  withSystem,
  ...
}:
{

  options =
    let
      inherit (lib) mkOptionType concatMap;
      type = mkOptionType {
        name = "singleOrListModule";
        description = "a single deferred module or a list of deferred modules";
        check =
          val:
          if builtins.isList val then
            lib.all lib.types.deferredModule.check val
          else
            lib.types.deferredModule.check val;
        merge =
          loc: defs: concatMap (def: if builtins.isList def.value then def.value else [ def.value ]) defs;
      };
    in
    {
      conf.mod = {
        darwin = lib.mkOption {
          inherit type;
          default = [ ];
        };
        home = lib.mkOption {
          inherit type;
          default = [ ];
        };
        only-home = lib.mkOption {
          inherit type;
          default = [ ];
        };
        nixos = lib.mkOption {
          inherit type;
          default = [ ];
        };
      };

      sys = lib.mkOption {
        type = lib.types.lazyAttrsOf (
          lib.types.submodule {
            options.class = lib.mkOption {
              type = lib.types.enum [
                "darwin"
                "home"
                "nixos"
              ];
            };
            options.system = lib.mkOption {
              type = lib.types.str;
            };
            options.mod = lib.mkOption {
              inherit type;
            };
          }
        );
      };
    };

  config.flake =
    let
      makeNixos =
        name:
        {
          system,
          mod,
          ...
        }:
        {
          nixosConfigurations.${name} = inputs.nixpkgs.lib.nixosSystem {
            modules = [
              {
                nixpkgs.pkgs = withSystem system ({ pkgs, ... }: pkgs);
                home-manager.sharedModules = config.conf.mod.home;
              }
            ]
            ++ config.conf.mod.nixos
            ++ mod;
          };
        };
      makeDarwin =
        name:
        {
          system,
          mod,
          ...
        }:
        {
          darwinConfigurations.${name} = inputs.darwin.lib.darwinSystem {
            specialArgs = {
              pkgs = withSystem system ({ pkgs, ... }: pkgs);
            };
            modules = [
              {
                home-manager.sharedModules = config.conf.mod.home;
              }
            ]
            ++ config.conf.mod.darwin
            ++ mod;
          };
        };

      makeHome =
        name:
        {
          system,
          mod,
          ...
        }:
        {
          homeConfigurations.${name} = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = withSystem system ({ pkgs, ... }: pkgs);
            modules = config.conf.mod.only-home ++ config.conf.mod.home ++ mod;
          };
        };
    in
    lib.mkMerge (
      lib.attrsets.mapAttrsToList (
        name: cfg:
        (
          {
            "nixos" = makeNixos;
            "darwin" = makeDarwin;
            "home" = makeHome;
          }
          .${cfg.class}
        )
          name
          cfg
      ) config.sys
    );
}
