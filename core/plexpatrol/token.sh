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

question1() {
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 PlexToken Generator
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Generate new Token for Plex Patrol

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  read -r -p '↘️  PRESS [ENTER] ' typed < /dev/tty

  case $typed in
    *)
      read -r -p 'Enter the PLEX User Name      | Press [ENTER]: ' user < /dev/tty
      read -r -p 'Enter the PLEX User Password  | Press [ENTER]: ' pw < /dev/tty

      tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🍖  NOM NOM - Saved Your Information!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
      sleep 3
      question2
      ;;
  esac
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
  echo "$pw" > /var/mhs/state/plexpatrol/plex.pw
  echo "$user" > /var/mhs/state/plexpatrol/plex.user
  PLEX_LOGIN=$(cat /var/mhs/state/plexpatrol/plex.user)
  PLEX_PASSWORD=$(cat /var/mhs/state/plexpatrol/plex.pw)

  curl -qu "${PLEX_LOGIN}":"${PLEX_PASSWORD}" 'https://plex.tv/users/sign_in.xml' \
  -X POST -H 'X-Plex-Device-Name: PlexMediaServer' \
  -H 'X-Plex-Provides: server' \
  -H 'X-Plex-Version: 0.9' \
  -H 'X-Plex-Platform-Version: 0.9' \
  -H 'X-Plex-Platform: xcid' \
  -H 'X-Plex-Product: Plex Media Server'\
  -H 'X-Plex-Device: Linux'\
  -H 'X-Plex-Client-Identifier: XXXX' --compressed > /tmp/plex_sign_in
  X_PLEX_TOKEN=$(sed -n 's/.*<authentication-token>\(.*\)<\/authentication-token>.*/\1/p' /tmp/plex_sign_in)
  if [ -z "$X_PLEX_TOKEN" ]; then
    cat /tmp/plex_sign_in
    rm -f /tmp/plex_sign_in
    echo >&2 'Failed to retrieve the X-Plex-Token.'
    exit 1
  fi
  echo $X_PLEX_TOKEN > /var/mhs/state/plexpatrol/plex.token

  token=$(cat /var/mhs/state/plexpatrol/plex.token)
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
question1
