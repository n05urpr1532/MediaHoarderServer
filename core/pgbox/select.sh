#!/usr/bin/env bash

GCEtest() {
  gce=$(cat /var/mhs/state/pg.server.deploy)

  if [[ $gce == "feeder" ]]; then
    mainstart2
  else mainstart1; fi
}

mainstart1() {
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Box Apps Interface Selection
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💬  MHS Box installs a series of Core and Community applications!

[1] MHS          : Core
[2] MHS          : Community
--------------------------------
[3] Apps         : Personal Forks
[4] Apps         : Removal
[5] Apps         : Auto Update

[Z] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  # Standby
  read -r -p '↘️  Type Number | Press [ENTER]: ' typed < /dev/tty

  case $typed in
    1) bash /opt/mhs/lib/core/pgbox/core/core.sh ;;
    2) bash /opt/mhs/lib/core/pgbox/community/community.sh ;;
    3) bash /opt/mhs/lib/core/pgbox/personal/personal.sh ;;
    4) bash /opt/mhs/lib/core/pgbox/remove/removal.sh ;;
    5) bash /opt/mhs/lib/core/pgbox/customparts/autobackup.sh ;;
    z) exit ;;
    Z) exit ;;
    *) GCEtest ;;
  esac
}

mainstart2() {
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 GCE APPS optimized Apps
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] MHS GCE optimized Apps : GCE APPS

[2] Apps                   : Removal

[Z] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  read -r -p '↘️  Type Number | Press [ENTER]: ' typed < /dev/tty

  case $typed in
    1) bash /opt/mhs/lib/core/pgbox/gce/gcecore.sh ;;
    2) bash /opt/mhs/lib/core/pgbox/remove/removal.sh ;;
    z) exit ;;
    Z) exit ;;
    *) GCEtest ;;
  esac
}

GCEtest
