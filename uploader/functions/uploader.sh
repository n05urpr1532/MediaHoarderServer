#!/usr/bin/env bash

statusmount() {
  mcheck5=$(cat /opt/mhs/etc/rclone/rclone.conf | grep "$type")
  if [ "$mcheck5" != "" ]; then
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️  System Message: Warning!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
NOTE: $type already exists! To proceed, we must delete the prior
configuration for you.

EOF
    read -r -p '↘️  Proceed? y or n | Press [ENTER]: ' typed < /dev/tty

    if [[ "$typed" == "Y" || "$typed" == "y" ]]; then
      a=b
    elif [[ "$typed" == "N" || "$typed" == "n" ]]; then
      mountsmenu
    else
      badinput
      statusmount
    fi

    rclone config delete $type --config /opt/mhs/etc/rclone/rclone.conf

    encheck=$(cat /var/mhs/state/uploader.transport)
    if [[ "$encheck" == "be" || "$encheck" == "me" ]]; then
      if [ "$type" == "gdrive" ]; then
        rclone config delete gcrypt --config /opt/mhs/etc/rclone/rclone.conf
      fi
      if [ "$type" == "tdrive" ]; then
        rclone config delete tcrypt --config /opt/mhs/etc/rclone/rclone.conf
      fi
    fi

    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: $type deleted!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    read -r -p '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
  fi
}

tmgen() {

  secret=$(cat /var/mhs/state/uploader.secret)
  public=$(cat /var/mhs/state/uploader.public)

  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Google Auth - Team Drives
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: Copy & Paste Url into Browser | Use Correct Google Account!

https://accounts.google.com/o/oauth2/auth?client_id=$public&redirect_uri=urn:ietf:wg:oauth:2.0:oob&scope=https://www.googleapis.com/auth/drive&response_type=code

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Z] Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -r -p '↘️  Token | PRESS [ENTER]: ' token < /dev/tty
  if [ "$token" = "exit" ] || [ "$token" = "EXIT" ] || [ "$token" = "q" ] || [ "$token" = "Q" ]; then mountsmenu; fi
  curl --request POST --data "code=$token&client_id=$public&client_secret=$secret&redirect_uri=urn:ietf:wg:oauth:2.0:oob&grant_type=authorization_code" https://accounts.google.com/o/oauth2/token > /var/mhs/state/pgtokentm.output
  cat /var/mhs/state/pgtokentm.output | grep access_token | awk '{ print $2 }' | cut -c2- | rev | cut -c3- | rev > /var/mhs/state/pgtokentm2.output
  primet=$(cat /var/mhs/state/pgtokentm2.output)
  curl -H "GData-Version: 3.0" -H "Authorization: Bearer $primet" https://www.googleapis.com/drive/v3/teamdrives > /var/mhs/state/teamdrive.output
  tokenscript

  name=$(sed -n ${typed}p /var/mhs/state/teamdrive.name)
  id=$(sed -n ${typed}p /var/mhs/state/teamdrive.id)
  echo "$name" > /var/mhs/state/uploader.teamdrive
  echo "$id" > /var/mhs/state/uploader.teamid
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
😂 What a Lame TeamDrive Name: $name
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -r -p '↘️  Acknowledge Info | PRESS [ENTER] ' temp < /dev/tty
}

tokenscript() {
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

  echo ""
  read -r -p '↘️  Type Number | PRESS [ENTER]: ' typed < /dev/tty
  if [[ "$typed" -ge "1" && "$typed" -le "$A" ]]; then
    a=b
  else
    badinput
    tokenscript
  fi
}

inputphase() {
  deploychecks

  if [[ "$transport" == "PG Move /w No Encryption" || "$transport" == "PG Move /w Encryption" ]]; then
    display=""
  else
    if [ "$type" == "tdrive" ]; then
      display="TEAMDRIVE: $teamdrive
  "
    fi
  fi

  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: PG Clone - $type
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💬 PG is Deploying /w the Following Values:

🌅 ID
$public

💎 SECRET
$secret
$display
EOF

  read -r -p '↘️  Proceed? y or n | Press [ENTER]: ' typed < /dev/tty

  if [[ "$typed" == "Y" || "$typed" == "y" ]]; then
    a=b
  elif [[ "$typed" == "N" || "$typed" == "n" ]]; then
    question1
  else
    badinput
    inputphase
  fi

  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Google Auth
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: Copy & Paste Url into Browser | Use Correct Google Account!

https://accounts.google.com/o/oauth2/auth?client_id=$public&redirect_uri=urn:ietf:wg:oauth:2.0:oob&scope=https://www.googleapis.com/auth/drive&response_type=code

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Z] Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -r -p '↘️  Token | PRESS [ENTER]: ' token < /dev/tty
  if [ "$token" = "exit" ] || [ "$token" = "EXIT" ] || [ "$token" = "q" ] || [ "$token" = "Q" ]; then mountsmenu; fi
  curl --request POST --data "code=$token&client_id=$public&client_secret=$secret&redirect_uri=urn:ietf:wg:oauth:2.0:oob&grant_type=authorization_code" https://accounts.google.com/o/oauth2/token > /opt/mhs/etc/mhs/uploader.info

  accesstoken=$(cat /opt/mhs/etc/mhs/uploader.info | grep access_token | awk '{print $2}')
  refreshtoken=$(cat /opt/mhs/etc/mhs/uploader.info | grep refresh_token | awk '{print $2}')
  rcdate=$(date +'%Y-%m-%d')
  rctime=$(date +"%H:%M:%S" --date="$givenDate 60 minutes")
  rczone=$(date +"%:z")
  final=$(echo "${rcdate}T${rctime}${rczone}")

  testphase
}

mountsmenu() {

  # Sets Display Status if Passwords are not set for the encryhpted edition
  check5=$(cat /var/mhs/state/uploader.password)
  check6=$(cat /var/mhs/state/uploader.salt)
  if [[ "$check5" == "" || "$check6" == "" ]]; then
    passdisplay="⚠️  Not Activated"
  else passdisplay="✅ Activated"; fi

  projectid=$(cat /var/mhs/state/uploader.project)
  secret=$(cat /var/mhs/state/uploader.secret)
  public=$(cat /var/mhs/state/uploader.public)
  teamdrive=$(cat /var/mhs/state/uploader.teamdrive)

  if [ "$secret" == "" ]; then dsecret="NOT SET"; else dsecret="SET"; fi
  if [ "$public" == "" ]; then dpublic="NOT SET"; else dpublic="SET"; fi
  if [ "$teamdrive" == "" ]; then dteamdrive="NOT SET"; else dteamdrive=$teamdrive; fi

  gstatus=$(cat /var/mhs/state/gdrive.uploader)
  tstatus=$(cat /var/mhs/state/tdrive.uploader)

  ###### START
  if [ "$transport" == "PG Move /w No Encryption" ]; then
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 rClone - OAuth & Mounts
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💾 OAuth
[1] Client ID: $dpublic
[2] Secret ID: ${dsecret}

📁 RClone Configuration
[3] gdrive   : $gstatus

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Z] Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

    read -r -p '↘️  Set Choice | Press [ENTER]: ' typed < /dev/tty

    if [ "$typed" == "1" ]; then
      publickeyinput
      mountsmenu
    elif [ "$typed" == "2" ]; then
      secretkeyinput
      mountsmenu
    elif [ "$typed" == "3" ]; then
      type=gdrive
      statusmount
      inputphase
      mountsmenu
    elif [[ "$typed" == "Z" || "$typed" == "z" ]]; then
      question1
    else
      badinput
      mountsmenu
    fi
  fi
  ########## END

  ########## START
  if [ "$transport" == "PG Move /w Encryption" ]; then
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 rClone - OAuth & Mounts
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💾 OAuth
[1] Client ID: $dpublic
[2] Secret ID: ${dsecret}

💡 Required Tasks
[3] Passwords: $passdisplay

📁 RClone Configuration
[4] gdrive   : $gstatus

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Z] Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

    read -r -p '↘️  Set Choice | Press [ENTER]: ' typed < /dev/tty

    if [ "$typed" == "1" ]; then
      publickeyinput
      mountsmenu
    elif [ "$typed" == "2" ]; then
      secretkeyinput
      mountsmenu
    elif [ "$typed" == "3" ]; then
      blitzpasswords
      mountsmenu
    elif [ "$typed" == "4" ]; then
      encpasswdcheck
      type=gdrive
      statusmount
      inputphase
      mountsmenu
    elif [[ "$typed" == "Z" || "$typed" == "z" ]]; then
      question1
    else
      badinput
      mountsmenu
    fi
  fi
  ###### END

  ###### START
  if [ "$transport" == "PG Blitz /w No Encryption" ]; then
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 rClone - OAuth & Mounts
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💾 OAuth
[1] Client ID: $dpublic
[2] Secret ID: ${dsecret}

💡 Required Tasks
[3] TD Label : $dteamdrive

📁 RClone Configuration
[4] gdrive   : $gstatus
[5] tdrive   : $tstatus

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Z] Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

    read -r -p '↘️  Set Choice | Press [ENTER]: ' typed < /dev/tty

    if [ "$typed" == "1" ]; then
      publickeyinput
      mountsmenu
    elif [ "$typed" == "2" ]; then
      secretkeyinput
      mountsmenu
    elif [ "$typed" == "3" ]; then
      tmgen
      mountsmenu
    elif [ "$typed" == "4" ]; then
      type=gdrive
      statusmount
      inputphase
      mountsmenu
    elif [ "$typed" == "5" ]; then
      tmcheck=$(cat /var/mhs/state/uploader.teamdrive)
      if [ "$tmcheck" == "" ]; then
        tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔ Warning! TeamDrive is blank! Must be Set Prior!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
        read -r -p '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
        mountsmenu
      fi
      type=tdrive
      statusmount
      inputphase
      mountsmenu
    elif [[ "$typed" == "Z" || "$typed" == "z" ]]; then
      question1
    else
      badinput
      mountsmenu
    fi
  fi
  #################### END

  ##### START
  if [ "$transport" == "PG Blitz /w Encryption" ]; then
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 rClone - OAuth & Mounts
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💾 OAuth
[1] Client ID: $dpublic
[2] Secret ID: ${dsecret}

💡 Required Tasks
[3] TD Label : $dteamdrive
[4] Passwords: $passdisplay

📁 RClone Configuration
[5] gdrive   : $gstatus
[6] tdrive   : $tstatus

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Z] Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

    read -r -p '↘️  Set Choice | Press [ENTER]: ' typed < /dev/tty

    if [ "$typed" == "1" ]; then
      publickeyinput
      mountsmenu
    elif [ "$typed" == "2" ]; then
      secretkeyinput
      mountsmenu
    elif [ "$typed" == "3" ]; then
      tmgen
      mountsmenu
    elif [ "$typed" == "4" ]; then
      blitzpasswords
      mountsmenu
    elif [ "$typed" == "5" ]; then
      encpasswdcheck
      type=gdrive
      statusmount
      inputphase
      mountsmenu
    elif [ "$typed" == "6" ]; then
      encpasswdcheck
      tmcheck=$(cat /var/mhs/state/uploader.teamdrive)
      if [ "$tmcheck" == "" ]; then
        tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔ Warning! TeamDrive is blank! Must be Set Prior!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
        read -r -p '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
        mountsmenu
      fi
      type=tdrive
      statusmount
      inputphase
      mountsmenu
    elif [[ "$typed" == "Z" || "$typed" == "z" ]]; then
      question1
    else
      badinput
      mountsmenu
    fi
  fi
  #################### END

}

encpasswdcheck() {
  check5=$(cat /var/mhs/state/uploader.password)
  check6=$(cat /var/mhs/state/uploader.salt)

  if [[ "$check5" == "" || "$check6" == "" ]]; then
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔ Warning! You Need to Setup Your Passwords for the Encrypted Edition
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    read -r -p '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
    mountsmenu
  fi
}

blitzpasswords() {
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 Primary Password
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Please set a Primary Password for Encryption! Do not forget it! If you do,
you will be locked out from all your data!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Z] Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -r -p ' ↘️  Type Prime PW | Press [ENTER]: ' bpassword < /dev/tty

  if [ "$bpassword" == "" ]; then
    badinput
    blitzpasswords
  elif [[ "$bpassword" == "exit" || "$bpassword" == "Exit" || "$bpassword" == "EXIT" || "$bpassword" == "z" || "$bpassword" == "Z" ]]; then mountsmenu; fi
  blitzsalt
}

blitzsalt() {
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 SALT (Secondary Password)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Please set a Secondary Password (SALT) for Encryption! Do not forget it!
If you do, you will be locked out from all your data!  SALT randomizes
your data to further protect you! It is not recommended to use the same
password, but may.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Z] Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -r -p ' ↘️  Type SALT PW | Press [ENTER]: ' bsalt < /dev/tty

  if [ "$bsalt" == "" ]; then
    badinput
    blitzsalt
  elif [[ "$bsalt" == "exit" || "$bsalt" == "Exit" || "$bsalt" == "EXIT" || "$bsalt" == "z" || "$bsalt" == "Z" ]]; then mountsmenu; fi
  blitzpfinal

}

blitzpfinal() {
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 Set Passwords?
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Are you happy with the following info? Type y or n!

Primary  : $bpassword
Secondary: $bsalt

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Z] Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  read -r -p '↘️  Type y or n | Press [ENTER]: ' typed < /dev/tty

  if [ "$typed" == "n" ]; then
    mountsmenu
  elif [ "$typed" == "y" ]; then
    echo $bpassword > /var/mhs/state/uploader.password
    echo $bsalt > /var/mhs/state/uploader.salt
    mountsmenu
  else
    badinput
    blitzpfinal
  fi
}

publickeyinput() {
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Google OAuth Keys - Client ID
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
NOTE: Visit reference for Google OAuth Keys!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Z] Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  read -r -p '↘️  Client ID  | Press [Enter]: ' public < /dev/tty
  if [ "$public" = "exit" ]; then mountsmenu; fi
  echo "$public" > /var/mhs/state/uploader.public

  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 Client ID Set
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -r -p '↘️  Acknowledge Info  | Press [ENTER] ' public < /dev/tty
  mountsmenu
}

secretkeyinput() {
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Google OAuth Keys - Secret Key
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
NOTE: Visit reference for Google OAuth Keys!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Z] Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -r -p '↘️  Secret Key  | Press [Enter]: ' secret < /dev/tty
  if [ "$secret" = "exit" ]; then mountsmenu; fi
  echo "$secret" > /var/mhs/state/uploader.secret

  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 Secret ID Set
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -r -p '↘️  Acknowledge Info  | Press [ENTER] ' public < /dev/tty

  mountsmenu
}

projectmenu() {
  projectid=$(cat /var/mhs/state/uploader.project)

  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 GCloud Project Interface
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Project ID: $projectid

[1] Establish
[2] Create
[3] Destroy (NOT READY)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Z] Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  read -r -p '↘️  Set Choice | Press [ENTER]: ' typed < /dev/tty

  if [ "$typed" == "1" ]; then
    projectestablish
  elif [ "$typed" == "2" ]; then
    projectcreate
  elif [[ "$typed" == "z" || "$typed" == "Z" ]]; then
    question1
  else
    badinput
    projectmenu
  fi
}

projectestablish() {

  gcloud projects list > /var/mhs/state/projects.list
  projectcheck=(cat /var/mhs/state/projects.list)
  if [ "$projectcheck" == "" ]; then
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔  System Message: Error! There are no projects! Make one first!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    read -r -p ' ↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
    projectmenu
  fi

  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 Established Projects
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Project ID: $projectid

EOF
  cat /var/mhs/state/projects.list | cut -d' ' -f1 | tail -n +2
  cat /var/mhs/state/projects.list | cut -d' ' -f1 | tail -n +2 > /var/mhs/state/project.cut
  echo
  changeproject
  echo
  projectidset
  gcloud config set project $typed

  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 System Message: Enabling Drive API ~ Project $typed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  gcloud services enable drive.googleapis.com --project $typed
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 System Message: Project Established ~ $typed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  echo $typed > /var/mhs/state/uploader.project
  read -r -p '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
  projectmenu

}

transportdisplay() {
  temp=$(cat /var/mhs/state/uploader.transport)
  if [ "$temp" == "mu" ]; then
    transport="PG Move /w No Encryption"
  elif [ "$temp" == "me" ]; then
    transport="PG Move /w Encryption"
  elif [ "$temp" == "bu" ]; then
    transport="PG Blitz /w No Encryption"
  elif [ "$temp" == "be" ]; then
    transport="PG Blitz /w Encryption"
  elif [ "$temp" == "le" ]; then
    transport="PG Local"
  else transport="NOT-SET"; fi
}

transportmode() {
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌟 Select Transport Mode
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] Move  /w No Encryption | Upload 750GB Daily ~ Simple
[2] Move  /w Encryption    | Upload 750GB Daily ~ Simple
[3] Blitz /w No Encryption | Exceed 750GB Daily ~ Complex
[4] Blitz /w Encryption    | Exceed 750GB Daily ~ Complex
[5] Local                  | No GSuite - Stays Local

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Z] Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -r -p '↘️  Set Choice | Press [ENTER]: ' typed < /dev/tty

  if [ "$typed" == "1" ]; then
    echo "mu" > /var/mhs/state/uploader.transport && echo
  elif [ "$typed" == "2" ]; then
    echo "me" > /var/mhs/state/uploader.transport && echo
  elif [ "$typed" == "3" ]; then
    echo "bu" > /var/mhs/state/uploader.transport && echo
  elif [ "$typed" == "4" ]; then
    echo "be" > /var/mhs/state/uploader.transport && echo
  elif [ "$typed" == "5" ]; then
    echo "le" > /var/mhs/state/uploader.transport && echo
  elif [[ "$typed" == "Z" || "$typed" == "z" ]]; then

    # If a New Installer, User Cannot Exit & Must Select a Version
    transport=$(cat /var/mhs/state/uploader.transport)
    if [ "$transport" == "NOT-SET" ]; then
      transportmode
    fi

    question1
  else
    badinput
    transportmode
  fi
}

changeproject() {
  read -r -p '💬 Set/Change Project ID? (y/n)| Press [ENTER] ' typed < /dev/tty
  if [[ "$typed" == "n" || "$typed" == "N" ]]; then
    question1
  elif [[ "$typed" == "y" || "$typed" == "Y" ]]; then
    a=b
  else
    badinput
    echo ""
    changeproject
  fi
}

projectidset() {
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Type the Project Name to Utilize
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  cat /var/mhs/state/projects.list | cut -d' ' -f1 | tail -n +2
  cat /var/mhs/state/projects.list | cut -d' ' -f1 | tail -n +2 > /var/mhs/state/project.cut
  echo ""
  read -r -p '↘️  Type Project Name | Press [ENTER]: ' typed < /dev/tty
  echo ""
  list=$(cat /var/mhs/state/project.cut | grep $typed)

  if [ "$typed" != "$list" ]; then
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔  System Message: Error! Type Exact of the Project Name Listed!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    read -r -p ' ↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
    projectidset
  fi
}

testphase() {
  echo "" > /opt/mhs/etc/mhs/test.conf
  echo "[$type]" >> /opt/mhs/etc/mhs/test.conf
  echo "client_id = $public" >> /opt/mhs/etc/mhs/test.conf
  echo "client_secret = $secret" >> /opt/mhs/etc/mhs/test.conf
  echo "type = drive" >> /opt/mhs/etc/mhs/test.conf
  echo -n "token = {\"access_token\":${accesstoken}\"token_type\":\"Bearer\",\"refresh_token\":${refreshtoken}\"expiry\":\"${final}\"}" >> /opt/mhs/etc/mhs/test.conf
  echo "" >> /opt/mhs/etc/mhs/test.conf
  if [ "$type" == "tdrive" ]; then
    teamid=$(cat /var/mhs/state/uploader.teamid)
    echo "team_drive = $teamid" >> /opt/mhs/etc/mhs/test.conf
  fi
  echo ""

  ## Adds Encryption to the Test Phase if Move or Blitz Encrypted is On
  encheck=$(cat /var/mhs/state/uploader.transport)
  if [[ "$encheck" == "be" || "$encheck" == "me" ]]; then

    if [ "$type" == "gdrive" ]; then
      entype="gcrypt"
    else entype="tcrypt"; fi

    PASSWORD=$(cat /var/mhs/state/uploader.password)
    SALT=$(cat /var/mhs/state/uploader.salt)
    ENC_PASSWORD=$(rclone obscure "$PASSWORD")
    ENC_SALT=$(rclone obscure "$SALT")
    echo "" >> /opt/mhs/etc/mhs/test.conf
    echo "[$entype]" >> /opt/mhs/etc/mhs/test.conf
    echo "type = crypt" >> /opt/mhs/etc/mhs/test.conf
    echo "remote = $type:/encrypt" >> /opt/mhs/etc/mhs/test.conf
    echo "filename_encryption = standard" >> /opt/mhs/etc/mhs/test.conf
    echo "directory_name_encryption = true" >> /opt/mhs/etc/mhs/test.conf
    echo "password = $ENC_PASSWORD" >> /opt/mhs/etc/mhs/test.conf
    echo "password2 = $ENC_SALT" >> /opt/mhs/etc/mhs/test.conf

  fi
  testphase2
}

testphase2() {
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Conducting Validation Checks - $type
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  sleep 1
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Creating Test Directory - $type:/mhs
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  sleep 1
  rclone mkdir --config /opt/mhs/etc/mhs/test.conf $type:/mhs
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Checking Existance of $type:/mhs
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  rcheck=$(rclone lsd --config /opt/mhs/etc/mhs/test.conf $type: | grep -oP mhs | head -n1)

  if [ "$rcheck" != "mhs" ]; then
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔  System Message: Validation Checks Failed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

TIPS:
1. Did you copy your username and password correctly?
2. When you created the credentials, did you select "Other"?
3. Did you enable your API?

FOR ENCRYPTION (IF SELECTED)
1. Did You Set a Password?

EOF
    echo "⚠️  Not Activated" > /var/mhs/state/$type.uploader
    read -r -p '↘️  Acknowledge Info | Press [ENTER] ' typed2 < /dev/tty
    question1
  else
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Validation Checks Passed - $type
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  fi

  read -r -p '↘️  Acknowledge Info | Press [ENTER] ' typed2 < /dev/tty
  echo "✅ Activated" > /var/mhs/state/$type.uploader

  ## Copy the Test File to the Real RClone Conf
  cat /opt/mhs/etc/mhs/test.conf >> /opt/mhs/etc/rclone/rclone.conf

  ## Back to the Main Mount Menu
  mountsmenu

  EOF
}

deploychecks() {
  secret=$(cat /var/mhs/state/uploader.secret)
  public=$(cat /var/mhs/state/uploader.public)
  teamdrive=$(cat /var/mhs/state/uploader.teamdrive)

  if [ "$secret" == "" ]; then
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔  ERROR: Secret Key Is Blank! Unable to Deploy!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    read -r -p '↘️  Acknowledge Info | Press [Enter] ' typed < /dev/tty
    question1
  fi

  if [ "$public" == "" ]; then
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔  ERROR: Client ID Is Blank! Unable to Deploy!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    read -r -p '↘️  Acknowledge Info | Press [Enter] ' typed < /dev/tty
    question1
  fi
}
