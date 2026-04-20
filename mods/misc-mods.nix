{
  mods.home.gpu-apps.conf =
    { ... }:
    {
      targets.genericLinux.enable = true;
      targets.genericLinux.gpu.enable = true;
    };

  mods.home.mail.conf =
    {
      pkgs,
      ...
    }:
    {
      home.packages = [
        pkgs.isync
        pkgs.mu
        pkgs.msmtp
      ];
    };

  mods.nixos.headless-rdp-kde.conf =
    {
      ...
    }:
    {
      # Headless XRDP server with KDE
      services.xserver.enable = true;
      services.displayManager.sddm.enable = true;
      services.desktopManager.plasma6.enable = true;
      services.xrdp.enable = true;
      services.xrdp.defaultWindowManager = "startplasma-x11";
      services.xrdp.openFirewall = true;
      services.xrdp.extraConfDirCommands = ''
        substituteInPlace $out/xrdp.ini \
          --replace-fail "port=-1" "port=ask5910"
      '';
    };

  mods.nixos.autologin.conf =
    { ... }:
    {

      services.getty.autologinUser = "rajan";
    };

  mods.nixos.force-cuda-env.conf =
    { pkgs, ... }:
    {
      environment.defaultPackages = [
        pkgs.git
        pkgs.gitRepo
        pkgs.gnupg
        pkgs.autoconf
        pkgs.curl
        pkgs.procps
        pkgs.gnumake
        pkgs.util-linux
        pkgs.m4
        pkgs.gperf
        pkgs.unzip
        pkgs.cudaPackages_13_0.cudatoolkit
        pkgs.linuxPackages.nvidia_x11
        pkgs.libGLU
        pkgs.libGL
        pkgs.freeglut
        pkgs.libxi
        pkgs.libxmu
        pkgs.libxext
        pkgs.libx11
        pkgs.libxv
        pkgs.libxrandr
        pkgs.zlib
        pkgs.ncurses5
        pkgs.stdenv.cc
        pkgs.binutils
      ];

      environment.interactiveShellInit = ''
        export CUDA_PATH=${pkgs.cudaPackages_13_0.cudatoolkit}
        export LD_LIBRARY_PATH=${pkgs.linuxPackages.nvidia_x11}/lib:${pkgs.ncurses5}/lib:${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.zlib}/lib:/run/opengl-driver/lib:$LD_LIBRARY_PATH
        export EXTRA_LDFLAGS="-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib"
        export EXTRA_CCFLAGS="-I/usr/include"
        echo "Loaded CUDA packages"
      '';

      # GPU passthru suport
      #
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.nvidia.open = true;
    };

  mods.home.agent-cli.conf =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.gemini-cli
      ];
    };

  mods.nixos.samba.opts =
    {
      lib,
      ...
    }:
    {
      settings = lib.mkOption {
        type = lib.types.nullOr lib.types.attrs;
        default = null;
      };
    };
  mods.nixos.samba.conf =
    {
      pkgs,
      lib,
      cfg,
      ...
    }:
    {
      # Avahi
      services.avahi = {
        enable = true;
        nssmdns4 = true;
        publish = {
          enable = true;
          addresses = true;
          userServices = true; # Crucial for Samba to register its own mDNS records
        };
        openFirewall = true;
      };

      # Samba
      services.samba = {
        enable = true;
        package = pkgs.samba4Full;
        openFirewall = true;
        settings = lib.mkIf (cfg.settings != null) cfg.settings;
      };
    };

  mods.nixos.immich.conf =
    {
      ...
    }:
    {
      services.immich.enable = true;
      services.immich.openFirewall = true;
      services.immich.machine-learning.enable = false;
      services.immich.host = "0.0.0.0";
      services.immich.port = 2000;
    };

  mods.nixos.home-assistant.conf =
    {
      ...
    }:
    {
      virtualisation.oci-containers = {
        backend = "podman";
        containers.homeassistant = {
          volumes = [ "home-assistant:/config" ];
          environment.TZ = "America/Toronto";
          image = "ghcr.io/home-assistant/home-assistant:stable";
          extraOptions = [
            "--network=host"
          ];
        };
      };
    };
}
