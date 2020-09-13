#!/usr/bin/env bash
#

# KEY VARIABLE RECALL & EXECUTION
mkdir -p /var/mhs/state/cron/
mkdir -p /opt/mhs/etc/mhs/cron
# FUNCTIONS START ##############################################################
source /opt/mhs/lib/core/functions/functions.sh

weekrandom() {
  while read p; do
    echo "$p" > /tmp/program_var
    echo $(($RANDOM % 23)) > /var/mhs/state/cron/cron.hour
    echo $(($RANDOM % 59)) > /var/mhs/state/cron/cron.minute
    echo $(($RANDOM % 6)) > /var/mhs/state/cron/cron.day
    ansible-playbook /opt/mhs/lib/core/cron/cron.yml
  done < /var/mhs/state/pgbox.buildup
  exit
}

dailyrandom() {
  while read p; do
    echo "$p" > /tmp/program_var
    echo $(($RANDOM % 23)) > /var/mhs/state/cron/cron.hour
    echo $(($RANDOM % 59)) > /var/mhs/state/cron/cron.minute
    echo "*/1" > /var/mhs/state/cron/cron.day
    ansible-playbook /opt/mhs/lib/core/cron/cron.yml
  done < /var/mhs/state/pgbox.buildup
  exit
}

manualuser() {
  while read p; do
    echo "$p" > /tmp/program_var
    bash /opt/mhs/lib/core/cron/cron.sh
  done < /var/mhs/state/pgbox.buildup
  exit
}

# FIRST QUESTION
question1() {
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛ Cron - Schedule Cron Jobs (Backups) | Mass Program Interface
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] No  [Skip   - All Cron Jobs]
[2] Yes [Manual - Select for Each App]
[3] Yes [Daily  - Select Random Times]
[4] Yes [Weekly - Select Random Times & Days]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  read -r -p '↘️  Type Number | Press [ENTER]: ' typed < /dev/tty
  if [ "$typed" == "1" ]; then
    exit
  elif [ "$typed" == "2" ]; then
    manualuser && ansible-playbook /opt/mhs/lib/core/cron/cron.yml
  elif [ "$typed" == "3" ]; then
    dailyrandom && ansible-playbook /opt/mhs/lib/core/cron/cron.yml
  elif [ "$typed" == "4" ]; then
    weekrandom && ansible-playbook /opt/mhs/lib/core/cron/cron.yml
  else badinput1; fi
}

question1
