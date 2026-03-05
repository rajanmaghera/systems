{
  description = "Rajan's systems config";

  nixConfig.extra-experimental-features = "nix-command flakes";
  nixConfig.extra-substitutors = [ "https://k-framework.cachix.org" ];
  nixConfig.extra-trusted-public-keys = [
    "k-framework.cachix.org-1:jeyMXB2h28gpNRjuVkehg+zLj62ma1RnyyopA/20yFE="
  ];

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    crane.url = "github:ipetkov/crane";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-vscode-extensions.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:nix-community/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    deploy-rs.url = "github:serokell/deploy-rs";
    nixarr.url = "github:rasmus-kirk/nixarr/dev";
    k.url = "github:runtimeverification/k";
    flake-compat.url = "github:rajanmaghera/flake-compat";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    import-tree.url = "github:vic/import-tree";
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./mods);

}
