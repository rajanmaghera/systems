{

  sys.souragent.system = "x86_64-linux";
  sys.souragent.class = "nixos";
  # TODO: eliminate below
  pkgs.allUnfree = true;

  sys.souragent.mod =
    {
      ...
    }:
    {
      my.defaults.enable = true;
      my.defaults.homeDirectory = "/home/rajan";
      my.defaults.hostName = "souragent";

      my.gc.enable = true;
      my.deployment-user.enable = true;

      my.headless-rdp-kde.enable = true;
      my.shell.enable = true;
      my.autologin.enable = true;

      my.defaults.authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG8ZCH5zjDnnRouiFA0QrGuygX8mi4EWGj4nsXwQyKQ+ rajanmaghera@RajansMacBookPro"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC9y0BMvduJSoIIQ+bTixWSkdDD3/nt01jTtBXBeDbqf rajan@rajan-precision"
      ];

      my.defaults.home = {
        my.gc.enable = true;
        my.cli.enable = true;
        my.dev-env.enable = true;
        my.shell.enable = true;
        my.passwords.enable = true;
        my.theming.enable = true;
        my.agent-cli.enable = true;
      };
      my.force-cuda-env.enable = true;
    };

}
