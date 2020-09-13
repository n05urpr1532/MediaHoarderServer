#!/usr/bin/env bash

deploypgblitz() {
  deployblitzstartcheck # At Bottom - Ensure Keys Are Made

  # RCLONE BUILD
  echo "#------------------------------------------" > /opt/mhs/etc/rclone/rclone.conf
  echo "# rClone.config created over rclone " >> /opt/mhs/etc/rclone/rclone.conf
  echo "#------------------------------------------" >> /opt/mhs/etc/rclone/rclone.conf

  cat /opt/mhs/etc/mhs/.gdrive >> /opt/mhs/etc/rclone/rclone.conf

  if [[ $(cat "/opt/mhs/etc/mhs/.gcrypt") != "NOT-SET" ]]; then
    echo ""
    cat /opt/mhs/etc/mhs/.gcrypt >> /opt/mhs/etc/rclone/rclone.conf
  fi

  cat /opt/mhs/etc/mhs/.tdrive >> /opt/mhs/etc/rclone/rclone.conf

  if [[ $(cat "/opt/mhs/etc/mhs/.tcrypt") != "NOT-SET" ]]; then
    echo ""
    cat /opt/mhs/etc/mhs/.tcrypt >> /opt/mhs/etc/rclone/rclone.conf
  fi

  cat /opt/mhs/etc/mhs/.keys >> /opt/mhs/etc/rclone/rclone.conf

  deploydrives
}

deploypgmove() {
  # RCLONE BUILD
  echo "#------------------------------------------" > /opt/mhs/etc/rclone/rclone.conf
  echo "# rClone.config created over rclone" >> /opt/mhs/etc/rclone/rclone.conf
  echo "#------------------------------------------" >> /opt/mhs/etc/rclone/rclone.conf

  cat /opt/mhs/etc/mhs/.gdrive > /opt/mhs/etc/rclone/rclone.conf

  if [[ $(cat "/opt/mhs/etc/mhs/.gcrypt") != "NOT-SET" ]]; then
    echo ""
    cat /opt/mhs/etc/mhs/.gcrypt >> /opt/mhs/etc/rclone/rclone.conf
  fi
  deploydrives
}
### Docker Uploader Deploy start ##
deploydockeruploader() {
  rcc=/opt/mhs/etc/rclone/rclone.conf
  if [[ ! -f "$rcc" ]]; then
    nounionrunning
  else deploydocker; fi
}
nounionrunning() {
  rcc=/opt/mhs/etc/rclone/rclone.conf
  if [[ ! -f "$rcc" ]]; then
    tee <<- EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔ Fail Notice for deploy of Docker Uploader
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 Sorry we can't  Deploy the Docker Uploader.
 No mounts are running , please deploy first the mounts.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔ Fail Notice for deploy of Docker Uploader
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
    read -rp '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
    clonestart
  fi
}
deploydocker() {
  upper=$(docker ps --format '{{.Names}}' | grep "uploader")
  if [[ "$upper" != "uploader" ]]; then
    dduploader
  else ddredeploy; fi
}
dduploader() {
  tee <<- EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
	🚀      Deploy of Docker Uploader
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
	EOF
  cleanlogs
  ansible-playbook /opt/mhs/lib/uploader/ymls/uploader.yml
  read -rp '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
	💪     DEPLOYED sucessfully !
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     The Uploader is under
     https://uploader.${domain}
     or
     http://${ip}:7777
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  read -p '↘️  Acknowledge Info | Press [ENTER] ' typed2 < /dev/tty
  clonestart
}
ddredeploy() {
  tee <<- EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
	🚀      Redeploy of Docker Uploader
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
	EOF
  read -rp '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
  cleanlogs
  ansible-playbook /opt/mhs/lib/uploader/ymls/uploader.yml
  sleep 10
  domain=$(cat /var/mhs/state/server.domain)
  ip=$(cat /var/mhs/state/server.ip)
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
	💪     DEPLOYED sucessfully !
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     The Uploader is under
     https://uploader.${domain}
     or
     http://${ip}:7777
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  read -p '↘️  Acknowledge Info | Press [ENTER] ' typed2 < /dev/tty
  clonestart
}
### Docker Uploader Deploy end ##

deploydrives() {
  fail=0
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Conducting RClone Mount Checks
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  if [ -e "/var/mhs/state/.drivelog" ]; then rm -rf /var/mhs/state/.drivelog; fi
  touch /var/mhs/state/.drivelog
  transport=$(cat /var/mhs/state/uploader.transport)

  if [[ "$transport" == "mu" ]]; then
    gdrivemod
    multihdreadonly
    agreebase
  elif [[ "$transport" == "me" ]]; then
    gdrivemod
    gcryptmod
    multihdreadonly
    agreebasecrypt
  elif [[ "$transport" == "bu" ]]; then
    gdrivemod
    tdrivemod
    gdsamod
    multihdreadonly
    agreebase
  elif [[ "$transport" == "be" ]]; then
    gdrivemod
    tdrivemod
    gdsamod
    gcryptmod
    tcryptmod
    gdsacryptmod
    multihdreadonly
    agreebasecrypt
  fi

  cat /var/mhs/state/.drivelog
  logcheck=$(cat /var/mhs/state/.drivelog | grep "Failed")

  if [[ "$logcheck" == "" ]]; then

    if [[ "$transport" == "mu" || "$transport" == "me" ]]; then executemove; fi
    if [[ "$transport" == "bu" || "$transport" == "be" ]]; then executeblitz; fi

  else

    if [[ "$transport" == "me" || "$transport" == "be" ]]; then
      emessage="
  NOTE1: User forgot to share out GDSA E-Mail to Team Drive
  NOTE2: Conducted a blitz key restore and keys are no longer valid
  "
    fi

    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 RClone Mount Checks - Failed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CANNOT DEPLOY!

POSSIBLE REASONS:
1. GSuite Account is no longer valid or suspended
2. Client ID and/or Secret are invalid and/or no longer exist
$emessage
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    read -p '↘️  Acknowledge Info | Press [ENTER] ' typed2 < /dev/tty
    clonestart
  fi
}

########################################################################################
timer() {
  seconds=90
  date1=$(($(date +%s) + $seconds))
  while [ "$date1" -ge $(date +%s) ]; do
    echo -ne "$(date -u --date @$(($date1 - $(date +%s))) +%H:%M:%S)\r"
  done
}

agreebase() {
  tee <<- EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
               ⛔️ READ THIS NOTE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

                ⚠ Warning
Be aware that transferring more than 750GB/day
with less than 5 users will increase your risk
of data deletion by Google.

We do not condone or support users of Education accounts.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  timer
  doneokay
}
agreebasecrypt() {

  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
               ⛔️ READ THIS NOTE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

                ⚠ Warning

Be aware that transferring more than 750GB/day
with less than 5 users will increase your risk
of data deletion by Google. Please do not use
encryption for media as this will place your
data at risk of deletion by Google as they do not
condone encrypting content placed on Google Drive.
This data is already encrypted behind your Google
credentials and encrypting further has no benefit.

We do not condone or support users of
this service whom are using Education accounts.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  timer
  doneokay
}
doneokay() {
  echo
  read -p 'Confirm Info | PRESS [ENTER] ' typed < /dev/tty
}
gdrivemod() {
  initial=$(rclone lsd --config /opt/mhs/etc/rclone/rclone.conf gdrive: | grep -oP mhs | head -n1)

  if [[ "$initial" != "mhs" ]]; then
    rclone mkdir --config /opt/mhs/etc/rclone/rclone.conf gdrive:/mhs
    initial=$(rclone lsd --config /opt/mhs/etc/rclone/rclone.conf gdrive: | grep -oP mhs | head -n1)
  fi

  if [[ "$initial" == "mhs" ]]; then echo "GDRIVE :  Passed" >> /var/mhs/state/.drivelog; else echo "GDRIVE :  Failed" >> /var/mhs/state/.drivelog; fi
}
tdrivemod() {
  initial=$(rclone lsd --config /opt/mhs/etc/rclone/rclone.conf tdrive: | grep -oP mhs | head -n1)

  if [[ "tinitial" != "mhs" ]]; then
    rclone mkdir --config /opt/mhs/etc/rclone/rclone.conf gdrive:/mhs
    initial=$(rclone lsd --config /opt/mhs/etc/rclone/rclone.conf tdrive: | grep -oP mhs | head -n1)
  fi

  if [[ "$initial" == "mhs" ]]; then echo "TDRIVE :  Passed" >> /var/mhs/state/.drivelog; else echo "TDRIVE :  Failed" >> /var/mhs/state/.drivelog; fi
}
gcryptmod() {
  c1initial=$(rclone lsd --config /opt/mhs/etc/rclone/rclone.conf gdrive: | grep -oP encrypt | head -n1)
  c2initial=$(rclone lsd --config /opt/mhs/etc/rclone/rclone.conf gcrypt: | grep -oP mhs | head -n1)

  if [[ "$c1initial" != "encrypt" ]]; then
    rclone mkdir --config /opt/mhs/etc/rclone/rclone.conf gdrive:/encrypt
    c1initial=$(rclone lsd --config /opt/mhs/etc/rclone/rclone.conf gdrive: | grep -oP encrypt | head -n1)
  fi
  if [[ "$c2initial" != "mhs" ]]; then
    rclone mkdir --config /opt/mhs/etc/rclone/rclone.conf gcrypt:/mhs
    c2initial=$(rclone lsd --config /opt/mhs/etc/rclone/rclone.conf gcrypt: | grep -oP mhs | head -n1)
  fi

  if [[ "$c1initial" == "encrypt" ]]; then echo "GCRYPT1:  Passed" >> /var/mhs/state/.drivelog; else echo "GCRYPT1:  Failed" >> /var/mhs/state/.drivelog; fi
  if [[ "$c2initial" == "mhs" ]]; then echo "GCRYPT2:  Passed" >> /var/mhs/state/.drivelog; else echo "GCRYPT2:  Failed" >> /var/mhs/state/.drivelog; fi
}
tcryptmod() {
  c1initial=$(rclone lsd --config /opt/mhs/etc/rclone/rclone.conf tdrive: | grep -oP encrypt | head -n1)
  c2initial=$(rclone lsd --config /opt/mhs/etc/rclone/rclone.conf tcrypt: | grep -oP mhs | head -n1)

  if [[ "$c1initial" != "encrypt" ]]; then
    rclone mkdir --config /opt/mhs/etc/rclone/rclone.conf tdrive:/encrypt
    c1initial=$(rclone lsd --config /opt/mhs/etc/rclone/rclone.conf tdrive: | grep -oP encrypt | head -n1)
  fi
  if [[ "$c2initial" != "mhs" ]]; then
    rclone mkdir --config /opt/mhs/etc/rclone/rclone.conf tcrypt:/mhs
    c2initial=$(rclone lsd --config /opt/mhs/etc/rclone/rclone.conf tcrypt: | grep -oP mhs | head -n1)
  fi

  if [[ "$c1initial" == "encrypt" ]]; then echo "TCRYPT1:  Passed" >> /var/mhs/state/.drivelog; else echo "TCRYPT1:  Failed" >> /var/mhs/state/.drivelog; fi
  if [[ "$c2initial" == "mhs" ]]; then echo "TCRYPT2:  Passed" >> /var/mhs/state/.drivelog; else echo "TCRYPT2:  Failed" >> /var/mhs/state/.drivelog; fi
}

gdsamod() {
  initial=$(rclone lsd --config /opt/mhs/etc/rclone/rclone.conf GDSA01: | grep -oP mhs | head -n1)

  if [[ "$initial" != "mhs" ]]; then
    rclone mkdir --config /opt/mhs/etc/rclone/rclone.conf GDSA01:/mhs
    initial=$(rclone lsd --config /opt/mhs/etc/rclone/rclone.conf GDSA01: | grep -oP mhs | head -n1)
  fi

  if [[ "$initial" == "mhs" ]]; then echo "GDSA01 :  Passed" >> /var/mhs/state/.drivelog; else echo "GDSA01 :  Failed" >> /var/mhs/state/.drivelog; fi
}

gdsacryptmod() {
  initial=$(rclone lsd --config /opt/mhs/etc/rclone/rclone.conf GDSA01C: | grep -oP encrypt | head -n1)

  if [[ "$initial" != "mhs" ]]; then
    rclone mkdir --config /opt/mhs/etc/rclone/rclone.conf GDSA01C:/mhs
    initial=$(rclone lsd --config /opt/mhs/etc/rclone/rclone.conf GDSA01C: | grep -oP mhs | head -n1)
  fi

  if [[ "$initial" == "mhs" ]]; then echo "GDSA01C:  Passed" >> /var/mhs/state/.drivelog; else echo "GDSA01C:  Failed" >> /var/mhs/state/.drivelog; fi
}
################################################################################
deployblitzstartcheck() {

  uploadervars
  if [[ "$displaykey" == "0" ]]; then
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔ Fail Notice
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💬  There are [0] keys generated for Blitz! Create those first!

NOTE:

Without any keys, Blitz cannot upload any data without the use
of service accounts

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

    read -p '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
    clonestart
  fi
}
################################################################################
cleanlogs() {
  echo "Prune service logs..."
  journalctl --flush
  journalctl --rotate
  journalctl --vacuum-time=1s
  truncate -s 0 /var/mhs/log/*.log
}

prunedocker() {
  echo "Prune docker images and volumes..."
  docker system prune --volumes -f
}
################################################################################
createmountfolders() {
  mkdir -p /mnt/{gdrive,tdrive,gcrypt,tcrypt}
  chown -R 1000:1000 /mnt/{gdrive,tdrive,gcrypt,tcrypt} > /dev/null
  chmod -R 755 /mnt/{gdrive,tdrive,gcrypt,tcrypt} > /dev/null
}

cleanmounts() {
  echo "Unmount drives..."
  fusermount -uzq /mnt/gdrive > /dev/null
  fusermount -uzq /mnt/tdrive > /dev/null
  fusermount -uzq /mnt/gcrypt > /dev/null
  fusermount -uzq /mnt/tcrypt > /dev/null
  fusermount -uzq /mnt/unionfs > /dev/null
  pkill -f rclone* > /dev/null

  echo "checking for empty mounts..."

  mount="/mnt/unionfs/"
  cleanmount

  mount="/mnt/gdrive/"
  cleanmount

  mount="/mnt/tdrive/"
  cleanmount

  mount="/mnt/gcrypt/"
  cleanmount

  mount="/mnt/tcrypt/"
  cleanmount

}

cleanmount() {
  maxsize=1000000

  if [ -d "$mount" ]; then
    echo "Checking if $mount is not empty when unmounted..."
    if [[ "$(ls -a "$mount" | wc -l)" -ne 2 && "$(ls -a "$mount" | wc -l)" -ne 0 ]]; then

      if [[ "$(du -s "$mount" | cut -f1 | bc -l | rev | cut -c 2- | rev)" -lt $maxsize ]]; then
        echo "$mount is not empty when unmounted, fixing..."
        rsync -aq "$mount" /mnt/move/
        rm -rf "$mount"*
      else
        failclean
      fi
    fi
  fi
}

failclean() {
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔ Failure during $mount unmount
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

There was a problem unmounting $mount.
Please reboot your server and try to redeploy Uploader again.
If this problem persists after a reboot, join
discord and ask for help.

⚠ Warning:

Your apps have been stopped to prevent data loss.
Please reboot and redepoy Uploader to fix.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -p '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty

  exit
}

restartapps() {
  echo "restarting apps..."
  docker restart $(docker ps -a -q) > /dev/null
}

deployFail() {
  # output final display

  if [[ "$transport" == "bu" ]]; then
    finaldeployoutput="Blitz"
  fi
  if [[ "$transport" == "be" ]]; then
    finaldeployoutput="Blitz: Encrypted"
  fi

  if [[ "$transport" == "mu" ]]; then
    finaldeployoutput="Move"
  fi
  if [[ "$transport" == "me" ]]; then
    finaldeployoutput="Move: Encrypted"
  fi

  erroroutput="$(journalctl -u gdrive -u gcrypt -u pgunion -u pgmove -b -q -p 6 --no-tail -e --no-pager --since "5 minutes ago" -n 20)"
  logoutput="$(tail -n 20 /var/mhs/log/*.log)"
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔ DEPLOY FAILED: $finaldeployoutput
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

An error has occurred when deploying Uploader.
Your apps are currently stopped to prevent data loss.

Things to try:
If you just finished the initial setup, you likely made a typo
or other error when configuring Uploader.
Please redo the Uploader config first before reporting an issue.

If this issue still persists:
Please share this error on discord or the forums before proceeding.

If there error says the mount is not empty, then you need to reboot your
server and redeploy Uploader to fix.

Error details:
$erroroutput
$logoutput

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔ DEPLOY FAILED: $finaldeployoutput
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -rp '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
  exit

}
deploySuccess() {
  domain=$(cat /var/mhs/state/server.domain)
  ip=$(cat /var/mhs/state/server.ip)
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💪 DEPLOYED: $finaldeployoutput
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Uploader has been deployed sucessfully!
All services are active and running normally.

The Uploader is under

     https://uploader.${domain}

     or

     http://${ip}:7777

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  read -rp '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
}

buildrcloneenv() {
  uagent="$(cat /var/mhs/state/uagent)"
  vfs_ll="$(cat /var/mhs/state/vfs_ll)"
  vfs_bs="$(cat /var/mhs/state/vfs_bs)"
  vfs_rcs="$(cat /var/mhs/state/vfs_rcs)"
  vfs_rcsl="$(cat /var/mhs/state/vfs_rcsl)"
  vfs_cma="$(cat /var/mhs/state/vfs_cma)"
  vfs_cm="$(cat /var/mhs/state/vfs_cm)"
  vfs_cms="$(cat /var/mhs/state/vfs_cms)"
  vfs_dct="$(cat /var/mhs/state/vfs_dct)"
  vfs_t="$(cat /var/mhs/state/vfs_t)"
  vfs_mt="$(cat /var/mhs/state/vfs_mt)"
  vfs_c="$(cat /var/mhs/state/vfs_c)"

  echo "uagent=$uagent" > /opt/mhs/etc/mhs/rclone.env
  echo "vfs_ll=$vfs_ll" >> /opt/mhs/etc/mhs/rclone.env
  echo "vfs_bs=$vfs_bs" >> /opt/mhs/etc/mhs/rclone.env
  echo "vfs_rcs=$vfs_rcs" >> /opt/mhs/etc/mhs/rclone.env
  echo "vfs_rcsl=$vfs_rcsl" >> /opt/mhs/etc/mhs/rclone.env
  echo "vfs_cm=$vfs_cm" >> /opt/mhs/etc/mhs/rclone.env
  echo "vfs_cma=$vfs_cma" >> /opt/mhs/etc/mhs/rclone.env
  echo "vfs_cms=$vfs_cms" >> /opt/mhs/etc/mhs/rclone.env
  echo "vfs_dct=$vfs_dct" >> /opt/mhs/etc/mhs/rclone.env
  echo "vfs_t=$vfs_t" >> /opt/mhs/etc/mhs/rclone.env
  echo "vfs_mt=$vfs_mt" >> /opt/mhs/etc/mhs/rclone.env
  echo "vfs_c=$vfs_c" >> /opt/mhs/etc/mhs/rclone.env
}
