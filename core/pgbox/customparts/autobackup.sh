#!/usr/bin/env bash

# FUNCTIONS START ##############################################################
source /opt/mhs/lib/core/functions/functions.sh

queued() {
  echo
  read -p "⛔️ ERROR - $typed Already Queued! | Press [ENTER] " typed < /dev/tty
  appselect
}

badinput() {
  echo ""
  echo "⛔️ ERROR - Bad Input! $typed not exist"
  echo ""
  read -p 'PRESS [ENTER] ' typed < /dev/tty
}

startup() {
  rm -rf /var/mhs/state/pgupdater.output 1> /dev/null 2>&1
  rm -rf /var/mhs/state/pgbox.buildup 1> /dev/null 2>&1
  rm -rf /var/mhs/state/program.temp 1> /dev/null 2>&1
  rm -rf /var/mhs/state/app.list 1> /dev/null 2>&1
  touch /var/mhs/state/pgupdater.output
  touch /var/mhs/state/program.temp
  touch /var/mhs/state/app.list
  touch /var/mhs/state/pgbox.buildup

  docker ps | awk '{print $NF}' | tail -n +2 > /var/mhs/state/pgbox.running
  docker ps | awk '{print $NF}' | tail -n +2 > /var/mhs/state/app.list
}

autoupdateall() {
  cp /var/mhs/state/program.temp /var/mhs/state/pgupdater.output
  appselect
}

appselect() {

  #  docker ps | awk '{print $NF}' | tail -n +2 >/var/mhs/state/pgbox.running
  #  docker ps | awk '{print $NF}' | tail -n +2 >/var/mhs/state/app.list

  ### Clear out temp list
  rm -rf /var/mhs/state/program.temp && touch /var/mhs/state/program.temp

  ### List out installed apps
  num=0
  tree -d -L 1 /opt/mhs/apps-data | awk '{print $2}' | tail -n +2 | head -n -2 > /var/mhs/state/app.list

  sed -i -e "/mhs/d" /var/mhs/state/app.list
  sed -i -e "/oauth/d" /var/mhs/state/app.list
  sed -i -e "/traefik/d" /var/mhs/state/app.list
  sed -i -e "/wp-*/d" /var/mhs/state/app.list
  sed -i -e "/*-vpn/d" /var/mhs/state/app.list

  p="/var/mhs/state/pgbox.running"
  while read p; do
    echo -n $p >> /var/mhs/state/program.temp
    echo -n " " >> /var/mhs/state/program.temp
    num=$((num + 1))
    if [[ "$num" == "7" ]]; then
      num=0
      echo " " >> /var/mhs/state/program.temp
    fi
  done < /var/mhs/state/app.list

  notrun=$(cat /var/mhs/state/program.temp)
  buildup=$(cat /var/mhs/state/pgupdater.output)

  if [ "$buildup" == "" ]; then buildup="NONE"; fi
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Multi-App Auto Updater
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📂 Potential Apps to Auto Update

$notrun

💾 Apps Queued for Auto Updating

$buildup

[A] Install

[Z] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -p '↪️ Type App Name to Queue Auto Updating | Type ALL to select all | Press [ENTER]: ' typed < /dev/tty

  if [[ "$typed" == "deploy" || "$typed" == "Deploy" || "$typed" == "DEPLOY" || "$typed" == "install" || "$typed" == "Install" || "$typed" == "INSTALL" || "$typed" == "a" || "$typed" == "A" ]]; then question2; fi

  if [[ "$typed" == "exit" || "$typed" == "Exit" || "$typed" == "EXIT" || "$typed" == "z" || "$typed" == "Z" ]]; then exit; fi

  current=$(cat /var/mhs/state/pgbox.buildup | grep "\<$typed\>")
  if [ "$current" != "" ]; then queued && appselect; fi

  if [[ "$typed" == "all" || "$typed" == "All" || "$typed" == "ALL" ]]; then
    :
  else
    current=$(cat /var/mhs/state/program.temp | grep "\<$typed\>")
    if [ "$current" == "" ]; then badinput && appselect; fi
  fi

  queueapp
}

queueapp() {
  if [[ "$typed" == "all" || "$typed" == "All" || "$typed" == "ALL" ]]; then autoupdateall; else echo "$typed" >> /var/mhs/state/pgbox.buildup; fi

  num=0

  touch /var/mhs/state/pgupdater.output && rm -rf /var/mhs/state/pgupdater.output && touch /var/mhs/state/pgupdater.output

  while read p; do
    echo -n $p >> /var/mhs/state/pgupdater.output
    echo -n " " >> /var/mhs/state/pgupdater.output
    num=$((num + 1))
    if [[ "$num" == 7 ]]; then
      num=0
      echo " " >> /var/mhs/state/pgupdater.output
    fi
  done < /var/mhs/state/pgbox.buildup

  sed -i "/^$typed\b/Id" /var/mhs/state/app.list

  appselect
}

complete() {
  read -p '✅ Process Complete! | PRESS [ENTER] ' typed < /dev/tty
  echo
  exit
}

question2() {
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Rebuilding Ouroboros!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  ansible-playbook /opt/mhs/lib/core/functions/ouroboros.yml
  complete
}

start() {
  startup
  appselect
}

# FUNCTIONS END ##############################################################
echo "" > /tmp/output.info
start
