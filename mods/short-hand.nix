{ lib, config, ... }:

let
  # Helper function to recursively find all shorthand functions inside `mods`
  collectLeaves =
    prefix: attrs:
    lib.concatLists (
      lib.mapAttrsToList (
        k: v:
        if builtins.isFunction v || v ? __functor then
          [
            {
              path = prefix ++ [ k ];
              value = v;
            }
          ]
        else if builtins.isAttrs v then
          collectLeaves (prefix ++ [ k ]) v
        else
          [ ]
      ) attrs
    );
in
{

  # quick funcs for shorthand defining options
  config._module.args.lb = {
    opt = {
      str =
        desc:
        lib.mkOption {
          type = lib.types.str;
          description = desc;
        };
      strDef =
        default: desc:
        lib.mkOption {
          type = lib.types.str;
          default = default;
          description = desc;
        };
      bool =
        default: desc:
        lib.mkOption {
          type = lib.types.bool;
          default = default;
          description = desc;
        };
      int =
        default: desc:
        lib.mkOption {
          type = lib.types.int;
          default = default;
          description = desc;
        };
    };
  };

  options = {
    mods = lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.unspecified;
      default = { };
    };

    ops = lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.unspecified;
      default = { };
    };

  };
  config = {
    conf.mod = lib.mapAttrs (
      target: targetMods:
      let
        targetOps = config.ops.${target} or { };
        leaves = collectLeaves [ ] targetMods;
      in
      map (
        leaf:
        let
          innerArgs = lib.functionArgs leaf.value;
          wrapperArgs = innerArgs // {
            config = false;
            lib = false;
          };
          wrapper =
            args:
            let
              targetConfig = args.config;
              targetLib = args.lib or lib;

              cfg = targetLib.attrByPath leaf.path { } targetConfig;
              thisOps = targetLib.attrByPath leaf.path { } targetOps;

              baseEnable = {
                enable = targetLib.mkOption {
                  type = targetLib.types.bool;
                  default = false;
                  description = "Enable ${targetLib.concatStringsSep "." leaf.path}";
                };
              };
            in
            {
              options = targetLib.setAttrByPath leaf.path (baseEnable // thisOps);
              config = targetLib.mkIf (cfg.enable or false) (leaf.value (args // { inherit cfg; }));
            };
        in
        lib.setFunctionArgs wrapper wrapperArgs
      ) leaves
    ) config.mods;
  };
}
