{
  config,
  options,
  pkgs,
  lib,
  ...
}:
with lib;
let
  domain = "${config.lab.system}.${config.lab.tld}";
  rpAuthMixin = ''
    route {
      authorize with users_policy
    }
  '';
in
{
  options = {
    lab.enable = mkOption {
      type = types.bool;
      default = false;
    };

    lab.tld = mkOption {
      type = types.str;
      default = "local";
    };

    lab.auth = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };

      password = mkOption {
        type = types.str;
      };

      secretKey = mkOption {
        type = types.path;
      };
    };

    lab.system = mkOption {
      type = types.str;
      default = config.networking.hostName;
    };

    lab.register = mkOption {
      type = types.attrsOf (
        types.submodule {
          options = {
            port = mkOption { type = types.port; };
            ws = mkOption {
              type = types.bool;
              default = false;
            };
            category = mkOption { type = types.str; };
            fullName = mkOption { type = types.str; };
            abbr = mkOption { type = types.str; };
          };
        }
      );
      default = { };
    };

    lab.details = mkOption {
      type = types.attrsOf (
        types.submodule {
          options = {
            url = mkOption { type = types.str; };
            wsUrl = mkOption { type = types.str; };
            inp = mkOption { type = types.anything; };
          };
        }
      );
      default = { };
    };
  };

  # Configuration variables that we might want to expose to the services
  # This should be kept as minimal as possible, only what the services need to
  # function, ie. for reverse proxy forwarding. Other values should be calculated and only
  # used here.
  config.lab.details = mkIf config.lab.enable (
    builtins.mapAttrs (name: value: {
      url = "https://${name}.${domain}";
      wsUrl = mkIf config.lab.register.${name}.ws "wss://${name}.${domain}";
      inp = value;
    }) config.lab.register
  );

  # Firewall config
  # Only allow 443, never 80 and never service ports (for now)
  config.networking.firewall.allowedTCPPorts = mkIf config.lab.enable [ 443 ];

  # Hosts config
  config.networking.extraHosts = mkIf config.lab.enable ''
    ${strings.concatStringsSep "\n" (
      attrsets.mapAttrsToList (name: value: "127.0.0.1 ${name}.${domain}") config.lab.register
    )}

    127.0.0.1 ${domain}
    127.0.0.1 auth.${domain}
  '';

  # Reverse proxy configuration
  config.services.caddy = mkIf config.lab.enable {
    enable = true;

    virtualHosts =
      {
        "${domain}".extraConfig = ''
          reverse_proxy localhost:8082

          ${optionalString config.lab.auth.enable rpAuthMixin}
        '';
      }
      // (attrsets.mapAttrs' (
        name: value:
        nameValuePair "${name}.${domain}" {
          extraConfig = ''

            ${optionalString config.lab.auth.enable rpAuthMixin}

            reverse_proxy localhost:${toString value.inp.port} {

              request_buffers 128k
             response_buffers 128k

              transport http {
                tls_insecure_skip_verify
                read_buffer 128k
                write_buffer 128k
              }
            }
          '';
        }
      ) config.lab.details);
  };
}
