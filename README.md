# MeridianData VPS Provisioning (OVHcloud EU + Hetzner backup)

Reproducible, EU-only provisioning for a software-escrow SaaS foundation: two
OVHcloud VPS plus a Hetzner backup target. Everything is Infrastructure-as-Code
(Ansible), so the build is repeatable, reviewable, and recoverable. No US-hosted
services are used anywhere in this stack.

> This is a reference implementation demonstrating my approach. On engagement I
> tailor the variables, secrets (Ansible Vault), and per-service config to your
> exact subdomains and deploy it to your servers.

## What this provisions

**Server 1 — Application (Ubuntu 22.04)**
- Nginx reverse proxy + Let's Encrypt SSL (auto-renew)
- Node.js 20.x, PostgreSQL 16 (self-hosted), PM2 for Next.js

**Server 2 — Services (Ubuntu 22.04, Docker)**
- Nextcloud, Hanko, n8n, Zammad, Bugsink, Matomo — each on its own subdomain,
  all behind Nginx with SSL, bound to localhost only

**Hetzner (Germany) — Backups**
- Daily encrypted Restic backups over SFTP, retention policy, automated prune
- Tested restore procedure (see `docs/RESTORE.md`)

**Security baseline (all servers)**
- UFW: only 80/443 + SSH from specified IPs
- SSH key-only, root login disabled, fail2ban, unattended security upgrades

## Layout
```
ansible/
  site.yml                 # master playbook
  inventory.example.ini    # copy to inventory.ini, add real IPs
  group_vars/              # subdomain -> service port mapping
  roles/
    common/                # hardening: users, SSH, UFW, fail2ban, auto-updates
    nginx/                 # reverse proxy + certbot per site
    appserver/             # Node 20, PostgreSQL 16, PM2
    docker/                # Docker Engine + compose stack
    backup/                # Restic to Hetzner + cron + retention
compose/
  docker-compose.services.yml  # the 7 self-hosted services
docs/
  HANDOVER.md              # client handover template
  RESTORE.md               # tested restore runbook
```

## Usage
```bash
ansible-galaxy collection install -r ansible/requirements.yml
cp ansible/inventory.example.ini ansible/inventory.ini   # add real IPs
# put secrets in group_vars/*/vault.yml via: ansible-vault create ...
ansible-playbook -i ansible/inventory.ini ansible/site.yml
```

## Secrets
No credentials live in this repo. DB passwords, the Restic password, and service
secrets are supplied via Ansible Vault and a gitignored `.env`. See `compose/.env.example`.

---
Built by Enoch Ayivor — Cloud & DevOps Engineer. Azure (AZ-104), Terraform Associate,
CKA in progress.
