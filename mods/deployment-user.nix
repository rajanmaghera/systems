{

  # Enable remote deployment user
  mods.nixos.my.deployment-user =
    { config, ... }:
    {
      users.users.deploy = {
        isNormalUser = true;
        description = "Remote deployment user";
        uid = 2000;
        openssh.authorizedKeys.keys = config.my.defaults.authorizedKeys;
      };

      services.openssh.enable = true;
      services.openssh.settings.AllowUsers = [ "deploy" ];

      # Allow ssh to authenticate sudo
      security.pam.sshAgentAuth.enable = true;
      security.pam.services.sudo.enable = true;
      security.pam.services.sudo.sshAgentAuth = true;

      nix.settings.trusted-users = [ "deploy" ];

      # Restrict sudo to deployment commands only
      security.sudo.extraRules = [
        {
          users = [ "deploy" ];
          commands = [
            { command = "/nix/store/*-activatable-nixos-system-*/activate-rs"; }
            { command = "/run/current-system/sw/bin/rm /tmp/deploy-rs-canary-*"; }
          ];
        }
      ];

      # TODO: add switch to not enable sshAgentAuth for all users
    };

  # aarch64 fix for pam not working
  # https://github.com/NixOS/nixpkgs/issues/386392#issuecomment-4077258961
  pkgs.overlays = [
    (final: prev: {
      pam_ssh_agent_auth = prev.pam_ssh_agent_auth.overrideAttrs (old: {
        postFixup = (old.postFixup or "") + ''
          ${prev.patchelf}/bin/patchelf \
            --add-needed libgcc_s.so.1 \
            --add-rpath ${prev.stdenv.cc.cc.lib}/lib \
            $out/libexec/pam_ssh_agent_auth.so
        '';
      });
    })
  ];
}
