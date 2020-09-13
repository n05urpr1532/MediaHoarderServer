#!/usr/bin/env bash

rm -rf /var/mhs/state/ver.temp 1> /dev/null 2>&1
touch /var/mhs/state/ver.temp

sleep 4
## Builds Version List for Display
while read p; do
  echo $p >> /var/mhs/state/ver.temp
done < /opt/mhs/lib/VERSION

tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📂  Update Interface Menu
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

cat /var/mhs/state/ver.temp
echo ""
echo "[Z] Exit"
echo ""
break=no
while [ "$break" == "no" ]; do
  read -p '↘️  Type | PRESS ENTER: ' typed
  storage=$(grep $typed /var/mhs/state/ver.temp)

  if [[ "$typed" == "exit" || "$typed" == "Exit" || "$typed" == "EXIT" || "$typed" == "z" || "$typed" == "Z" ]]; then
    echo ""
    touch /var/mhs/state/exited.upgrade
    exit
  fi

  if [ "$storage" != "" ]; then
    break=yes
    echo $storage > /var/mhs/state/pg.number
    ansible-playbook /opt/mhs/lib/core/interface/version/choice.yml

    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅️  SYSTEM MESSAGE: Installed Verison - $storage - Standby!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
    sleep 4
  else
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  SYSTEM MESSAGE: Version $storage does not exist! - Standby!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
    sleep 4
    cat /var/mhs/state/ver.temp
    echo ""
  fi

done
