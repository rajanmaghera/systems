{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  # Dashboard configuration
  # Add an entry to the dashboard for the service
  config.services.homepage-dashboard = mkIf config.lab.enable {
    enable = true;

    services =
      attrsets.mapAttrsToList
      (name: value: {
        "${value.inp.category}" = [{"${value.inp.fullName}" = {href = "${value.url}";};}];
      })
      config.lab.details;
  };
}
