#!/usr/bin/env bash

nvidia() {
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📂  System & Network Auditor
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] Install NVIDIA Docker role

[Z] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -p '↘️  Type Number | Press [ENTER]: ' typed < /dev/tty

  case $typed in
    1) ansible-playbook /opt/mhs/lib/core/mhs.yml --tags nvidia ;;
    z) exit && setstart ;;
    Z) exit && setstart ;;
    *) setstart ;;
  esac
}
