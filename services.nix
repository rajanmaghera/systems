{
  config,
  options,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.lab.register;
  sys = config.lab.system;
  postfix = "local";
  domain = "${sys}.${postfix}";

  usr = "rajan";
  passwd = "$2b$10$wbGfQG89a1O8TriinDwtc.H1.MQ83/lpUALeud35qdYGZzLrna4pi";
  key = "ASDJCJDAS";

  rpAuthMixin = ''
    route {
      authorize with users_policy
    }
  '';
in {
  options = {
    lab.enable = mkOption {
      type = types.bool;
      default = false;
    };

    lab.auth = mkOption {
      type = types.bool;
      default = true;
    };

    lab.system = mkOption {type = types.str;};

    lab.register = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          port = mkOption {type = types.port;};
          ws = mkOption {
            type = types.bool;
            default = false;
          };
          category = mkOption {type = types.str;};
          fullName = mkOption {type = types.str;};
          abbr = mkOption {type = types.str;};
        };
      });
      default = {};
    };

    lab.details = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          url = mkOption {type = types.str;};
          wsUrl = mkOption {type = types.str;};
          inp = mkOption {type = types.anything;};
        };
      });
      default = {};
    };
  };

  # Configuration variables that we might want to expose to the services
  # This should be kept as minimal as possible, only what the services need to
  # function, ie. for reverse proxy forwarding. Other values should be calculated and only
  # used here.
  config.lab.details = mkIf config.lab.enable (builtins.mapAttrs
    (name: value: {
      url = "https://${name}.${domain}";
      wsUrl = mkIf cfg.${name}.ws "wss://${name}.${domain}";
      inp = value;
    })
    cfg);

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

  # Firewall config
  # Only allow 443, never 80 and never service ports (for now)
  config.networking.firewall.allowedTCPPorts = mkIf config.lab.enable [443];

  # Hosts config
  config.networking.extraHosts = mkIf config.lab.enable ''
    ${strings.concatStringsSep "\n"
      (attrsets.mapAttrsToList (name: value: "127.0.0.1 ${name}.${domain}") cfg)}

    127.0.0.1 ${domain}
    127.0.0.1 auth.${domain}
  '';

  # Reverse proxy configuration
  config.services.caddy = mkIf config.lab.enable {
    enable = true;
    package = mkIf config.lab.auth pkgs.caddy-extended;

    globalConfig = mkIf config.lab.auth ''
      order authenticate before respond
      order authorize before basicauth

         	security {
      	local identity store localdb {
      		realm local
      		path /var/lib/auth/users.json
      	        user ${usr} {
      	            name Administrator
      	            email ${usr}@${domain}
      		    password "bcrypt:10:${passwd}" overwrite
      	            roles authp/admin authp/user
      	        }
      	}

      	authentication portal myportal {
      		crypto default token lifetime 3600
      		crypto key sign-verify ${key}
      		enable identity store localdb
      		cookie domain ${domain}
      		ui {
      			links {
      				"My Identity" "/whoami" icon "las la-user"
      			}
      		}
      		transform user {
      			match origin local
      			action add role authp/user
      			ui link "Portal Settings" /settings icon "las la-cog"
      		}
      	}

      	authorization policy guests_policy {
      		# disable auth redirect
      		set auth url https://auth.${domain}/
      		allow roles authp/admin authp/user
      		crypto key verify ${key}
      		acl rule {
      			comment allow guests only
      			match role guest authp/guest
      			allow stop log info
      		}
      		acl rule {
      			comment default deny
      			match any
      			deny log warn
      		}
      	}

      	authorization policy users_policy {
      		set auth url http://auth.${domain}/
      		allow roles authp/admin authp/user
      		crypto key verify ${key}
      		acl rule {
      			comment allow users
      			match role authp/user
      			allow stop log info
      		}
      		acl rule {
      			comment default deny
      			match any
      			deny log warn
      		}

      	}
      }
    '';
    virtualHosts =
      {
        "${domain}".extraConfig = ''
          reverse_proxy localhost:8082

          ${optionalString config.lab.auth rpAuthMixin}
        '';

        "auth.${domain}".extraConfig = mkIf config.lab.auth ''
          route {
          	authenticate with myportal
          }
        '';
      }
      // (attrsets.mapAttrs'
        (name: value:
          nameValuePair "${name}.${domain}" {
            extraConfig = ''

              ${optionalString config.lab.auth rpAuthMixin}

              reverse_proxy localhost:${toString value.inp.port} {
                transport http {
                  tls_insecure_skip_verify
                }
              }
            '';
          })
        config.lab.details);
  };
}
