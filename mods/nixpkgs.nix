{
  inputs,
  lib,
  config,
  ...
}:
{

  options.pkgs = {
    unfree = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
    allUnfree = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    overlays = lib.mkOption {
      type = lib.types.listOf lib.types.raw;
      default = [ ];
    };
    def = lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.raw;
      default = { };
      description = "An attribute set of inline functions to be defined as outputs";
    };
    call = lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.raw;
      default = { };
      description = "An attribute set of inline functions to be passed to callPackage.";
    };
  };

  config.pkgs.unfree = [
    "vscode"
    "vscode-extension-github-copilot"
    "jetbrains"
    "jetbrains.clion"
    "clion"
  ];

  config.pkgs.overlays = [
    inputs.nix-vscode-extensions.overlays.default
    inputs.darwin.overlays.default
  ];

  config.perSystem =
    { system, ... }:
    let
      input-nixpkgs = if system == [ "aarch64-darwin" ] then inputs.nixpkgs-darwin else inputs.nixpkgs;
      base-pkgs = import input-nixpkgs {
        inherit system;
        overlays = config.pkgs.overlays ++ [
          (final: prev: builtins.mapAttrs (name: fn: final.callPackage fn { }) config.pkgs.call)
          (final: prev: builtins.mapAttrs (name: fn: fn final) config.pkgs.def)
        ];
        config = {
          allowUnfreePredicate =
            if config.pkgs.allUnfree then
              (pkg: true)
            else
              (pkg: builtins.elem (pkg.pname or "") config.pkgs.unfree);
        };
      };

      deploy-pkgs = import input-nixpkgs {
        inherit system;
        overlays = config.pkgs.overlays ++ [
          (final: prev: builtins.mapAttrs (name: fn: final.callPackage fn { }) config.pkgs.call)
          (final: prev: builtins.mapAttrs (name: fn: fn final) config.pkgs.def)
          inputs.deploy-rs.overlays.default
          (self: super: {
            deploy-rs = {
              inherit (base-pkgs) deploy-rs;
              lib = super.deploy-rs.lib;
            };
          })
        ];
        config = {
          allowUnfreePredicate =
            if config.pkgs.allUnfree then
              (pkg: true)
            else
              (pkg: builtins.elem (pkg.pname or "") config.pkgs.unfree);
        };
      };

    in
    {
      _module.args.pkgs = base-pkgs;

      # Deploy-rs packages since its really weird
      _module.args.deployLib = deploy-pkgs.deploy-rs.lib;

    };
}
