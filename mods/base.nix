{ inputs, withSystem, ... }:
{

  systems = [
    "x86_64-linux"
    "aarch64-linux"
    "aarch64-darwin"
  ];

  # Hydra jobs
  flake.hydraJobs = {
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
