#!/usr/bin/env bash

source /opt/mhs/lib/backup-and-restore/functions.sh
source /opt/mhs/lib/backup-and-restore/pgvault.func
file="/var/mhs/state/restore.id"
if [ ! -e "$file" ]; then
  echo "[NOT-SET]" > /var/mhs/state/restore.id
fi

initial
apprecall
primaryinterface
