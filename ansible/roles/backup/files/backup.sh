#!/usr/bin/env bash
set -euo pipefail
source /etc/restic/restic.env

# Paths to back up. Tune per server.
BACKUP_PATHS=(
  /opt/meridian          # docker compose + volumes metadata
  /var/lib/docker/volumes
  /etc/nginx
  /etc/letsencrypt
)

# Dump PostgreSQL if present (app server)
if command -v pg_dumpall >/dev/null 2>&1; then
  sudo -u postgres pg_dumpall > /var/backups/pg_dumpall.sql
  BACKUP_PATHS+=(/var/backups/pg_dumpall.sql)
fi

restic backup "${BACKUP_PATHS[@]}" --tag daily
# Retention: 7 daily, 4 weekly, 6 monthly
restic forget --prune --keep-daily 7 --keep-weekly 4 --keep-monthly 6
restic check --read-data-subset=5%
echo "Backup completed: $(date -Is)"
