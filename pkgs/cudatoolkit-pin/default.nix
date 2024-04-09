f: p: {
  cudatoolkit-pin = p.cudaPackages.cudatoolkit.overrideAttrs (oldAttrs: {
    version = "12.4.1";
    src = p.fetchurl {
      url = "https://developer.download.nvidia.com/compute/cuda/12.4.1/local_installers/cuda_12.4.1_550.54.15_linux.run";
      sha256 = "sha256-Nn0imbOkWIq0h6bScnbKXZ6tbjlJBPGLzLnhJDO5xPs=";
    };
  });
}
