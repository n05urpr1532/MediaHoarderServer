#!/usr/bin/env bash

source /opt/mhs/lib/core/functions/functions.sh

emergency() {
  local root_dir="/var/mhs/state"
  mkdir -p /var/mhs/state/emergency
  variable ${root_dir}/emergency.display "On"
  if [[ $(ls /var/mhs/state/emergency) != "" ]]; then

    # If not on, do not display emergency logs
    if [[ $(cat /var/mhs/state/emergency.display) == "On" ]]; then

      tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  Emergency & Warning Log Generator
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
NOTE: This can be turned [On] or Off in Settings!

EOF

      countmessage=0
      while read p; do
        let countmessage++
        echo -n "${countmessage}. " && cat /var/mhs/state/emergency/$p
      done <<< "$(ls /var/mhs/state/emergency)"

      echo
      read -n 1 -s -r -p "Acknowledge Info | Press [ENTER]"
      echo
    else
      touch ${root_dir}/emergency.log
    fi
  fi
}
