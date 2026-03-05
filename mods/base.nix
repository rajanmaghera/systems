{ inputs, withSystem, ... }:
{

  systems = [
    "x86_64-linux"
    "aarch64-linux"
    "aarch64-darwin"
  ];

  flake =
    let
      # Builder for NixOS config
      makeNixos =
        configModule: system:
        inputs.nixpkgs.lib.nixosSystem {
          modules = [
            {
              nixpkgs.pkgs = withSystem system ({ pkgs, ... }: pkgs);
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
            pkgs = withSystem system ({ pkgs, ... }: pkgs);
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
          pkgs = withSystem system ({ pkgs, ... }: pkgs);
          modules = [
            inputs.stylix.homeModules.stylix
            ../modules/home/home-module.nix
            ../modules/shared/module.nix
            configModule
          ];

        };

    in
    {

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
      hydraJobs = {
        homeConfigurations = {
          precision = inputs.self.homeConfigurations.precision.activationPackage;
        };
        packages.x86_64-linux = withSystem "x86_64-linux" (
          { pkgs, ... }:
          {
            inherit (pkgs)
              my-emacs
              my-cli
              rars_1_5
              rars_1_6
              my-tex
              ;
          }
        );
      };
    };

  perSystem =
    { pkgs, ... }:
    {

      # Nix file formatter
      formatter = pkgs.nixfmt-tree.override {
        runtimeInputs = [ pkgs.nixfmt ];
      };

      # Re-expose nixpkgs + custom packages + flake input packages
      legacyPackages = pkgs;
    };

}
