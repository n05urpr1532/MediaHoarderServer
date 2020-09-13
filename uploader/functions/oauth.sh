#!/usr/bin/env bash

oauth() {
  uploadervars

  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Google Auth - ${type}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

https://accounts.google.com/o/oauth2/auth?client_id=$uploaderpublic&redirect_uri=urn:ietf:wg:oauth:2.0:oob&scope=https://www.googleapis.com/auth/drive&response_type=code

Copy & Paste the URL into Browser! Ensure to utilize and login with
the correct Google Account!

PUTTY USERS: Just select and highlight! DO NOT RIGHT CLICK! When you paste
into the browser, it will just work!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Z] Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -p '↘️  Token | PRESS [ENTER]: ' token < /dev/tty
  if [[ "$token" == "exit" || "$token" == "Exit" || "$token" == "EXIT" || "$token" == "z" || "$token" == "Z" ]]; then clonestart; fi
  curl --request POST --data "code=$token&client_id=$uploaderpublic&client_secret=$uploadersecret&redirect_uri=urn:ietf:wg:oauth:2.0:oob&grant_type=authorization_code" https://accounts.google.com/o/oauth2/token > /opt/mhs/etc/mhs/uploader.info

  accesstoken=$(cat /opt/mhs/etc/mhs/uploader.info | grep access_token | awk '{print $2}')
  refreshtoken=$(cat /opt/mhs/etc/mhs/uploader.info | grep refresh_token | awk '{print $2}')
  rcdate=$(date +'%Y-%m-%d')
  rctime=$(date +"%H:%M:%S" --date="$givenDate 60 minutes")
  rczone=$(date +"%:z")
  final=$(echo "${rcdate}T${rctime}${rczone}")

  ########################
  rm -rf /opt/mhs/etc/mhs/.${type} 1> /dev/null 2>&1
  echo "" > /opt/mhs/etc/mhs/.${type}
  echo "[$type]" >> /opt/mhs/etc/mhs/.${type}
  echo "client_id = $uploaderpublic" >> /opt/mhs/etc/mhs/.${type}
  echo "client_secret = $uploadersecret" >> /opt/mhs/etc/mhs/.${type}
  echo "type = drive" >> /opt/mhs/etc/mhs/.${type}
  echo "server_side_across_configs = true" >> /opt/mhs/etc/mhs/.${type}
  echo -n "token = {\"access_token\":${accesstoken}\"token_type\":\"Bearer\",\"refresh_token\":${refreshtoken}\"expiry\":\"${final}\"}" >> /opt/mhs/etc/mhs/.${type}
  echo "" >> /opt/mhs/etc/mhs/.${type}
  if [ "$type" == "tdrive" ]; then
    teamid=$(cat /var/mhs/state/uploader.teamid)
    echo "team_drive = $teamid" >> /opt/mhs/etc/mhs/.tdrive
  fi
  echo ""

  echo ${type} > /var/mhs/state/oauth.check
  oauthcheck

  ## Adds Encryption to the Test Phase if Move or Blitz Encrypted is On
  if [[ "$transport" == "be" || "$transport" == "me" ]]; then

    if [ "$type" == "gdrive" ]; then
      entype="gcrypt"
    else entype="tcrypt"; fi

    PASSWORD=$(cat /var/mhs/state/uploader.password)
    SALT=$(cat /var/mhs/state/uploader.salt)
    ENC_PASSWORD=$(rclone obscure "$PASSWORD")
    ENC_SALT=$(rclone obscure "$SALT")

    rm -rf /opt/mhs/etc/mhs/.${entype} 1> /dev/null 2>&1
    echo "" >> /opt/mhs/etc/mhs/.${entype}
    echo "[$entype]" >> /opt/mhs/etc/mhs/.${entype}
    echo "type = crypt" >> /opt/mhs/etc/mhs/.${entype}
    echo "remote = $type:/encrypt" >> /opt/mhs/etc/mhs/.${entype}
    echo "filename_encryption = standard" >> /opt/mhs/etc/mhs/.${entype}
    echo "directory_name_encryption = true" >> /opt/mhs/etc/mhs/.${entype}
    echo "password = $ENC_PASSWORD" >> /opt/mhs/etc/mhs/.${entype}
    echo "password2 = $ENC_SALT" >> /opt/mhs/etc/mhs/.${entype}
  fi

  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 Process Complete
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💬  [${type}] is now established!

NOTE: If you change projects or use a different login, rerun this again!
If not, nothing will work!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -p '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
  clonestart

}
# (BELOW - SET TEAMDRIVE NAME)##################################################
tlabeloauth() {
  uploadervars
  gtype="https://www.googleapis.com/drive/v3/teamdrives"
  storage="/var/mhs/state/teamdrive.output"

  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Google Auth - Team Drive Label
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

https://accounts.google.com/o/oauth2/auth?client_id=${uploaderpublic}&redirect_uri=urn:ietf:wg:oauth:2.0:oob&scope=https://www.googleapis.com/auth/drive&response_type=code

Copy & Paste the URL into Browser! Ensure to utilize and login with
the correct Google Account!

PUTTY USERS: Just select and highlight! DO NOT RIGHT CLICK! When you paste
into the browser, it will just work!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Z] Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -p '↘️  Token | PRESS [ENTER]: ' token < /dev/tty

  if [[ "$token" == "exit" || "$token" == "Exit" || "$token" == "EXIT" || "$token" == "z" || "$token" == "Z" ]]; then clonestart; fi
  curl --request POST --data "code=${token}&client_id=${uploaderpublic}&client_secret=${uploadersecret}&redirect_uri=urn:ietf:wg:oauth:2.0:oob&grant_type=authorization_code" https://accounts.google.com/o/oauth2/token > /var/mhs/state/token.part1
  curl -H "GData-Version: 3.0" -H "Authorization: Bearer $(cat /var/mhs/state/token.part1 | grep access_token | awk '{ print $2 }' | cut -c2- | rev | cut -c3- | rev)" $gtype > $storage
  teamdriveselect
}

teamdriveselect() {
  cat /var/mhs/state/teamdrive.output | grep "id" | awk '{ print $2 }' | cut -c2- | rev | cut -c3- | rev > /var/mhs/state/teamdrive.id
  cat /var/mhs/state/teamdrive.output | grep "name" | awk '{ print $2 }' | cut -c2- | rev | cut -c2- | rev > /var/mhs/state/teamdrive.name

  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Listed Team Drives
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  A=0
  while read p; do
    ((A++))
    name=$(sed -n ${A}p /var/mhs/state/teamdrive.name)
    echo "[$A] $p - $name"
  done < /var/mhs/state/teamdrive.id

  if [[ $(cat /var/mhs/state/teamdrive.name) == "" ]]; then
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 No Team Drives Exist or Bad Token!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE1: Create a Team Drive First or Share on to this account and retry the
process again!

NOTE2: If a bad token, ensure that you are using the correct account when
signing in (and/or conducting a proper copy and paste of the token)!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    read -p '↘️  Acknowlege Info | Press [ENTER] ' typed < /dev/tty
    clonestart
  fi

  echo ""
  read -p '↘️  Type Number | Press [ENTER]: ' typed < /dev/tty
  if [[ "$typed" -ge "1" && "$typed" -le "$A" ]]; then
    a=b
  else teamdriveselect; fi

  name=$(sed -n ${typed}p /var/mhs/state/teamdrive.name)
  id=$(sed -n ${typed}p /var/mhs/state/teamdrive.id)
  echo "$name" > /var/mhs/state/uploader.teamdrive
  echo "$id" > /var/mhs/state/uploader.teamid

  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Process Complete! TeamDrive [$name]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: Do not share out your teamdrives to others! The usage counts against
you and if others share your content, you have no control (and your team
drive can be shutdown!)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -p '↘️  Acknowledge Info | PRESS [ENTER] ' temp < /dev/tty
}

mountchecker() {
  uploadervars
  if [[ "$transport" == "mu" ]]; then
    if [[ "$gstatus" != "ACTIVE" ]]; then mountfail; fi
  elif [[ "$transport" == "me" ]]; then
    if [[ "$gstatus" != "ACTIVE" || "$gcstatus" != "ACTIVE" ]]; then mountfail; fi
  elif [[ "$transport" == "bu" ]]; then
    if [[ "$gstatus" != "ACTIVE" || "$tstatus" != "ACTIVE" ]]; then mountfail; fi
  elif [[ "$transport" == "be" ]]; then
    if [[ "$gstatus" != "ACTIVE" || "$tstatus" != "ACTIVE" || "$tstatus" != "ACTIVE" || "$tcstatus" != "ACTIVE" ]]; then mountfail; fi
  fi
}

mountfail() {
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 Fail Notice
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💬  All Mounts Must Be Active!

NOTE: If any mount says [NOT-SET]; that process must be completed first!
We will continue to block this process until completed!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -p '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
  clonestart
}

tlabelchecker() {
  uploadervars
  if [[ "$tdname" == "NOT-SET" ]]; then

    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 Fail Notice
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💬  Team Drive Label Not Set!

NOTE: Unless we know your Team Drive name, we have no way of configuring
the Team Drive! Please complete this first!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    read -p '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
    clonestart
  fi
}
