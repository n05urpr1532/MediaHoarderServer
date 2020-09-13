#!/usr/bin/env bash

base() {
  rm -rf /var/mhs/state/shield.ui.check
  touch /var/mhs/state/shield.ui.check

  oauth=$(docker ps --format '{{.Names}}' | grep "oauth")
  domain=$(cat /var/mhs/state/server.domain)
  pgui=$(docker ps --format '{{.Names}}' | grep "pgui")
  email=$(cat /var/mhs/state/pgshield.emails | head -n 1)
  portainer=$(docker ps --format '{{.Names}}' | grep "portainer")
  #######################################################

  if [[ $pgui == "pgui" ]]; then
    echo -e "pgui" >> /var/mhs/state/shield.ui.check
  else
    if [[ $portainer == "portainer" ]]; then
      echo -e "portainer" >> /var/mhs/state/shield.ui.check
    fi
  fi

  part=$(cat /var/mhs/state/shield.ui.check)
}
########################################################

question() {
  if [[ $oauth == "oauth" ]]; then

    tee <<- EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 MHS-Shield Deployed Validator
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[ 1 ] open a new incognito tab on your browser
[ 2 ] open https://${pgui}.${domain}
[ 3 ] and log in via your added Gmail-Account
      Gmail-Account     =     ${email}

[ 3 - ERROR ] you do not see any E-mail Address
              about this text
			  so go back and add a E-mail Address

[ 4 ] now refresh the page ( non-incognito tab )

[ 4 - ERROR ] if you get an error and can't log in
			  delete your browser cache.

[ 4 - WORKS ] If you can see the login window
			  and log in works like a charm,
			  everything is wonderful

[ 5 ] Thus MHS-Shield would be deployed
      and works if all 4 points are met

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  fi

  read -r -p 'Acknowledge Info | PRESS [ENTER] ' < /dev/tty
}

########################################################
# functions start
########################################################
base
question
