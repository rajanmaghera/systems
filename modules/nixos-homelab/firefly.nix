{
  config,
  options,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.lab.firefly;

  sv = {
    port = 7000;
    ws = true;
    category = "Financial";
    fullName = "Firefly III";
    abbr = "FF";
  };
in {
  options.lab.firefly = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = {
    lab.register.firefly = mkIf cfg.enable sv;

    system.activationScripts.makeFireflyFoldersForPersistentData = mkIf cfg.enable (lib.stringAfter ["var"] ''
      mkdir -p /var/lib/firefly/upload
      mkdir -p /var/lib/firefly/database
    '');

    virtualisation.oci-containers = mkIf cfg.enable {
      backend = "docker";
      containers = {
        firefly-app = {
          image = "fireflyiii/core:latest";
          hostname = "firefly-app";
          volumes = [
            "/var/lib/firefly/upload:/var/www/html/storage/upload"
          ];
          autoStart = true;
          dependsOn = ["firefly-db"];
          environmentFiles = [./firefly.env];
          ports = ["7000:8080"];
          extraOptions = ["--network=firefly-net"];
        };

        firefly-db = {
          image = "mariadb:lts";
          hostname = "firefly-db";
          autoStart = true;
          environmentFiles = [./firefly.db.env];
          extraOptions = ["--network=firefly-net"];
          volumes = [
            "/var/lib/firefly/database:/var/lib/mysql"
          ];
        };

        firefly-cron = {
          autoStart = true;
          image = "alpine";
          hostname = "firefly-cron";
          entrypoint = "sh";
          cmd = [
            "-c"
            "echo \"0 3 * * * wget -qO- http://firefly-app:8080/api/v1/cron/REPLACEME\" | crontab - && crond -f -L /dev/stdout"
          ];
          extraOptions = ["--network=firefly-net"];
        };
      };
    };
  };
}
