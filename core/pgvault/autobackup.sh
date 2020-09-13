#!/usr/bin/env bash
source /opt/mhs/lib/core/pgvault/autobackup.func
file="/var/mhs/state/restore.id"
if [ ! -e "$file" ]; then
  echo "[NOT-SET]" > /var/mhs/state/restore.id
fi

backup_all_start
