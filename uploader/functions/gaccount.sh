#!/usr/bin/env bash

# BAD INPUT
badinput() {
  echo
  read -p '⛔️ ERROR - Bad Input! | Press [ENTER] ' typed < /dev/tty
}
variable /var/mhs/state/project.email "NOT-SET"
emailaccount=$(cat /var/mhs/state/project.email)

glogin() {
  if [[ "$emailaccount" == "NOT-SET" ]]; then
    echo
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo " Email Account - NOT-SET - First Start "
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  fi

  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💪 Set E-Mail Address
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
What email address from the Google Console do you want to be associated
with from your Google GSuite? Ensure that it exists!

[Z] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  read -p '↘️  Input E-Mail | Press [ENTER]: ' typed < /dev/tty

  if [[ "$typed" == "" ]]; then glogin; fi
  if [[ "$typed" == "exit" || "$typed" == "Exit" || "$typed" == "EXIT" || "$typed" == "z" || "$typed" == "Z" ]]; then clonestart; fi

  gcloud auth login --account = $typed
  gcloud info | grep Account: | cut -c 10- > /var/mhs/state/project.account
  account=$(cat /var/mhs/state/project.account)

  testcheck=$(gcloud auth list | grep "$typed")
  if [[ "$testcheck" == "" ]]; then
    echo
    echo "INFO CHECK: E-Mail Address Failed!"
    read -p '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
    glogin
  fi

  echo "$typed" > /var/mhs/state/uploader.email
}
