{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  domain = "${config.lab.system}.${config.lab.tld}";
in {
  # Caddy security auth setup

  config.services.caddy = mkIf config.lab.auth.enable {
    package = pkgs.caddy-extended;

    globalConfig = ''
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
      		crypto key sign-verify from file ${config.lab.auth.secretKey}
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
      		crypto key verify from file ${config.lab.auth.secretKey}
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
      		crypto key verify from file ${config.lab.auth.secretKey}
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
    virtualHosts."auth.${domain}".extraConfig =
      mkIf config.lab.auth.enable
      ''
        route {
          authenticate with myportal
        }
      '';
  };
}
