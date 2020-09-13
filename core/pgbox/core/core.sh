#!/usr/bin/env bash


# FUNCTIONS START ##############################################################
source /opt/mhs/lib/core/functions/functions.sh

queued() {
  echo
  read -p "⛔️ ERROR - $typed Already Queued! | Press [ENTER] " typed < /dev/tty
  question1
}

value() {
  bash /opt/mhs/lib/core/pgbox/value.sh
}

exists() {
  echo ""
  echo "⛔️ ERROR - $typed Already Installed!"
  read -p '⚠️  Reinstall? [Y/N] | Press [ENTER] ' foo < /dev/tty

  if [[ "$foo" == "y" || "$foo" == "Y" ]]; then
    part1
  elif [[ "$foo" == "n" || "$foo" == "N" ]]; then
    question1
  else exists; fi
}

badinputcore() {
  echo ""
  echo "⛔️ ERROR - Bad Input! $typed not exist"
  echo ""
  read -p 'PRESS [ENTER] ' typed < /dev/tty
}

cronexe() {
  croncheck=$(cat /opt/mhs/lib/apps-core/_cron.list | grep -c "\<$p\>")
  if [ "$croncheck" == "0" ]; then bash /opt/mhs/lib/core/cron/cron.sh; fi
}

cronmass() {
  croncheck=$(cat /opt/mhs/lib/apps-core/_cron.list | grep -c "\<$p\>")
  if [ "$croncheck" == "0" ]; then bash /opt/mhs/lib/core/cron/cron.sh; fi
}

initial() {
  rm -rf /var/mhs/state/pgbox.output 1> /dev/null 2>&1
  rm -rf /var/mhs/state/pgbox.buildup 1> /dev/null 2>&1
  rm -rf /var/mhs/state/program.temp 1> /dev/null 2>&1
  rm -rf /var/mhs/state/app.list 1> /dev/null 2>&1
  touch /var/mhs/state/pgbox.output
  touch /var/mhs/state/program.temp
  touch /var/mhs/state/app.list
  touch /var/mhs/state/pgbox.buildup

  folder && ansible-playbook /opt/mhs/lib/core/pgbox/core/core.yml > /dev/null 2>&1

  apt-get install dos2unix -yqq
  dos2unix /opt/mhs/lib/apps-core/image/_image.sh > /dev/null 2>&1
  dos2unix /opt/mhs/lib/apps-core/_appsgen.sh > /dev/null 2>&1
}

question1() {

  ### Remove Running Apps
  while read p; do
    sed -i "/^$p\b/Id" /var/mhs/state/app.list
  done < /var/mhs/state/pgbox.running

  cp /var/mhs/state/app.list /var/mhs/state/app.list2

  file="/var/mhs/state/core.app"
  #if [ ! -e "$file" ]; then
  ls -la /opt/mhs/lib/apps-core | sed -e 's/.yml//g' \
    | awk '{print $9}' | tail -n +4 > /var/mhs/state/app.list
  while read p; do
    echo "" >> /opt/mhs/lib/apps-core/$p.yml
    echo "##PG-Core" >> /opt/mhs/lib/apps-core/$p.yml

    mkdir -p /opt/mhs/apps-local
    touch /opt/mhs/etc/rclone/rclone.conf
  done < /var/mhs/state/app.list
  touch /var/mhs/state/core.app
  #fi

  #bash /opt/mhs/lib/apps-core/_appsgen.sh
  docker ps | awk '{print $NF}' | tail -n +2 > /var/mhs/state/pgbox.running

  ### Remove Official Apps
  while read p; do
    # reminder, need one for custom apps
    baseline=$(cat /opt/mhs/lib/apps-core/$p.yml | grep "##PG-Core")
    if [ "$baseline" == "" ]; then sed -i -e "/$p/d" /var/mhs/state/app.list; fi
  done < /var/mhs/state/app.list

  ### Blank Out Temp List
  rm -rf /var/mhs/state/program.temp && touch /var/mhs/state/program.temp

  ### List Out Apps In Readable Order (One's Not Installed)
  num=0
  sed -i -e "/templates/d" /var/mhs/state/app.list
  sed -i -e "/image/d" /var/mhs/state/app.list
  sed -i -e "/watchtower/d" /var/mhs/state/app.list
  sed -i -e "/_/d" /var/mhs/state/app.list
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
  buildup=$(cat /var/mhs/state/pgbox.output)

  if [ "$buildup" == "" ]; then buildup="NONE"; fi
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Multi-App Installer | Core Edition
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📂 Potential Apps to Install

$notrun

💾 Apps Queued for Installation

$buildup

[A] Install

[Z] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -p '↪️ Type app to queue install | Press [ENTER]: ' typed < /dev/tty

  if [[ "$typed" == "deploy" || "$typed" == "Deploy" || "$typed" == "DEPLOY" || "$typed" == "install" || "$typed" == "Install" || "$typed" == "INSTALL" || "$typed" == "a" || "$typed" == "A" ]]; then question2; fi

  if [[ "$typed" == "exit" || "$typed" == "Exit" || "$typed" == "EXIT" || "$typed" == "z" || "$typed" == "Z" ]]; then exit; fi

  current=$(cat /var/mhs/state/pgbox.buildup | grep "\<$typed\>")
  if [ "$current" != "" ]; then queued && question1; fi

  current=$(cat /var/mhs/state/pgbox.running | grep "\<$typed\>")
  if [ "$current" != "" ]; then exists && question1; fi

  current=$(cat /var/mhs/state/program.temp | grep "\<$typed\>")
  if [ "$current" == "" ]; then badinputcore && question1; fi

  part1
}

part1() {
  echo "$typed" >> /var/mhs/state/pgbox.buildup
  num=0

  touch /var/mhs/state/pgbox.output && rm -rf /var/mhs/state/pgbox.output

  while read p; do
    echo -n $p >> /var/mhs/state/pgbox.output
    echo -n " " >> /var/mhs/state/pgbox.output
    if [[ "$num" == 7 ]]; then
      num=0
      echo " " >> /var/mhs/state/pgbox.output
    fi
  done < /var/mhs/state/pgbox.buildup

  sed -i "/^$typed\b/Id" /var/mhs/state/app.list

  question1
}

final() {
  read -p '✅ Process Complete! | PRESS [ENTER] ' typed < /dev/tty
  echo
  exit
}

question2() {

  # Image Selector
  image=off
  while read p; do

    echo "$p" > /tmp/program_var

    bash /opt/mhs/lib/apps-core/image/_image.sh

    # CName & Port Execution
    bash /opt/mhs/lib/core/pgbox/cname.sh
  done < /var/mhs/state/pgbox.buildup

  # Cron Execution
  edition=$(cat /var/mhs/state/pg.edition)
  if [[ "$edition" == "PG Edition - HD Solo" ]]; then
    a=b
  else
    croncount=$(sed -n '$=' /var/mhs/state/pgbox.buildup)
    echo "false" > /var/mhs/state/cron.count
    if [ "$croncount" -ge 2 ]; then bash /opt/mhs/lib/core/cron/mass.sh; fi
  fi

  while read p; do
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
$p - Now Installing!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

    sleep 1
    value
    # Store Used Program
    echo "$p" > /tmp/program_var
    # Execute Main Program
    ansible-playbook /opt/mhs/lib/apps-core/$p.yml

    if [[ "$edition" == "PG Edition - HD Solo" ]]; then
      a=b
    elif [ "$croncount" -eq "1" ]; then cronexe; fi

    # End Banner
    bash /opt/mhs/lib/core/pgbox/endbanner.sh >> /tmp/output.info

    sleep 2
  done < /var/mhs/state/pgbox.buildup
  echo "" >> /tmp/output.info
  cat /tmp/output.info
  final
}

start() {
  boxversion="official"
  initial
  question1
}

folder() {
  mkdir -p /opt/mhs/lib/apps-core
}

# FUNCTIONS END ##############################################################
echo "" > /tmp/output.info
start
