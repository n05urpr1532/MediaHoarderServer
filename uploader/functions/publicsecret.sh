#!/usr/bin/env bash

keyinputpublic() {
  uploadervars
  if [[ "$uploaderid" == "ACTIVE" ]]; then
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 rClone - Change Values?
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CLIENT ID
$uploaderpublic

SECRET ID
$uploadersecret

WARNING: Changing the values will RESET & DELETE the following:
1. GDrive
2. TDrive
3. Service Keys

Change the Stored Values?
[1] No [2] Yes

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    read -r -p '↘️  Input Value | Press [Enter]: ' typed < /dev/tty
    case $typed in
      2)
        rm -rf /opt/mhs/etc/mhs/.gcrypt 1> /dev/null 2>&1
        rm -rf /opt/mhs/etc/mhs/.gdrive 1> /dev/null 2>&1
        rm -rf /opt/mhs/etc/mhs/.tcrypt 1> /dev/null 2>&1
        rm -rf /opt/mhs/etc/mhs/.tdrive 1> /dev/null 2>&1
        rm -rf /var/mhs/state/uploader.teamdrive 1> /dev/null 2>&1
        rm -rf /var/mhs/state/uploader.public 1> /dev/null 2>&1
        rm -rf /var/mhs/state/uploader.secret 1> /dev/null 2>&1
        ;;
      1)
        clonestart
        ;;
      *)
        keyinputpublic
        ;;
    esac

  fi

  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 rClone - Client ID
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Visit https://github.com/n05urpr1532-MHA-Team/PTS-Team/wiki/Google-OAuth-Keys in order to generate your Client ID!

Ensure that you input the CORRECT Client ID from your current project!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Z] Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  read -r -p '↘️  Client ID | Press [Enter]: ' clientid < /dev/tty
  if [ "$clientid" = "" ]; then keyinput; fi
  if [ "$clientid" = "exit" ]; then clonestart; fi
  keyinputsecret
}

keyinputsecret() {
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 rClone - Secret
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Visit https://github.com/n05urpr1532-MHA-Team/PTS-Team/wiki/Google-OAuth-Keys in order to generate your Secret!

Ensure thatyou input the CORRECT Secret ID from your current project!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Z] Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  read -r -p '↘️  Secret ID | Press [Enter]: ' secretid < /dev/tty
  if [ "$secretid" = "" ]; then keyinputsecret; fi
  if [ "$secretid" = "exit" ]; then clonestart; fi

  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 rClone - Output
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CLIENT ID
$clientid

SECRET ID
$secretid

Is the following information correct?
[1] Yes
[2] No

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Z] Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  read -r -p '↘️  Input Information | Press [Enter]: ' typed < /dev/tty

  case $typed in
    1)
      echo "$clientid" > /var/mhs/state/uploader.public
      echo "$secretid" > /var/mhs/state/uploader.secret
      echo
      echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      read -r -p '↘️  Information Stored | Press [Enter] ' secretid < /dev/tty
      echo "SET" > /var/mhs/state/uploader.id
      ;;
    2)
      echo
      echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      read -r -p '↘️  Restarting Process | Press [Enter] ' secretid < /dev/tty
      keyinputpublic
      ;;
    z)
      echo
      echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      read -r -p '↘️  Nothing Saved! Exiting! | Press [Enter] ' secretid < /dev/tty
      ;;
    Z)
      echo
      echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      read -r -p '↘️  Nothing Saved! Exiting! | Press [Enter] ' secretid < /dev/tty
      ;;
    *)
      clonestart
      ;;
  esac
  clonestart
}

publicsecretchecker() {
  uploadervars
  if [[ "$uploaderid" == "NOT-SET" ]]; then

    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 Fail Notice
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💬  Public & Secret Key - NOT SET!

NOTE: Nothing can occur unless the public & secret key are set!
Without setting them; MHS cannot create keys, or create rclone configurations
to mount the required drives!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    read -r -p '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
    clonestart
  fi
}
