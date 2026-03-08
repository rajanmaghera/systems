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

      # Define a custom type that gracefully accepts and merges single modules and lists
      type = mkOptionType {
        name = "singleOrListModule";
        description = "a single deferred module or a list of deferred modules";

        # Check validates the inputs without evaluating the modules themselves
        check =
          val:
          if builtins.isList val then
            lib.all lib.types.deferredModule.check val
          else
            lib.types.deferredModule.check val;

        # The magic happens here: flatten everything into a single list
        merge =
          loc: defs: concatMap (def: if builtins.isList def.value then def.value else [ def.value ]) defs;
      };
    in
    {
      conf.mod = {
        darwin = lib.mkOption {
          inherit type;
        };
        home = lib.mkOption {
          inherit type;
        };
        nixos = lib.mkOption {
          inherit type;
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

  config.conf.mod = {
    nixos = [
      inputs.home-manager.nixosModules.home-manager
      inputs.stylix.nixosModules.stylix
      inputs.disko.nixosModules.disko
      inputs.nixarr.nixosModules.default
      ../modules/home/system-module.nix
      ../modules/nixos
      ../modules/shared/module.nix
      ../modules/shared/nested-home-module.nix
    ];
    darwin = [
      inputs.home-manager.darwinModules.home-manager
      inputs.stylix.darwinModules.stylix
      ../modules/home/system-module.nix
      ../modules/darwin
      ../modules/shared/module.nix
      ../modules/shared/nested-home-module.nix
    ];
    home = [
      inputs.stylix.homeModules.stylix
      ../modules/home/home-module.nix
      ../modules/shared/module.nix
    ];

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
            modules = config.conf.mod.darwin ++ mod;
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
            modules = config.conf.mod.home ++ mod;
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
