{
  nixpkgs,
  darwin,
  home-manager,
  crane,
  nix-vscode-extensions,
  stylix,
  disko,
  deploy-rs,
  k,
  flake-compat,
}:

let
  flake =
    src:
    (import flake-compat {
      inherit src;
      nodeOverrides = {
        nixpkgs = flake nixpkgs;
        darwin = flake darwin;
        home-manager = flake home-manager;
        crane = flake crane;
        nix-vscode-extensions = flake nix-vscode-extensions;
        stylix = flake stylix;
        disko = flake disko;
        deploy-rs = flake deploy-rs;
        k = flake k;
      };
    }).result;
in
(flake ./.).outputs.hydraJobs
