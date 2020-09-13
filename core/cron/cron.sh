#!/usr/bin/env bash

# KEY VARIABLE RECALL & EXECUTION
program=$(cat /tmp/program_var)
mkdir -p /var/mhs/state/cron/
mkdir -p /opt/mhs/etc/mhs/cron
# FUNCTIONS START ##############################################################
source /opt/mhs/lib/core/functions/functions.sh
RAN=$(head /dev/urandom | tr -dc 0-7 | head -c 1)
# FIRST QUESTION
question1() {
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛ Cron - Schedule Cron Jobs (Backups) | $program?
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[ 1 ] No

[ 2 ] Yes

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  read -r -p '↘️  Type Number | Press [ENTER]: ' typed < /dev/tty
  if [ "$typed" == "1" ]; then
    ansible-playbook /opt/mhs/lib/core/cron/remove.yml && exit
  elif [ "$typed" == "2" ]; then
    break="on"
  else badinput; fi
}

# SECOND QUESTION
question2() {
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛  Cron - Backup How Often?
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

WEEKLY

[ 0 / 7 ] - Sunday
[ 1 ]     - Monday
[ 2 ]     - Tuesday
[ 3 ]     - Wednesday
[ 4 ]     - Thursday
[ 5 ]     - Friday
[ 6 ]     - Saturday

DAILY
[ 8 ] - Daily

RANDOM
[ 9 ] - RANDOM

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  read -r -p '↘️  Type Number | Press [ENTER]: ' typed < /dev/tty

  if [[ "$typed" -ge "0" && "$typed" -le "7" ]]; then
    echo $typed > /var/mhs/state/cron/cron.day && break=1
  elif [ "$typed" == "8" ]; then
    echo "*" > /var/mhs/state/cron/cron.day && break=1
  elif [ "$typed" == "9" ]; then
    echo $RAN > /var/mhs/state/cron/cron.day && break=1
  else badinput; fi
}

# THIRD QUESTION
question3() {
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛ Cron - Hour of the Day?
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Type an HOUR from [0 to 23]

0  = 00:00 | 12AM
12 = 12:00 | 12PM
18 = 18:00 | 6 PM

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  read -r -p '↘️  Type a Number | Press [ENTER]: ' typed < /dev/tty
  if [[ "$typed" -ge "0" && "$typed" -le "23" ]]; then
    echo $typed > /var/mhs/state/cron/cron.hour && break=1
  else badinput; fi
}

# FUNCTIONS END ##############################################################

break=off && while [ "$break" == "off" ]; do question1; done
break=off && while [ "$break" == "off" ]; do question2; done
break=off && while [ "$break" == "off" ]; do question3; done

echo $(($RANDOM % 59)) > /var/mhs/state/cron/cron.minute
ansible-playbook /opt/mhs/lib/core/cron/cron.yml
