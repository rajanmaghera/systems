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
  };

  outputs =
    {
      self,
      nixpkgs,
      darwin,
      home-manager,
      crane,
      nix-vscode-extensions,
      stylix,
      disko,
      deploy-rs,
      nixarr,
      k,
      ...
    }:
    let

      # Top-level packages object used by everything
      makePkgs =
        system:
        import nixpkgs {
          inherit system;
          overlays = [
            ((import ./pkgs) { inherit crane home-manager; })
            nix-vscode-extensions.overlays.default
            darwin.overlays.default
            k.overlays.default
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

      # Function to generate configurations for each system
      each =
        f:
        builtins.listToAttrs (
          builtins.map
            (system: {
              name = system;
              value = f system;
            })
            [
              "x86_64-linux"
              "aarch64-darwin"
              "aarch64-linux"
            ]
        );

      # Function to generate configurations and nixpkgs for each system
      eachPkgs = f: (each (system: f (makePkgs system)));

      # Builder for NixOS config
      makeNixos =
        configModule: system:
        nixpkgs.lib.nixosSystem {
          modules = [
            {
              nixpkgs.pkgs = makePkgs system;
            }
            home-manager.nixosModules.home-manager
            stylix.nixosModules.stylix
            disko.nixosModules.disko
            nixarr.nixosModules.default
            ./modules/home/system-module.nix
            ./modules/nixos
            ./modules/shared/module.nix
            ./modules/shared/nested-home-module.nix
            configModule
          ];
        };

      # Builder for Darwin config
      makeDarwin =
        configModule: system:
        darwin.lib.darwinSystem {
          specialArgs = {
            pkgs = makePkgs system;
          };
          modules = [
            home-manager.darwinModules.home-manager
            stylix.darwinModules.stylix
            ./modules/home/system-module.nix
            ./modules/darwin
            ./modules/shared/module.nix
            ./modules/shared/nested-home-module.nix
            configModule
          ];
        };

      # Builder for standalone HM configurations
      makeHome =
        configModule: system:
        home-manager.lib.homeManagerConfiguration {
          pkgs = makePkgs system;
          modules = [
            stylix.homeModules.stylix
            ./modules/home/home-module.nix
            ./modules/shared/module.nix
            configModule
          ];

        };

    in
    {

      # Nix file formatter
      formatter = eachPkgs (
        pkgs:
        pkgs.nixfmt-tree.override {
          runtimeInputs = [ pkgs.nixfmt ];
        }
      );

      # Re-expose nixpkgs + custom packages + flake input packages
      legacyPackages = eachPkgs (pkgs: pkgs);

      # NixOS configuration
      nixosConfigurations = {
        sourfruit = makeNixos ./machines/sourfruit "aarch64-linux";

      };

      # Darwin (macOS) configuration
      darwinConfigurations = {
        fruit = makeDarwin ./machines/fruit "aarch64-darwin";
      };

      # Home Manager configuration
      homeConfigurations = {
        precision = makeHome ./machines/precision "x86_64-linux";
      };

      # Hydra jobs
      hydraJobs =
        let
          x86_64-linux-pkgs = makePkgs "x86_64-linux";
        in
        {
          homeConfigurations = {
            precision = self.homeConfigurations.precision.activationPackage;
          };
          packages.x86_64-linux = {
            inherit (x86_64-linux-pkgs)
              my-emacs
              my-cli
              rars
              my-tex
              ;
          };
        };

    };

}
