# Deploying to DigitalOcean with Kamal

## 1. Prerequisites

- Docker installed locally
- Kamal installed (gem install kamal)
- DigitalOcean Droplet (Ubuntu 22+)
- DigitalOcean Container Registry
- Dockerfile + `/up` route

## 2. Environment Variables

Create a local .env:

```env
KAMAL_REGISTRY_PASSWORD=<digitalocean-token>
```

Run Kamal with dotenv so these load. (`dotenv kamal <command>`)

## 3. Kamal Config

`config/deploy.yml`:

```yml
service: learn
image: tta-container-registry/learn

servers:
  web:
    - 178.128.70.197

proxy:
  ssl: true
  host: learn.dpi.dev

registry:
  server: registry.digitalocean.com
  username: token
  password:
    - KAMAL_REGISTRY_PASSWORD

env:
  secret:
    - RAILS_MASTER_KEY

aliases:
  console: app exec --interactive --reuse "bin/rails console"
  shell: app exec --interactive --reuse "bash"
  logs: app logs -f
  dbc: app exec --interactive --reuse "bin/rails dbconsole"

volumes:
  - "learn_storage:/rails/storage"

asset_path: /rails/public/assets

builder:
  arch: amd64
```

## 4. First-Time Setup

SSH once to trust the host:

```zsh
ssh root@YOUR_DROPLET_IP
exit
```

Then:

`dotenv kamal setup`

This installs Docker, boots `kamal-proxy`, builds/pushes the image, pulls it onto the server, and starts the app.

## 5. Deploying Updates

`dotenv kamal deploy`

Kamal rebuilds the image, pushes it to the registry, rolls out a zero-downtime update, and verifies the `/up` healthcheck.

## 6. Useful Commands

- `dotenv kamal logs`
- `dotenv kamal ssh`
- `dotenv kamal app reboot`
- `dotenv kamal rollback`
