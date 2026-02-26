let
  getUrlFromFlakeNode =
    node:
    if node.locked.type == "github" then
      "https://github.com/${node.locked.owner}/${node.locked.repo}/archive/${node.locked.rev}.tar.gz"
    else
      throw "non-supported url";

  lock = builtins.fromJSON (builtins.readFile ./flake.lock);

  getDefault =
    inputName:
    let
      nodeName = lock.nodes.root.inputs.${inputName};
      node = lock.nodes.${nodeName};
      nodeUrl = getUrlFromFlakeNode node;
    in
    fetchTarball {
      url = nodeUrl;
      sha256 = node.locked.narHash;
    };
in

{
  nixpkgs ? getDefault "nixpkgs",
  darwin ? getDefault "darwin",
  home-manager ? getDefault "home-manager",
  crane ? getDefault "crane",
  nix-vscode-extensions ? getDefault "nix-vscode-extensions",
  stylix ? getDefault "stylix",
  disko ? getDefault "disko",
  deploy-rs ? getDefault "deploy-rs",
  k ? getDefault "k",
  flake-compat ? getDefault "flake-compat",
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
    });
in
(flake ./.).outputs.hydraJobs
