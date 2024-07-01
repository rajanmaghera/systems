# Secret management

Use the flake `agenix` to generate secrets, if not installed.

```
nix run github:ryantm/agenix -- --help
```

To add a new secret, add a line entry to the file `manifest.nix`. Then, run

```
agenix -e <SECRET.NAME>.age
```

The secret can be obtained from any configuration (Home Manage, Darwin, NixOS) via the attribute `config.age.secrets.<SECRET.NAME>.path`;
