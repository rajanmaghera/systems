{ lib, config, ... }:

let
  # Define the expected structure of your shorthand
  shorthandType = lib.types.submodule {
    options = {
      conf = lib.mkOption {
        type = lib.types.unspecified;
        default = { ... }: { };
        description = "Configuration function wrapped in lib.mkIf";
      };
      opts = lib.mkOption {
        type = lib.types.unspecified;
        default = { ... }: { };
        description = "Options function mapped directly to options.my.<name>";
      };
    };
  };

  # modNodeType = lib.types.submodule {
  #   options = {
  #     # TODO: find the best "deferred" module type to use for m and opts
  #     m = lib.mkOption {
  #       type = lib.types.nullOr lib.types.unspecified; # Adjust unspecified to functionTo if needed
  #       default = null;
  #       description = "The module payload. If null, this node is just a structural path.";
  #     };
  #     addEnable = lib.mkOption {
  #       type = lib.types.bool;
  #       default = true;
  #       description = "Whether to add the default option to enable or not. By default this should be true, but it should be disabled if being used from many places";
  #     };
  #     opts = lib.mkOption {
  #       type = lib.types.nullOr lib.types.unspecified;
  #       default = null;
  #       description = "Extra options to add onto the new module";
  #     };

  #     # To override the enable option, just override it in opts

  #   };
  #   freeformType = lib.types.lazyAttrsOf modNodeType;
  # };

  # flattenMudTree =
  # tree:
  # let
  #   walk =
  #     path: node:
  #     let
  #       isModNode = node.m != null;
  #       currentNode =
  #         if isModNode then
  #           [
  #             (node // { _path = path; })
  #           ]
  #         else
  #           [ ];

  #       reservedKeys = [
  #         "m"
  #         "opts"
  #         "_"
  #         "description"
  #         "_path"
  #         "addEnable"
  #         "_module"
  #       ];
  #       childKeys = builtins.filter (k: !(builtins.elem k reservedKeys)) (builtins.attrNames node);
  #       children = builtins.concatMap (
  #         k:
  #         walk (path ++ [ k ]) (
  #           builtins.addErrorContext "on option with path [${toString path} ${k}]" node.${k}
  #         )
  #       ) childKeys;
  #     in
  #     currentNode ++ children;
  # in
  # walk [ ] tree;

in
{

  options = {
    mods = {
      nixos = lib.mkOption {
        type = lib.types.attrsOf shorthandType;
      };
      darwin = lib.mkOption {
        type = lib.types.attrsOf shorthandType;
      };
      home = lib.mkOption {
        type = lib.types.attrsOf shorthandType;
      };
    };
  };

  config =

    let
      buildBaseMod =
        name: modDef:
        {
          config,
          pkgs,
          lib,
          ...
        }@args:

        let

          cfg = config.my.${name};
          newArgs = args // {
            inherit cfg;
          };
          modOpts = modDef.opts newArgs;
          modConf = modDef.conf newArgs;

        in

        {
          options.my.${name} = {
            enable = lib.mkEnableOption "the ${name} module";
          }
          // modOpts;
          config = lib.mkIf cfg.enable (
            modConf
            // {
              assertions = [
                {
                  assertion = cfg.enable && config.my.defaults.enable;
                  message = "All custom modules require my set of defaults";
                }
              ];
            }
          );
        };
      buildIntoBaseModList = target: modAttrs: lib.attrValues (lib.mapAttrs buildBaseMod modAttrs);

    in
    {
      baseMods = lib.mapAttrs buildIntoBaseModList config.mods;
    };

  #   config = {
  #     baseMods = lib.mapAttrs (
  #       configType: allOptions:
  #       lib.mapAttrs:
  #         opts
  #       map (
  #         mod:
  #         {
  #           pkgs, # required to pass down
  #           lib,
  #           config,
  #           ...
  #         }@args:
  #         let
  #           baseEnable =
  #             if mod.addEnable then
  #               {
  #                 enable = lib.mkOption {
  #                   type = lib.types.bool;
  #                   default = false;
  #                   description = "Enable ${lib.concatStringsSep "." mod._path}";
  #                 };
  #               }
  #             else
  #               { };
  #
  #           finalOptions = baseEnable // (mod.opts (args // { inherit cfg; }));
  #           cfg = lib.attrByPath mod._path { } config;
  #         in
  #         {
  #           options = lib.setAttrByPath mod._path finalOptions;
  #           config = lib.mkIf cfg.enable (
  #             (builtins.addErrorContext "for module with path ${toString mod._path}" mod.m) (
  #               args // { inherit cfg; }
  #             )
  #           );
  #         }
  #       ) (flattenModTree targetTree)
  #     ) config.mods;
  #   };
}
