[
  {
    name = "lab-key";
    description = "Homelab/services caddy authentication secret key";
  }
  {
    name = "nginx-selfsigned-key";
    description = "Self-signed certificate key for nginx";
    extraAttrs = {
      mode = "770";
      owner = "nginx";
      group = "nginx";
    };
  }
]
