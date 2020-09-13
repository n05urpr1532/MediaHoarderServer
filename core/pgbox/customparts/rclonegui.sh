#!/usr/bin/env bash
####rcwebui.sh
start0() {
  folder && rcwebui
}

folder() {
  if [[ ! -e "/var/mhs/state/rcwebui" ]]; then
    remove
  else create; fi
}

remove() {
  rm -rf /var/mhs/state/rcwebui
  mkdir -p /var/mhs/state/rcwebui
  echo "NOT-SET" > /var/mhs/state/rcwebui/rcuser.user
  echo "NOT-SET" > /var/mhs/state/rcwebui/rcpass.pass
}
create() {
  mkdir -p /var/mhs/state/rcwebui
  echo "NOT-SET" > /var/mhs/state/rcwebui/rcuser.user
  echo "NOT-SET" > /var/mhs/state/rcwebui/rcpass.pass
}

rcwebui() {
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📁 rclone Webui username and password
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

In order of work :
Usernanme : $(cat /var/mhs/state/traktarr/pgtrak.client)
Password  : $(cat /var/mhs/state/rcwebui/rcpass.pass)

Go Back? Type > exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  read -p '↘️ Type Username | Press [ENTER]: ' typed < /dev/tty
  echo $typed > /var/mhs/state/rcwebui/rcuser.user
  read -p '↘️ Type Password | Press [ENTER]: ' typed < /dev/tty
  echo $typed > /var/mhs/state/rcwebui/rcpass.pass
  if [[ "$typed" == "exit" || "$typed" == "Exit" || "$typed" == "EXIT" || "$typed" == "z" || "$typed" == "Z" ]]; then
    exit 0
  else
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ SYSTEM MESSAGE: rclone webui username and password is set
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Usernanme : $(cat /var/mhs/state/rcwebui/rcuser.user)
Password  : $(cat /var/mhs/state/rcwebui/rcpass.pass)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
    read -p '🌎 Acknowledge Info | Press [ENTER] ' typed < /dev/tty
  fi
}

start0
