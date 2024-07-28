{lib, ...}:
with lib; {
  options.my.gui = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable the defaults for a desktop environment. This should not be switched on by default.";
    };
  };
}
