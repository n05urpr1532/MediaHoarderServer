source /opt/mhs/lib/menu/pgvault/autobackup.func
file="/var/plexguide/restore.id"
if [ ! -e "$file" ]; then
  echo "[NOT-SET]" >/var/plexguide/restore.id
fi

backup_all_start
