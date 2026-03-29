{ lib, config, ... }:

let

  mkRecursiveModTreeType =
    submoduleOptions:
    let
      submodKeys = [
        "mod"
        "_path"
      ]
      ++ builtins.attrNames submoduleOptions;
      nodeSubmodule = lib.types.submodule {
        options = submoduleOptions // {
          mod = lib.mkOption {
            type = lib.types.unspecified; # Change to types.functionTo, etc., depending on your needs
            description = "The module closure/payload";
          };
          _path = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            readOnly = true;
            description = "The internal path of this module in the tree";
          };
        };
      };

    in
    lib.mkOptionType {
      name = "recursiveModTree";
      description = "A recursive tree that flattens into a list of submodules when mod is found";

      # Recursively verify the tree structure consists of attrsets
      check =
        let
          checkNode = x: lib.isAttrs x && lib.all checkNode (lib.attrValues (removeAttrs x submodKeys));
        in
        checkNode;

      # `loc` is the path to this option (e.g., ["myTree"])
      # `defs` is a list of { file, value } for all declarations of this option
      merge =
        loc: defs:
        let
          walk =
            path: defsAtNode:
            let
              vals = map (d: d.value) defsAtNode;
              allKeys = lib.unique (lib.concatMap builtins.attrNames vals);
              isModNode = builtins.elem "mod" allKeys;
              evaluatedMod =
                if isModNode then
                  let

                    # Remove other child defs
                    filteredDefs = map (def: {
                      inherit (def) file;
                      value = lib.getAttrs (lib.intersectLists submodKeys (builtins.attrNames def.value)) def.value;
                    }) defsAtNode;

                    # inject the read-only `_path` field
                    pathDef = {
                      file = "internal-tree-walker";
                      value = {
                        _path = path;
                      };
                    };
                  in
                  # Call the submodule's merge function directly
                  nodeSubmodule.merge (loc ++ path) (filteredDefs ++ [ pathDef ])
                else
                  null;

              currentResult = if isModNode then [ evaluatedMod ] else [ ];

              # Recurse into children
              childKeys = builtins.filter (k: !(builtins.elem k submodKeys)) allKeys;
              childrenResults = map (
                childKey:
                let
                  # Gather all definitions that contain this specific child key
                  childDefs = builtins.concatMap (
                    def:
                    if def.value ? ${childKey} then
                      [
                        {
                          inherit (def) file;
                          value = def.value.${childKey};
                        }
                      ]
                    else
                      [ ]
                  ) defsAtNode;
                in
                walk (path ++ [ childKey ]) childDefs
              ) childKeys;

            in
            currentResult ++ lib.concatLists childrenResults;

        in
        walk [ ] defs;

      # Ensure an empty definition defaults to an empty list
      emptyValue = {
        value = [ ];
      };
    };

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

    def = lib.mkOption {
      type = mkRecursiveModTreeType {
      };
      default = [ ];
    };

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
