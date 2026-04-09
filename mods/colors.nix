{
  mods.home.theming.opts =
    {
      lib,
      config,
      pkgs,
      cfg,
      ...
    }:
    {
      base16LightScheme = lib.mkOption {
        type = lib.types.str;
        default = "${pkgs.base16-schemes}/share/themes/cupertino.yaml";
      };

      base16DarkScheme = lib.mkOption {
        type = lib.types.str;
        default = "${pkgs.base16-schemes}/share/themes/atelier-dune.yaml";
      };

      base16LightColors = lib.mkOption {
        type = lib.types.anything;
        default = config.lib.base16.mkSchemeAttrs cfg.base16LightScheme;
      };

      base16DarkColors = lib.mkOption {
        type = lib.types.anything;
        default = config.lib.base16.mkSchemeAttrs cfg.base16DarkScheme;
      };

      fontFamily = lib.mkOption {
        type = lib.types.str;
        default = "Fragment Mono";
      };
    };

  mods.home.theming.conf =
    {
      cfg,
      pkgs,
      ...
    }:
    {
      # Enable font config
      fonts.fontconfig.enable = true;
      home.packages = [
        pkgs.nerd-fonts.fira-code
        pkgs.nerd-fonts.cousine
        pkgs.nerd-fonts.iosevka
        pkgs.nerd-fonts.jetbrains-mono
        pkgs.nerd-fonts.geist-mono
        pkgs.nerd-fonts.im-writing
        pkgs.fragment-mono
      ];

      # Zsh home
      programs.zsh.oh-my-zsh.theme = "gentoo";

      # Zellij
      programs.zellij.settings.theme = "ansi";

      # Helix
      programs.helix.settings.theme = "base16_terminal";

      # Ghostty
      programs.ghostty =
        let
          makeTheme = colors: {
            background = colors.base00;
            foreground = colors.base05;
            cursor-color = colors.base05;
            selection-background = colors.base02;
            selection-foreground = colors.base05;

            palette = with colors.withHashtag; [
              "0=${base00}"
              "1=${base08}"
              "2=${base0B}"
              "3=${base0A}"
              "4=${base0D}"
              "5=${base0E}"
              "6=${base0C}"
              "7=${base05}"
              "8=${base03}"
              "9=${base08}"
              "10=${base0B}"
              "11=${base0A}"
              "12=${base0D}"
              "13=${base0E}"
              "14=${base0C}"
              "15=${base07}"
            ];
          };
        in
        {
          themes.my-light = makeTheme cfg.base16LightColors;
          themes.my-dark = makeTheme cfg.base16DarkColors;
          settings = {
            font-family = cfg.fontFamily;
            theme = "light:my-light,dark:my-dark";
          };
        };
    };

}
