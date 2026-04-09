{
  inputs,
  config,
  ...
}:

let
  outerConfig = config;

  # Defaults are a place where options set to their defaults are likely not to change
  # some of these options might not exist on all OSes.
  defaultOptions =
    { lib, ... }:
    {
      fullName = lib.mkOption {
        type = lib.types.str;
        default = "Rajan Maghera";
        description = "Full name of the main user";
      };

      authorizedKeys = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG8ZCH5zjDnnRouiFA0QrGuygX8mi4EWGj4nsXwQyKQ+ rajanmaghera@RajansMacBookPro"
        ];
        description = "Safe or authorized SSH keys for accessing machines";
      };

      username = lib.mkOption {
        type = lib.types.str;
        description = "User name of the main user";
        default = "rajan";
      };

      timeZone = lib.mkOption {
        type = lib.types.str;
        default = "America/Toronto";
      };

      hostName = lib.mkOption {
        type = lib.types.str;
      };

      homeDirectory = lib.mkOption {
        type = lib.types.str;
      };

      substituters = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "https://cache.nixos.org/"
          "https://k-framework.cachix.org/"
          "https://rajan.cachix.org/"
          "https://nix-community.cachix.org/"
        ];
      };

      enableEfiBootloader = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };

      enableNetwork = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };

      substituterPublicKeys = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "k-framework.cachix.org-1:jeyMXB2h28gpNRjuVkehg+zLj62ma1RnyyopA/20yFE="
          "rajan.cachix.org-1:WdBz6DVZhJafNOoIHXsTfikZTvQHvhUo71+pEi1LqEw="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };

      home = lib.mkOption {
        type = lib.types.attrs;
        default = { };
      };

      definedWorkspaces = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "web"
          "comm"
          "term"
          "editor"
          "scratch"
        ];
      };

      windowManagerKeymaps = lib.mkOption {
        type = lib.types.attrs;
        default = {
          # Movement
          h = "focus --boundaries all-monitors-outer-frame left";
          j = "focus --boundaries all-monitors-outer-frame down";
          k = "focus --boundaries all-monitors-outer-frame up";
          l = "focus --boundaries all-monitors-outer-frame right";

          period = "workspace next";
          comma = "workspace prev";

          # Layout Modifications
          semicolon = "layout tiles accordion";
          quote = "layout tiles accordion";

          slash = "layout horizontal vertical";

          minus = "resize smart -50";
          equal = "resize smart +50";
          shift-minus = "resize smart -80";
          shift-equal = "resize smart +80";

          shift-b = "balance-sizes";
          shift-r = "flatten-workspace-tree";
          shift-f = "layout floating tiling";

          # Within workspaces movement modifications
          shift-h = "move --boundaries all-monitors-outer-frame left";
          shift-j = "move --boundaries all-monitors-outer-frame down";
          shift-k = "move --boundaries all-monitors-outer-frame up";
          shift-l = "move --boundaries all-monitors-outer-frame right";

          shift-period = "move-node-to-workspace --focus-follows-window next";
          shift-comma = "move-node-to-workspace --focus-follows-window prev";

          ctrl-period = "move-workspace-to-monitor --wrap-around next";
          ctrl-comma = "move-workspace-to-monitor --wrap-around prev";

          # join
          ctrl-h = "join-with left";
          ctrl-j = "join-with down";
          ctrl-k = "join-with up";
          ctrl-l = "join-with right";
        };
      };
    };

in
{
  mods.nixos.defaults.opts = defaultOptions;
  mods.nixos.defaults.conf =
    {
      cfg,
      ...
    }:
    {

      # System config
      i18n.defaultLocale = "en_CA.UTF-8";
      system.stateVersion = "25.11";
      boot.loader.systemd-boot.enable = cfg.enableEfiBootloader;
      boot.loader.efi.canTouchEfiVariables = cfg.enableEfiBootloader;
      networking.networkmanager.enable = cfg.enableNetwork;
      time.timeZone = cfg.timeZone;
      networking.hostName = cfg.hostName;

      # Nix settings
      nix.settings.extra-trusted-users = [ cfg.username ];
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
      nix.settings.substituters = cfg.substituters;
      nix.settings.trusted-public-keys = cfg.substituterPublicKeys;

      # Home manager config
      home-manager.backupFileExtension = "bkup";
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users."${cfg.username}" = cfg.home;
      home-manager.sharedModules = outerConfig.baseMods.home ++ [
        # implicitly make options read only by forcing the config here
        {
          my.defaults = cfg;
        }
      ];

      # User config
      users.mutableUsers = false;
      users.users."${cfg.username}" = {
        isNormalUser = true;
        description = "${cfg.fullName}";
        extraGroups = [
          "wheel"
        ];
        openssh.authorizedKeys.keys = cfg.authorizedKeys;
        hashedPassword = "$y$j9T$ZExjOzZDUxf2s3YyvlCjV/$kfg.uVxpdA/eJwtxQfOcoflyj0aTVUrhTZyzJhm4gw8";
      };

      services.openssh.settings.AllowUsers = [ cfg.username ];

    };

  mods.darwin.defaults.opts = defaultOptions;
  mods.darwin.defaults.conf =
    {
      pkgs,
      cfg,
      ...
    }:
    {
      # System config
      system.primaryUser = cfg.username;
      system.stateVersion = 6;
      time.timeZone = cfg.timeZone;
      networking.hostName = cfg.hostName;
      ids.gids.nixbld = 350;

      # Nix
      nixpkgs.hostPlatform = pkgs.stdenv.hostPlatform.system;
      nix.settings.extra-trusted-users = [ cfg.username ];
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
      nix.settings.substituters = cfg.substituters;
      nix.settings.trusted-public-keys = cfg.substituterPublicKeys;

      # User config
      users.users."${cfg.username}" = {
        home = cfg.homeDirectory;
        shell = pkgs.zsh;
      };

      # Home manager
      home-manager.backupFileExtension = "bkup";
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users."${cfg.username}" = cfg.home;
      home-manager.sharedModules = outerConfig.baseMods.home ++ [
        # implicitly make options read only by forcing the config here
        {
          my.defaults = cfg;
        }
      ];
    };

  mods.home.defaults.opts = defaultOptions;
  mods.home.defaults.conf =
    {
      cfg,
      ...
    }:
    {
      home.stateVersion = "25.11";
      home.username = cfg.username;
      home.homeDirectory = cfg.homeDirectory;

      xdg.enable = true;

      # Add this flake to the local registry as 's'
      # (so it's never lost)
      nix.registry.s.flake = inputs.self;
      # To run any package (default or customized), use `nix run s#...`
    };
}
