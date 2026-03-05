{ inputs, ... }:
{

  systems = [
    "x86_64-linux"
    "aarch64-linux"
    "aarch64-darwin"
  ];

  flake =
    let
      # Top-level packages object used by everything
      makePkgs =
        system:
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

      # Function to generate configurations for each system
      each =
        f:
        builtins.listToAttrs (
          map
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
        inputs.nixpkgs.lib.nixosSystem {
          modules = [
            {
              nixpkgs.pkgs = makePkgs system;
            }
            inputs.home-manager.nixosModules.home-manager
            inputs.stylix.nixosModules.stylix
            inputs.disko.nixosModules.disko
            inputs.nixarr.nixosModules.default
            ../modules/home/system-module.nix
            ../modules/nixos
            ../modules/shared/module.nix
            ../modules/shared/nested-home-module.nix
            configModule
          ];
        };

      # Builder for Darwin config
      makeDarwin =
        configModule: system:
        inputs.darwin.lib.darwinSystem {
          specialArgs = {
            pkgs = makePkgs system;
          };
          modules = [
            inputs.home-manager.darwinModules.home-manager
            inputs.stylix.darwinModules.stylix
            ../modules/home/system-module.nix
            ../modules/darwin
            ../modules/shared/module.nix
            ../modules/shared/nested-home-module.nix
            configModule
          ];
        };

      # Builder for standalone HM configurations
      makeHome =
        configModule: system:
        inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = makePkgs system;
          modules = [
            inputs.stylix.homeModules.stylix
            ../modules/home/home-module.nix
            ../modules/shared/module.nix
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
        sourfruit = makeNixos ../machines/sourfruit "aarch64-linux";

      };

      # Darwin (macOS) configuration
      darwinConfigurations = {
        fruit = makeDarwin ../machines/fruit "aarch64-darwin";
      };

      # Home Manager configuration
      homeConfigurations = {
        precision = makeHome ../machines/precision "x86_64-linux";
      };

      # Hydra jobs
      hydraJobs =
        let
          x86_64-linux-pkgs = makePkgs "x86_64-linux";
        in
        {
          homeConfigurations = {
            precision = inputs.self.homeConfigurations.precision.activationPackage;
          };
          packages.x86_64-linux = {
            inherit (x86_64-linux-pkgs)
              my-emacs
              my-cli
              rars_1_5
              rars_1_6
              my-tex
              ;
          };
        };

    };

}
