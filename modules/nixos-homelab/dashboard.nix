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
    settings = {
      title = config.networking.hostName;
      headerStyle = "clean";
    };

    widgets = [
      {
        search = {
          provider = "google";
          focus = true;
          showSearchSuggestions = true;
          target = "_blank";
        };
      }
      {
        resources = {
          cpu = true;
          memory = true;
          disk = "/";
          cputemp = true;
          uptime = true;
          units = "metric";
          refresh = 3000;
          diskUnits = "bytes";
        };
      }
    ];

    services =
      (attrsets.mapAttrsToList
        (name: value: {
          "${value.inp.category}" = [{"${value.inp.fullName}" = {href = "${value.url}";};}];
        })
        config.lab.details)
      ++ [
        {
          "Server" = [
            {
              "Caddy" = {
                href = "http://localhost:2019";
                description = "Reverse proxy";
                icon = "caddy.png";
                widget = {
                  type = "caddy";
                  url = "http://localhost:2019";
                };
              };
            }
          ];
        }
      ];
  };
}
