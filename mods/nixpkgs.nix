{ inputs, ... }:
{
  config.perSystem =
    { system, ... }:
    {
      _module.args.pkgs =

        import inputs.nixpkgs {
          inherit system;
          overlays = [
            ((import ../pkgs) { inherit (inputs) crane home-manager; })
            inputs.nix-vscode-extensions.overlays.default
            inputs.darwin.overlays.default
            inputs.k.overlays.default
          ];
          config = {
            allowUnfreePredicate =
              pkg:
              builtins.elem (pkg.pname or "") [
                "vscode"
                "vscode-extension-github-copilot"
                "jetbrains"
                "jetbrains.clion"
                "clion"
              ];
          };
        };
    };
}
