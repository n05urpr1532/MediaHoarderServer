#!/usr/bin/env bash

# KEY VARIABLE RECALL & EXECUTION
program=$(cat /tmp/program_var)
mkdir -p /var/mhs/state/cron/
mkdir -p /opt/mhs/etc/mhs/cron
# FUNCTIONS START ##############################################################

# BAD INPUT
badinput() {
  echo
  read -r -p '⛔️ ERROR - BAD INPUT! | PRESS [ENTER] ' typed < /dev/tty

}

# FIRST QUESTION
question1() {
  ports=$(cat /var/mhs/state/server.ports)
  if [ "$ports" == "127.0.0.1:" ]; then
    guard="CLOSED" && opp="Open"
  else guard="OPEN" && opp="Close"; fi
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🤖 Welcome to PortGuard!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Ports Are Currently: [$guard]

[ 1 ] $opp Ports

[ Z ] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  read -r -p '↘️  Type Number | Press [ENTER]: ' typed < /dev/tty

  case $typed in
    1)
      if [ "$guard" == "CLOSED" ]; then
        echo "" > /var/mhs/state/server.ports
      else echo "127.0.0.1:" > /var/mhs/state/server.ports; fi
      bash /opt/mhs/lib/core/portguard/rebuild.sh
      question1
      ;;
    z)
      exit
      ;;
    Z)
      exit
      ;;
    *)
      question1
      ;;
  esac
}

# FUNCTIONS END ##############################################################

break=off && while [ "$break" == "off" ]; do question1; done
