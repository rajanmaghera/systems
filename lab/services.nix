{
  config,
  options,
  pkgs,
  lib,
  ...
}:
with lib; let
  domain = "${config.lab.system}.${config.lab.tld}";
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

    lab.tld = mkOption {
      type = types.str;
      default = "local";
    };

    lab.auth = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };

      user = mkOption {
        type = types.str;
      };

      password = mkOption {
        type = types.str;
      };

      secretKey = mkOption {
        type = types.str;
      };
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
      wsUrl = mkIf config.lab.register.${name}.ws "wss://${name}.${domain}";
      inp = value;
    })
    config.lab.register);

  # Firewall config
  # Only allow 443, never 80 and never service ports (for now)
  config.networking.firewall.allowedTCPPorts = mkIf config.lab.enable [443];

  # Hosts config
  config.networking.extraHosts = mkIf config.lab.enable ''
    ${strings.concatStringsSep "\n"
      (attrsets.mapAttrsToList (name: value: "127.0.0.1 ${name}.${domain}") config.lab.register)}

    127.0.0.1 ${domain}
    127.0.0.1 auth.${domain}
  '';

  # Reverse proxy configuration
  config.services.caddy = mkIf config.lab.enable {
    enable = true;
    package = mkIf config.lab.auth.enable pkgs.caddy-extended;

    globalConfig = mkIf config.lab.auth.enable ''
      order authenticate before respond
      order authorize before basicauth

         	security {
      	local identity store localdb {
      		realm local
      		path /var/lib/auth/users.json
      	        user ${config.lab.auth.user} {
      	            name Administrator
      	            email ${config.lab.auth.user}@${domain}
      		    password "bcrypt:10:${config.lab.auth.password}" overwrite
      	            roles authp/admin authp/user
      	        }
      	}

      	authentication portal myportal {
      		crypto default token lifetime 3600
      		crypto key sign-verify ${config.lab.auth.secretKey}
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
      		crypto key verify ${config.lab.auth.secretKey}
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
      		crypto key verify ${config.lab.auth.secretKey}
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

          ${optionalString config.lab.auth.enable rpAuthMixin}
        '';

        "auth.${domain}".extraConfig = mkIf config.lab.auth.enable ''
          route {
          	authenticate with myportal
          }
        '';
      }
      // (attrsets.mapAttrs'
        (name: value:
          nameValuePair "${name}.${domain}" {
            extraConfig = ''

              ${optionalString config.lab.auth.enable rpAuthMixin}

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
