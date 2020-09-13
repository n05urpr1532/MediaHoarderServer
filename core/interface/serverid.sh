#!/usr/bin/env bash

touch /var/mhs/state/server.id.stored
source /opt/mhs/lib/core/functions/functions.sh
start=$(cat /var/mhs/state/server.id)
stored=$(cat /var/mhs/state/server.id.stored)

serverid() {
  local root_dir="/var/mhs/state"

  if [[ "$start" != "$stored" ]]; then

    tee <<- EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
↘️   Establishing New Server ID    💬  Use One Word & Keep it Simple
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
    read -r -p '🌏  TYPE Server ID | Press [ENTER]: ' typed < /dev/tty

    if [[ "$typed" == "" ]]; then
      tee <<- EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  WARNING! - The Server ID Cannot Be Blank!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
      sleep 3
      serverid
      exit
    else
      tee <<- EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅️  PASS: New ServerID Set
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

      # Prevents From Repeating
      echo "$typed" > ${root_dir}/server.id
      cat ${root_dir}/server.id > ${root_dir}/server.id.stored
      start=$(cat /var/mhs/state/server.id)
      serveridcreate=$(tree -d -L 1 /mnt/gdrive/mhs/backup | awk '{print $2}' | tail -n +2 | head -n -2 | grep "$(cat /var/mhs/state/server.id)")
      if [[ $start != $serveridcreate ]]; then
        rclone mkdir gdrive:/mhs/backup/$(cat /var/mhs/state/server.id) --config /opt/mhs/etc/rclone/rclone.conf
      fi
      sleep 3
    fi

  fi
}
####
serverid
