{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  authorizedKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG8ZCH5zjDnnRouiFA0QrGuygX8mi4EWGj4nsXwQyKQ+ rajanmaghera@RajansMacBookPro"
  ];
  cfg = config.my.profile;
in {
  config = mkIf cfg.enable {
    users.users."${cfg.user}" = {
      isNormalUser = true;
      description = "${cfg.fullName}";
      extraGroups = ["wheel" "docker"]; # Enable ‘sudo’ for the user.
      packages = with pkgs; [neovim] ++ cfg.packages;
      openssh.authorizedKeys.keys = authorizedKeys;
    };

    system.activationScripts.setProfileImage = mkIf config.my.gui.enable (lib.stringAfter ["var"]
      ''
        mkdir -p /var/lib/AccountsService/{icons,users}
        cp ${config.my.profile.avatar} /var/lib/AccountsService/icons/${config.my.profile.user}
        echo -e "[User]\nIcon=/var/lib/AccountsService/icons/${config.my.profile.user}\n" > /var/lib/AccountsService/users/${config.my.profile.user}
      '');
  };
}
