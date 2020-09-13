#!/usr/bin/env bash

source /opt/mhs/lib/core/functions/functions.sh
# Menu Interface
question1() {
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📂  System & Network Auditor
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] System & Network Benchmark - Basic
[2] System & Network Benchmark - Advanced

[3] Simple SpeedTest

[Z] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  # Standby
  read -r -p '↘️  Type Number | Press [ENTER]: ' typed < /dev/tty

  case $typed in
    1)
      sudo wget -qO- bench.sh | bash
      echo ""
      read -r -p '🌍 Process Complete | Press [ENTER] ' typed < /dev/tty
      question1
      ;;
    2)
      clear
      echo ""
      curl -LsO git.io/bench.sh
      chmod +x bench.sh && ./bench.sh -a
      echo ""
      read -r -p '🌍 Process Complete | Press [ENTER] ' typed < /dev/tty
      question1
      ;;
    3)
      curl -LsO git.io/bench.sh
      chmod +x bench.sh && ./bench.sh -speed
      echo ""
      read -r -p '🌍 Process Complete | Press [ENTER] ' typed < /dev/tty
      question1
      ;;
    z) exit ;;
    Z) exit ;;
    *) question1 ;;
  esac
}

question1
