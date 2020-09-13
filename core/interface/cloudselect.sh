#!/usr/bin/env bash

# Menu Interface
question1() {
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📂  Cloud Service Installer
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[ 1 ] Cloud Instance: Google   [ Blitz ~ GCE Edition ]
[ 2 ] Cloud Instance: Hetzner

[ Z ] - Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  read -p '↘️  Type Number | Press [ENTER]: ' typed < /dev/tty

  case $typed in

    1) bash /opt/mhs/lib/core/gce/blitzgce.sh ;;
    2) bash /opt/mhs/lib/core/hcloud/hcloud.sh ;;
    z) exit ;;
    Z) exit ;;
    *) question1 ;;
  esac
}
##### layout build

question1
