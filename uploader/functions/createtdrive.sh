#!/usr/bin/env bash

ctdrive() {
  uploadervars

  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Create TeamDrive

https://accounts.google.com/o/oauth2/auth?client_id=$uploaderpublic&redirect_uri=urn:ietf:wg:oauth:2.0:oob&scope=https://www.googleapis.com/auth/drive&response_type=code

Copy & Paste the URL into Browser! Ensure to utilize and login with
the correct Google Account!

PUTTY USERS: Just select and highlight! DO NOT RIGHT CLICK! When you paste
into the browser, it will just work!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Z] Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -r -p '↘️  Token | PRESS [ENTER]: ' token < /dev/tty
  if [[ "$token" == "exit" || "$token" == "Exit" || "$token" == "EXIT" || "$token" == "z" || "$token" == "Z" ]]; then clonestart; fi
  curl --request POST --data "code=$token&client_id=$uploaderpublic&client_secret=$uploadersecret&redirect_uri=urn:ietf:wg:oauth:2.0:oob&grant_type=authorization_code" https://accounts.google.com/o/oauth2/token > /opt/mhs/etc/mhs/uploader.info

  accesstoken=$(cat /opt/mhs/etc/mhs/uploader.info | grep access_token | awk '{print $2}')

  curl --request POST \
  'https://www.googleapis.com/drive/v3/teamdrives?requestId=foxfield' \
  --header "Authorization: Bearer ${accesstoken}" \
  --header 'Accept: application/json' \
  --header 'Content-Type: application/json' \
  --data '{"name":"Media"}' \
  --compressed
}
