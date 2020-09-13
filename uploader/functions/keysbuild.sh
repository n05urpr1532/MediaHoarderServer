#!/usr/bin/env bash

keystart() {
  uploadervars

  kread=$(gcloud --account=${uploaderemail} iam service-accounts list | awk '{print $1}' | tail -n +2 | cut -c7- | cut -f1 -d "?" | sort | uniq | head -n 1 > /var/mhs/state/.gcloudposs)
  keyposs=$(cat /var/mhs/state/.gcloudposs)

  FIRSTV=$keyposs
  SECONDV=1
  keysposscount=$(expr $FIRSTV - $SECONDV)
  #echo $keysposscount

  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 SYSTEM MESSAGE: Key Number Selection! (From 2 thru 20 )
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
QUESTION - Create how many keys for Blitz?

MATH:
2  Keys = 1.5 TB Daily | 6  Keys = 4.5 TB Daily
10 Keys = 7.5 TB Daily | 20 Keys = 15  TB Daily

Possible $keysposscount keys to build for $uploaderproject

NOTE 1: Creating more keys DOES NOT SPEED up your transfers
NOTE 2: Realistic key generation for most are 6 - 8 keys
NOTE 3: 20 Keys are only for GCE Feeder !!

💬 # of Keys Generated Sets Your Daily Upload Limit!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -r -p '↘️  Type a Number [ 2 thru 20 ] | Press [ENTER]: ' typed < /dev/tty

  exitclone

  num=$typed
  if [[ "$typed" -ge "1" && "$typed" -le "21" ]]; then
    keyphase2
  else keystart; fi
}

keyphase2() {
  num=$typed

  rm -rf /opt/mhs/etc/mhs/blitzkeys 1> /dev/null 2>&1
  mkdir -p /opt/mhs/etc/mhs/blitzkeys

  cat /opt/mhs/etc/mhs/.gdrive > /opt/mhs/etc/rclone/rclone.conf
  if [ -e "/opt/mhs/etc/mhs/.tdrive" ]; then cat /opt/mhs/etc/mhs/.tdrive >> /opt/mhs/etc/mhs/.keytemp; fi
  if [ -e "/opt/mhs/etc/mhs/.gcrypt" ]; then cat /opt/mhs/etc/mhs/.gcrypt >> /opt/mhs/etc/mhs/.keytemp; fi
  if [ -e "/opt/mhs/etc/mhs/.tcrypt" ]; then cat /opt/mhs/etc/mhs/.tcrypt >> /opt/mhs/etc/mhs/.keytemp; fi

  gcloud --account=${uploaderemail} iam service-accounts list | awk '{print $1}' | tail -n +2 | cut -c2- | cut -f1 -d "?" | sort | uniq > /var/mhs/state/.gcloudblitz

  rm -rf /var/mhs/state/.blitzbuild 1> /dev/null 2>&1
  touch /var/mhs/state/.blitzbuild
  while read p; do
    echo $p > /var/mhs/state/.blitztemp
    blitzcheck=$(grep "blitz" /var/mhs/state/.blitztemp)
    if [[ "$blitzcheck" != "" ]]; then echo $p >> /var/mhs/state/.blitzbuild; fi
  done < /var/mhs/state/.gcloudblitz

  keystotal=$(cat /var/mhs/state/.blitzbuild | wc -l)
  # do a 100 calculation - reminder

  keysleft=$num
  count=0
  gdsacount=0
  gcount=0
  tempbuild=0
  rm -rf /opt/mhs/etc/mhs/.keys 1> /dev/null 2>&1
  touch /opt/mhs/etc/mhs/.keys
  rm -rf /opt/mhs/etc/mhs/.blitzkeys
  mkdir -p /opt/mhs/etc/mhs/.blitzkeys
  echo "" > /opt/mhs/etc/mhs/.keys

  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Key Generator ~ [$num] keys
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  gdsacount() {
    ((gcount++))
    if [[ "$gcount" -ge "1" && "$gcount" -le "9" ]]; then
      tempbuild=0${gcount}
    else tempbuild=$gcount; fi
  }

  keycreate1() {
    #echo $count # for tshoot
    gdsacount
    gcloud --account=${uploaderemail} iam service-accounts create blitz0${count} --display-name “blitz0${count}”
    gcloud --account=${uploaderemail} iam service-accounts keys create /opt/mhs/etc/mhs/.blitzkeys/GDSA${tempbuild} --iam-account blitz0${count}@${uploaderproject}.iam.gserviceaccount.com --key-file-type="json"
    gdsabuild
    if [[ "$gcount" -ge "1" && "$gcount" -le "9" ]]; then
      echo "blitz0${count} is linked to GDSA${tempbuild}"
    else echo "blitz0${count} is linked to GDSA${gcount}"; fi
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    keysleft=$((keysleft - 1))
    flip=on
  }

  keycreate2() {
    #echo $count # for tshoot
    gdsacount
    gcloud --account=${uploaderemail} iam service-accounts create blitz${count} --display-name “blitz${count}”
    gcloud --account=${uploaderemail} iam service-accounts keys create /opt/mhs/etc/mhs/.blitzkeys/GDSA${tempbuild} --iam-account blitz${count}@${uploaderproject}.iam.gserviceaccount.com --key-file-type="json"
    gdsabuild
    if [[ "$gcount" -ge "1" && "$gcount" -le "9" ]]; then
      echo "blitz${count} is linked to GDSA${tempbuild}"
    else echo "blitz${count} is linked to GDSA${gcount}"; fi
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    keysleft=$((keysleft - 1))
    flip=on
  }

  keysmade=0
  while [[ "$keysleft" -gt "0" ]]; do
    flip=off
    while [[ "$flip" == "off" ]]; do
      ((count++))
      if [[ "$count" -ge "1" && "$count" -le "9" ]]; then
        if [[ $(grep "0${count}" /var/mhs/state/.blitzbuild) == "" ]]; then keycreate1; fi
      else
        if [[ $(grep "${count}" /var/mhs/state/.blitzbuild) == "" ]]; then keycreate2; fi
      fi
    done
  done

}

gdsabuild() {
  uploadervars
  ####tempbuild is need in order to call the correct gdsa
  tee >> /opt/mhs/etc/mhs/.keys <<- EOF
[GDSA${tempbuild}]
type = drive
scope = drive
service_account_file = /opt/mhs/etc/mhs/.blitzkeys/GDSA${tempbuild}
team_drive = ${tdid}

EOF

  if [[ "$transport" == "be" ]]; then
    encpassword=$(rclone obscure "${clonepassword}")
    encsalt=$(rclone obscure "${clonesalt}")

    tee >> /opt/mhs/etc/mhs/.keys <<- EOF
[GDSA${tempbuild}C]
type = crypt
remote = GDSA${tempbuild}:/encrypt
filename_encryption = standard
directory_name_encryption = true
password = $encpassword
password2 = $encsalt

EOF

  fi
  #echo "" /opt/mhs/etc/mhs/.keys
}

gdsaemail() {
  tee <<- EOF
EOF

  read -rp '↘️  Process Complete! Ready to Share E-Mails? | Press [ENTER] ' typed < /dev/tty
  emailgen
}

deletekeys() {
  uploadervars
  gcloud --account=${uploaderemail} iam service-accounts list > /var/mhs/state/.deletelistpart1

  if [[ $(cat /var/mhs/state/.deletelistpart1) == "" ]]; then

    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Error! Nothing To Delete!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: No Accounts for Project ~ $uploaderproject
are detected! Exiting!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    read -r -p '↘️  Acknowledge Info! | PRESS [ENTER] ' token < /dev/tty
    clonestart
  fi

  rm -rf /var/mhs/state/.listpart2 1> /dev/null 2>&1
  while read p; do
    echo $p > /var/mhs/state/.listpart1
    writelist=$(grep pg-bumpnono-143619 /var/mhs/state/.listpart1)
    if [[ "$writelist" != "" ]]; then echo $writelist >> /var/mhs/state/.listpart2; fi
  done < /var/mhs/state/.deletelistpart1

  cat /var/mhs/state/.listpart2 | awk '{print $2}' \
    | sort | uniq > /var/mhs/state/.gcloudblitz

  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Keys to Delete?
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  cat /var/mhs/state/.gcloudblitz
  tee <<- EOF

Delete All Keys for Project ~ ${uploaderproject}?

WARNING: If Plex, Emby, and/or JellyFin are using these keys, stop the
containers! Deleting keys in use by this project will result in those
containers losing metadata (due to being unable to access teamdrives)!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  read -r -p '↘️  Type y or n | PRESS [ENTER]: ' typed < /dev/tty
  case $typed in
    y) yesdeletekeys ;;
    Y) yesdeletekeys ;;
    N) clonestart ;;
    n) clonestart ;;
    *) deletekeys ;;
  esac
}

yesdeletekeys() {
  rm -rf /opt/mhs/etc/mhs/.blitzkeys/* 1> /dev/null 2>&1
  echo ""
  while read p; do
    gcloud --account=${uploaderemail} iam service-accounts delete $p --quiet
  done < /var/mhs/state/.gcloudblitz

  echo
  read -r -p '↘️  Process Complete! | PRESS [ENTER]: ' token < /dev/tty
  clonestart
}
