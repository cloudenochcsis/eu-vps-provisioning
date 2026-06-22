# Restore Procedure (tested)

The brief requires a **tested restore procedure**. This documents how to recover
either server from the Hetzner Restic repository.

## 1. List available snapshots
```bash
source /etc/restic/restic.env
restic snapshots
```

## 2. Restore latest snapshot to a staging path
```bash
restic restore latest --target /tmp/restore
```

## 3. Restore PostgreSQL (app server)
```bash
sudo -u postgres psql < /tmp/restore/var/backups/pg_dumpall.sql
```

## 4. Restore Docker volumes (services server)
```bash
systemctl stop docker
rsync -a /tmp/restore/var/lib/docker/volumes/ /var/lib/docker/volumes/
systemctl start docker
cd /opt/meridian && docker compose up -d
```

## 5. Restore Nginx + certs
```bash
rsync -a /tmp/restore/etc/nginx/ /etc/nginx/
rsync -a /tmp/restore/etc/letsencrypt/ /etc/letsencrypt/
nginx -t && systemctl reload nginx
```

## Verification checklist (run after every restore drill)
- [ ] All 7 service subdomains return HTTP 200 over HTTPS
- [ ] PostgreSQL row counts match pre-restore baseline
- [ ] A test file uploaded to Nextcloud before backup is present
- [ ] Restic `check` passes with no errors

**Last restore drill:** _record date + result here after each test._
