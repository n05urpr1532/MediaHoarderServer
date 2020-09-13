#!/usr/bin/env bash

### executed parts
uichange() {
  switchcheck=$(cat /var/mhs/state/pgui.switch)
  if [[ "$switchcheck" == "On" ]]; then
    echo "Off" > /var/mhs/state/pgui.switch
    docker stop pgui &> /dev/null &
    docker rm pgui &> /dev/null &
    service localspace stop
    systemctl daemon-reload
    rm -f /etc/systemd/system/localspace.servive
    rm -f /etc/systemd/system/mountcheck.service
    clear
    tee <<- EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅️   WOOT WOOT: Process Complete!
✅️   WOOT WOOT: UI Removed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  else
    echo "On" > /var/mhs/state/pgui.switch
    ansible-playbook /opt/mhs/lib/core/pgui/pgui.yml
    systemctl daemon-reload
    service localspace start
    clear
    tee <<- EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅️   WOOT WOOT: Process Complete!
✅️   WOOT WOOT: UI installed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  fi
}
