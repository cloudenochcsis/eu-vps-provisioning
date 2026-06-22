# MeridianData — Infrastructure Handover

> Fill in real values at deployment. **Do not commit completed copies to Git.**
> Deliver this document to the client via a secure channel (e.g. password manager share).

## Server inventory
| Role | Provider | Location | IP | OS |
|------|----------|----------|----|----|
| Application | OVHcloud | EU | `___` | Ubuntu 22.04 LTS |
| Services | OVHcloud | EU | `___` | Ubuntu 22.04 LTS |
| Backup | Hetzner | Germany | `___` | Ubuntu 22.04 LTS |

## Application server (Server 1)
- Nginx reverse proxy + Let's Encrypt SSL (auto-renew via certbot timer)
- Node.js 20.x, PM2 (boot-persistent) for the Next.js app
- PostgreSQL 16, database `meridian_app`, user `meridian`
- App served at: `https://app.<domain>`

## Services server (Server 2) — all behind Nginx + SSL
| Service | Subdomain | Local port | Admin notes |
|---------|-----------|-----------|-------------|
| Nextcloud | files.<domain> | 8080 | Encrypted storage enabled |
| Hanko | auth.<domain> | 8000 | Passkey/auth |
| n8n | automation.<domain> | 5678 | Workflow automation |
| Zammad | help.<domain> | 8081 | Helpdesk |
| Bugsink | errors.<domain> | 8082 | Error tracking |
| Matomo | analytics.<domain> | 8083 | Analytics |

## Security
- UFW: inbound limited to 80, 443, and SSH from `___` (client-specified IPs)
- SSH: key-only, root login disabled, fail2ban active
- Unattended security upgrades enabled

## Backups
- Restic (encrypted) daily at 02:30 to Hetzner over SFTP
- Retention: 7 daily / 4 weekly / 6 monthly
- Restore procedure: see RESTORE.md (drill completed on `___`)

## Credentials
Stored in: `___` (e.g. client's password manager vault). Not included in this file.
