{
  description = "Rajan's systems config";

  nixConfig.extra-experimental-features = "nix-command flakes";
  nixConfig.extra-substitutors = [
    "https://k-framework.cachix.org/"
    "https://rajan.cachix.org/"
    "https://nix-community.cachix.org/"
  ];
  nixConfig.extra-trusted-public-keys = [
    "k-framework.cachix.org-1:jeyMXB2h28gpNRjuVkehg+zLj62ma1RnyyopA/20yFE="
    "rajan.cachix.org-1:WdBz6DVZhJafNOoIHXsTfikZTvQHvhUo71+pEi1LqEw="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];

  # A seperate nixpkgs input is required for darwin as we want our repo to be configured for both
  # nixos tests passing and darwin tests passing. There is no single gated CI for this on Nix's hydra
  # so this is a compromise
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs-darwin";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-darwin";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-vscode-extensions.inputs.nixpkgs.follows = "nixpkgs-darwin";
    base16.url = "github:SenchoPens/base16.nix";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    deploy-rs.url = "github:serokell/deploy-rs";
    nixarr.url = "github:rasmus-kirk/nixarr/dev";
    k.url = "github:runtimeverification/k";
    flake-compat.url = "github:rajanmaghera/flake-compat";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs-darwin";
    import-tree.url = "github:vic/import-tree";
    plasma-manager.url = "github:nix-community/plasma-manager";
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.inputs.home-manager.follows = "home-manager";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    vscode-server.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs:
    let
      mods = inputs.import-tree ./mods;
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ mods ];
      flake.flakeModules.default = mods;
    };
}
