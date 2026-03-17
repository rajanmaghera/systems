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
      type = lib.mkOptionType {
        name = "recursiveAttrs";
        check = builtins.isAttrs;
        merge = loc: defs: lib.foldl lib.recursiveUpdate { } (map (x: x.value) defs);
      };
      default = { };
    };

    ops = lib.mkOption {
      type = lib.mkOptionType {
        name = "recursiveAttrs";
        check = builtins.isAttrs;
        merge = loc: defs: lib.foldl lib.recursiveUpdate { } (map (x: x.value) defs);
      };
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
          wrapper =
            {
              pkgs, # required to pass down
              lib,
              config,
              ...
            }@args:
            let

              cfg = lib.attrByPath leaf.path { } config;
              thisOps = lib.attrByPath leaf.path { } targetOps;

              baseEnable = {
                enable = lib.mkOption {
                  type = lib.types.bool;
                  default = false;
                  description = "Enable ${lib.concatStringsSep "." leaf.path}";
                };
              };
            in
            {
              options = lib.setAttrByPath leaf.path (baseEnable // thisOps);
              config = lib.mkIf cfg.enable (leaf.value (args // { inherit cfg; }));
            };
        in
        wrapper
      ) leaves
    ) config.mods;
  };
}
