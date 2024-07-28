{...}: {
  imports = [
    ./dashboard.nix
    ./services.nix
    ./auth.nix
    ./cockpit.nix
    ./firefly.nix
  ];
}
