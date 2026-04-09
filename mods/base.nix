{ inputs, withSystem, ... }:
{

  systems = [
    "x86_64-linux"
    "aarch64-linux"
    "aarch64-darwin"
  ];

  # Hydra jobs
  flake.hydraJobs = {
    systems = {
      x86_64-linux = {
        precision = inputs.self.homeConfigurations.precision.activationPackage;
      };
      aarch64-linux = {

      };
      aarch64-darwin = {
        fruit = inputs.self.darwinConfigurations.fruit.system;
      };
    };
    packages.aarch64-darwin = withSystem "aarch64-darwin" (
      { pkgs, ... }:
      {
        inherit (pkgs)
          my-emacs
          my-cli
          rars_1_5
          rars_1_6
          my-tex
          deploy-rs
          ;
      }
    );
    packages.x86_64-linux = withSystem "x86_64-linux" (
      { pkgs, ... }:
      {
        inherit (pkgs)
          my-cli
          rars_1_5
          rars_1_6
          my-tex
          deploy-rs
          ;
      }
    );
    packages.aarch64-linux = withSystem "aarch64-linux" (
      { pkgs, ... }:
      {
        inherit (pkgs)
          my-cli
          rars_1_5
          rars_1_6
          my-tex
          deploy-rs
          ;
      }
    );
  };

  # GitHub CI jobs as aggregates
  flake.ciJobs = {
    packages.aarch64-darwin = withSystem "aarch64-darwin" (
      { pkgs, ... }:
      pkgs.linkFarmFromDrvs "packages-aarch64-darwin" (
        builtins.attrValues inputs.self.hydraJobs.packages.aarch64-darwin
      )
    );
    packages.aarch64-linux = withSystem "aarch64-linux" (
      { pkgs, ... }:
      pkgs.linkFarmFromDrvs "packages-aarch64-linux" (
        builtins.attrValues inputs.self.hydraJobs.packages.aarch64-linux
      )
    );
    packages.x86_64-linux = withSystem "x86_64-linux" (
      { pkgs, ... }:
      pkgs.linkFarmFromDrvs "packages-x86_64-linux" (
        builtins.attrValues inputs.self.hydraJobs.packages.x86_64-linux
      )
    );
    systems.aarch64-darwin = withSystem "aarch64-darwin" (
      { pkgs, ... }:
      pkgs.linkFarmFromDrvs "systems-aarch64-darwin" (
        (builtins.attrValues inputs.self.hydraJobs.packages.aarch64-darwin)
        ++ (builtins.attrValues inputs.self.hydraJobs.systems.aarch64-darwin)
      )
    );
    systems.aarch64-linux = withSystem "aarch64-linux" (
      { pkgs, ... }:
      pkgs.linkFarmFromDrvs "systems-aarch64-linux" (
        (builtins.attrValues inputs.self.hydraJobs.packages.aarch64-linux)
        ++ (builtins.attrValues inputs.self.hydraJobs.systems.aarch64-linux)
      )
    );
    systems.x86_64-linux = withSystem "x86_64-linux" (
      { pkgs, ... }:
      pkgs.linkFarmFromDrvs "systems-x86_64-linux" (
        (builtins.attrValues inputs.self.hydraJobs.packages.x86_64-linux)
        ++ (builtins.attrValues inputs.self.hydraJobs.systems.x86_64-linux)
      )
    );
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
