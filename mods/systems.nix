{
  lib,
  inputs,
  config,
  withSystem,
  ...
}:
{

  options.conf.modules = {
    darwin = lib.mkOption {
      type = lib.types.listOf lib.types.deferredModule;
    };
    home = lib.mkOption {
      type = lib.types.listOf lib.types.deferredModule;
    };
    nixos = lib.mkOption {
      type = lib.types.listOf lib.types.deferredModule;
    };
  };

  options.sys = lib.mkOption {
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
        options.module = lib.mkOption {
          type = lib.types.deferredModule;
        };
        options.extraModules = lib.mkOption {
          type = lib.types.listOf lib.types.deferredModule;
          default = [ ];
        };
      }
    );
  };

  config.conf.modules = {
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
          module,
          extraModules,
          ...
        }:
        {
          nixosConfigurations.${name} = inputs.nixpkgs.lib.nixosSystem {
            modules = [
              {
                nixpkgs.pkgs = withSystem system ({ pkgs, ... }: pkgs);
              }
            ]
            ++ config.conf.modules.nixos
            ++ extraModules
            ++ [
              module
            ];
          };
        };
      makeDarwin =
        name:
        {
          system,
          module,
          extraModules,
          ...
        }:
        {

          darwinConfigurations.${name} = inputs.darwin.lib.darwinSystem {
            specialArgs = {
              pkgs = withSystem system ({ pkgs, ... }: pkgs);
            };
            modules =
              config.conf.modules.darwin
              ++ extraModules
              ++ [
                module
              ];
          };
        };

      makeHome =
        name:
        {
          system,
          module,
          extraModules,
          ...
        }:
        {
          homeConfigurations.${name} = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = withSystem system ({ pkgs, ... }: pkgs);
            modules =
              config.conf.modules.home
              ++ extraModules
              ++ [
                module
              ];
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
