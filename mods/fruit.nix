{
  sys.fruit.system = "aarch64-darwin";
  sys.fruit.class = "darwin";
  sys.fruit.mod = {
    my.defaults.enable = true;
    my.defaults.username = "rajan";
    my.defaults.homeDirectory = "/Users/rajan";
    my.defaults.hostName = "fruit";

    # Enable custom window management
    my.security.pam.enable = true;
    my.aerospace.enable = true;
    my.gc.enable = true;

    my.home = {
      my.emacs = true;
      my.gc.enable = true;
      my.cli.enable = true;
      my.dev-env.enable = true;
      my.shell.zsh.enable = true;
      my.passwords.enable = true;
    };
  };
}
