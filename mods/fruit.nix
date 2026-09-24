{
  sys.fruit.system = "aarch64-darwin";
  sys.fruit.class = "darwin";
  sys.fruit.mod = {
    my.defaults.enable = true;
    my.defaults.username = "rajan";
    my.defaults.hostName = "fruit";

    # Enable custom window management
    my.pam.enable = true;
    my.aerospace.enable = true;
    my.gc.enable = true;
    my.linux-builder.enable = true;

    my.defaults.home = {
      my.theming.enable = true;
      my.shell.enable = true;
      my.gc.enable = true;
      my.dev-env.enable = true;
      my.nix-tools.enable = true;
      my.mail.enable = true;

      services.syncthing = {
        enable = true;
      };
    };
  };
}
