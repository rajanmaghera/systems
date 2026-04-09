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
      listModType = lib.mkOptionType {
        name = "singleOrListModule";
        description = "a single deferred module or a list of deferred modules";
        check =
          val:
          if builtins.isList val then
            lib.all lib.types.deferredModule.check val
          else
            lib.types.deferredModule.check val;
        merge =
          loc: defs: lib.concatMap (def: if builtins.isList def.value then def.value else [ def.value ]) defs;
      };
    in
    {
      conf.mod = {
        darwin = lib.mkOption {
          type = listModType;
          default = [ ];
        };
        home = lib.mkOption {
          type = listModType;
          default = [ ];
        };
        nixos = lib.mkOption {
          type = listModType;
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
              type = listModType;
            };
            options.deploy = lib.mkOption {
              type = lib.types.nullOr lib.types.attrs;
              default = null;
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
        inputs.nixpkgs.lib.nixosSystem {
          modules = [
            {
              nixpkgs.pkgs = withSystem system ({ pkgs, ... }: pkgs);
            }
          ]
          ++ config.conf.mod.nixos
          ++ mod;
        };
      makeDarwin =
        name:
        {
          system,
          mod,
          ...
        }:
        inputs.darwin.lib.darwinSystem {
          specialArgs = {
            pkgs = withSystem system ({ pkgs, ... }: pkgs);
          };
          modules = config.conf.mod.darwin ++ mod;
        };

      makeHome =
        name:
        {
          system,
          mod,
          ...
        }:
        inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = withSystem system ({ pkgs, ... }: pkgs);
          modules = config.conf.mod.home ++ mod;
        };

      nixosAttrs = lib.attrsets.filterAttrs (n: v: v.class == "nixos") config.sys;
      darwinAttrs = lib.attrsets.filterAttrs (n: v: v.class == "darwin") config.sys;
      homeAttrs = lib.attrsets.filterAttrs (n: v: v.class == "home") config.sys;
      deployAttrs = lib.attrsets.filterAttrs (n: v: v.deploy != null) config.sys;

    in
    {
      nixosConfigurations = lib.attrsets.mapAttrs makeNixos nixosAttrs;
      darwinConfigurations = lib.attrsets.mapAttrs makeDarwin darwinAttrs;
      homeConfigurations = lib.attrsets.mapAttrs makeHome homeAttrs;
      deploy.nodes = lib.attrsets.mapAttrs (n: v: v.deploy) deployAttrs;
    };
}
