#!/usr/bin/env bash

# FUNCTIONS START ##############################################################

# BAD INPUT
badinput() {
  echo
  read -r -p '⛔️ ERROR - BAD INPUT! | PRESS [ENTER] ' typed < /dev/tty
  question1
}

badinput2() {
  echo
  read -r -p '⛔️ ERROR - BAD INPUT! | PRESS [ENTER] ' typed < /dev/tty
  question2
}

tokenstatus() {
  ptokendep=$(cat /var/mhs/state/plex.token)
  if [ "$ptokendep" != "" ]; then
    PGSELFTEST=$(curl -LI "http://$(hostname -I | awk '{print $1}'):32400/system?X-Plex-Token=$(cat /var/mhs/state/plex.token)" -o /dev/null -w '%{http_code}\n' -s)
    if [[ $PGSELFTEST -ge 200 && $PGSELFTEST -le 299 ]]; then
      pstatus="✅ DEPLOYED"
    else
      pstatus="❌ DEPLOYED BUT TOKEN FAILED"
    fi
  else pstatus="⚠️ NOT DEPLOYED"; fi
}

# FIRST QUESTION

question1() {
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 PlexToken Generator
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Token Status				: [$pstatus]

[1] - Generate new Token

[2] - Token - Existing

[Z] - Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  read -r -p 'Make a Selection | Press [ENTER]: ' typed < /dev/tty
  echo

  if [ "$typed" == "1" ]; then
    read -r -p 'Enter the PLEX User Name      | Press [ENTER]: ' user < /dev/tty
    read -r -p 'Enter the PLEX User Password  | Press [ENTER]: ' pw < /dev/tty

    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🍖  NOM NOM - Saved Your Information!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
    sleep 3
    question2
  elif [ "$typed" == "2" ]; then

    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🍖  NOM NOM - Read Your Information!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
    sleep 3
    tokenexist

    pw=$(cat /var/mhs/state/plex.pw)
    user=$(cat /var/mhs/state/plex.user)

  elif [[ "$typed" == "Z" || "$typed" == "z" ]]; then
    exit
  else badinput; fi
}

question2() {
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📂  User Name & Password Confirmation
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

User Name: $user

User Pass: $pw

⚠️  Information Correct?

[1] YES
[2] NO

[Z] - Exit Interface

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  read -r -p 'Make a Selection | Press [ENTER]: ' typed < /dev/tty

  if [ "$typed" == "1" ]; then
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🍖 NOM NOM - Got It! Generating the Plex Token!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: If the token is bad, this process will repeat again!

EOF
    sleep 4
    question3
  elif [ "$typed" == "2" ]; then
    question1
  elif [[ "$typed" == "Z" || "$typed" == "z" ]]; then
    exit
  else badinput2; fi
}

question3() {
  echo "$pw" > /var/mhs/state/plex.pw
  echo "$user" > /var/mhs/state/plex.user
  ansible-playbook /opt/mhs/lib/core/plex/token.yml
  token=$(cat /var/mhs/state/plex.token)
  if [ "$token" != "" ]; then
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅️  PlexToken Generation Succeeded!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
    sleep 4
  else
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  PlexToken Generation Failed!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: Process will repeat until you succeed or exit!

EOF
    read -r -p 'Acknowledge Info | PRESS [ENTER] ' < /dev/tty
    question1
  fi
}

tokenexist() {
  pw=$(cat /var/mhs/state/plex.pw)
  user=$(cat /var/mhs/state/plex.user)
  ansible-playbook /opt/mhs/lib/core/plex/token.yml
  token=$(cat /var/mhs/state/plex.token)
  token=$(cat /var/mhs/state/plex.token)
  if [ "$token" != "" ]; then
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅️  PlexToken Generation Succeeded!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
    sleep 4
  else
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  PlexToken Generation Failed!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: Process will repeat until you succeed or exit!

EOF
    read -r -p 'Acknowledge Info | PRESS [ENTER] ' < /dev/tty
    question1
  fi
}

# FUNCTIONS END ##############################################################
tokenstatus
question1
