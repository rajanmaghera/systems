# Services

Services for my homelab.

These are customized NixOS modules with configuration for a reverse proxy, hostnames, and a homepage.

## Firefly

To get started with Firefly III, you need to create a Docker network bridge for the containers.

```
docker network create --driver bridge firefly-net
```
