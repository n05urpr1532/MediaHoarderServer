#!/usr/bin/env bash

defaultvars() {
  touch /var/mhs/state/rclone.gdrive
  touch /var/mhs/state/rclone.gcrypt
}

# FOR START DEPLOYMENT END #####################################################

deploygcryptcheck() {
  type=gcrypt
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
  rclone mkdir --config /opt/mhs/etc/rclone/rclone.conf $type:/mhs
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Checking Existance of $type:/mhs
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  rcheck=$(rclone lsd --config /opt/mhs/etc/rclone/rclone.conf $type: | grep -oP mhs | head -n1)

  if [ "$rcheck" != "mhs" ]; then
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔  System Message: Validation Checks Failed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

TIPS:
[ 1. ] Did you set up your gcrypt accordingly to the wiki?

[ 2. ] Did you ensure that the gcrypt overlapped on gdrive per the wiki?

EOF
    read -p '↘️  Acknowledge Info | Press [ENTER] ' typed2 < /dev/tty
    question1
  else
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Validation Checks Passed - $type
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  fi
}

deploygdrivecheck() {
  type=gdrive
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
  rclone mkdir --config /opt/mhs/etc/rclone/rclone.conf $type:/mhs
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Checking Existance of $type:/mhs
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  rcheck=$(rclone lsd --config /opt/mhs/etc/rclone/rclone.conf $type: | grep -oP mhs | head -n1)

  if [ "$rcheck" != "mhs" ]; then
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔  System Message: Validation Checks Failed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

TIPS:
[ 1. ] Did you set up your $type accordingly to the wiki?

EOF
    read -p '↘️  Acknowledge Info | Press [ENTER] ' typed2 < /dev/tty
    question1
  else
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Validation Checks Passed - $type
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  fi
}

deploytdrivecheck() {
  type=tdrive
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
  rclone mkdir --config /opt/mhs/etc/rclone/rclone.conf $type:/mhs
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Checking Existance of $type:/mhs
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  rcheck=$(rclone lsd --config /opt/mhs/etc/rclone/rclone.conf $type: | grep -oP mhs | head -n1)

  if [ "$rcheck" != "mhs" ]; then
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔  System Message: Validation Checks Failed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

TIPS:
[ 1. ] Did you set up your $type accordingly to the wiki?

EOF
    read -p '↘️  Acknowledge Info | Press [ENTER] ' typed2 < /dev/tty
    question1
  else
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Validation Checks Passed - $type
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  fi
}

deploygdsa01check() {
  type=GDSA01
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
  rclone mkdir --config /opt/mhs/etc/rclone/rclone.conf $type:/mhs
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Checking Existance of $type:/mhs
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  rcheck=$(rclone lsd --config /opt/mhs/etc/rclone/rclone.conf $type: | grep -oP mhs | head -n1)

  if [ "$rcheck" != "mhs" ]; then
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔  System Message: Validation Checks Failed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

TIPS:
[ 1. ] Did you set up your keys and share out your emails per the blitz wiki?

EOF
    read -p '↘️  Acknowledge Info | Press [ENTER] ' typed2 < /dev/tty
    question1
  else
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Validation Checks Passed - $type
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  fi
}
# FOR FINAL DEPLOYMENT END #####################################################

tdrivecheck() {
  type=tdrive
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
  rclone mkdir --config /opt/mhs/etc/rclone/rclone.conf $type:/mhs
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Checking Existance of $type:/mhs
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  rcheck=$(rclone lsd --config /opt/mhs/etc/rclone/rclone.conf $type: | grep -oP mhs | head -n1)

  if [ "$rcheck" != "mhs" ]; then
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔  System Message: Validation Checks Failed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

TIPS:
[ 1. ] Did you copy your username and password correctly?
[ 2. ] When you created the credentials, did you select "Other"?
[ 3. ] Did you enable your API?

EOF
    echo "Not Active" > /var/mhs/state/gdrive.uploader
    read -p '↘️  Acknowledge Info | Press [ENTER] ' typed2 < /dev/tty
    question1
  else
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Validation Checks Passed - $type
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  fi
  read -p '↘️  Acknowledge Info | Press [ENTER] ' typed2 < /dev/tty
  EOF
}

deletekeys2() {
  choicedel=$(cat /var/mhs/state/gdsa.cut)
  if [ "$choicedel" != "" ]; then
    echo ""
    echo "Deleting All Previous Service Accounts & Keys!"
    echo ""

    while read p; do
      gcloud iam service-accounts delete $p --quiet
    done < /var/mhs/state/gdsa.cut

    rm -rf /opt/mhs/etc/rclone/keys/processed/* 1> /dev/null 2>&1
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 SYSTEM MESSAGE: Prior Service Accounts & Keys Deleted
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    sleep 2
    keymenu
  else
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 SYSTEM MESSAGE: No Prior Service Accounts or Keys!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    sleep 2
  fi
  question1
}

deletekeys() {
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 ID: Key Gen Information
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  gcloud iam service-accounts list --filter="GDSA" > /var/mhs/state/gdsa.list
  cat /var/mhs/state/gdsa.list | awk '{print $2}' | tail -n +2 > /var/mhs/state/gdsa.cut
  cat /var/mhs/state/gdsa.cut
  tee <<- EOF

Items listed are all service accounts that have been created! Proceeding
onward will destroy all service accounts and current keys!

EOF
  read -p '🌍 Proceed? y or n | Press [ENTER]: ' typed < /dev/tty

  if [[ "$typed" == "Y" || "$typed" == "y" ]]; then
    deletekeys2
  elif [[ "$typed" == "N" || "$typed" == "n" ]]; then
    question1
  else
    badinput
    deletekeys
  fi
}
gdsabuild() {
  ## what sets if encrypted is on or not
  downloadpath=$(cat /var/mhs/state/server.hd.path)
  tempbuild=$(cat /var/mhs/state/json.tempbuild)
  path=/opt/mhs/etc/rclone/keys
  rpath=/opt/mhs/etc/rclone/rclone.conf
  tdrive=$(cat /opt/mhs/etc/rclone/rclone.conf | grep team_drive | head -n1)
  tdrive="${tdrive:13}"

  if [[ "$(cat /var/mhs/state/uploader.transport)" == "be" ]]; then
    # PASSWORD=$(cat /var/mhs/state/uploader.password)
    # SALT=$(cat /var/mhs/state/uploader.salt)
    ENC_PASSWORD=$(rclone obscure "$(cat /var/mhs/state/uploader.password)")
    ENC_SALT=$(rclone obscure "$(cat /var/mhs/state/uploader.salt)")

    mkdir -p $downloadpath/move/$tempbuild
    echo "" >> $rpath
    echo "[$tempbuild]" >> $rpath
    echo "type = drive" >> $rpath
    echo "client_id =" >> $rpath
    echo "client_secret =" >> $rpath
    echo "scope = drive" >> $rpath
    echo "root_folder_id =" >> $rpath
    echo "service_account_file = /opt/mhs/etc/rclone/keys/processed/$tempbuild" >> $rpath
    echo "team_drive = $tdrive" >> $rpath

    echo "" >> $rpath
    echo "[${tempbuild}C]" >> $rpath
    echo "type = crypt" >> $rpath
    echo "remote = $tempbuild:/encrypt" >> $rpath
    echo "filename_encryption = standard" >> $rpath
    echo "directory_name_encryption = true" >> $rpath
    echo "password = $ENC_PASSWORD" >> $rpath
    echo "password2 = $ENC_SALT" >> $rpath
  fi

  if [[ "$(cat /var/mhs/state/uploader.transport)" == "bu" ]]; then
    ####tempbuild is need in order to call the correct gdsa
    mkdir -p $downloadpath/move/$tempbuild
    echo "" >> $rpath
    echo "[$tempbuild]" >> $rpath
    echo "type = drive" >> $rpath
    echo "client_id =" >> $rpath
    echo "client_secret =" >> $rpath
    echo "scope = drive" >> $rpath
    echo "root_folder_id =" >> $rpath
    echo "service_account_file = /opt/mhs/etc/rclone/keys/processed/$tempbuild" >> $rpath
    echo "team_drive = $tdrive" >> $rpath
  fi

}
deploykeys3() {
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

Possible $keysposscount before you hit the 100 SAC's

NOTE 1: Creating more keys DOES NOT SPEED up your transfers
NOTE 2: Realistic key generation for most are 6 - 8 keys
NOTE 3: 20 Keys are only for GCE Feeder !!
NOTE 4: maximum of SAC is 100 , remove unused keys !!

💬 # of Keys Generated Sets Your Daily Upload Limit!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -p '↘️  Type a Number [ 1 thru 20 ] | Press [ENTER]: ' typed < /dev/tty

  num=$typed
  echo ""
  if [[ "$typed" -le "0" || "$typed" -ge "21" ]]; then
    echo "Creating $typed Keys" && keys=$typed
  fi
  sleep 2
  echo ""

  if [[ "$typed" -le "0" || "$typed" -ge "51" ]]; then deploykeys3; fi

  num=$keys
  count=0
  project=$(cat /var/mhs/state/uploader.project)

  ##wipe previous keys stuck there
  mkdir -p /opt/mhs/etc/rclone/keys/processed/
  rm -rf /opt/mhs/etc/rclone/keys/processed/* 1> /dev/null 2>&1

  ## purpose of the rewrite is to save gdrive and tdrive info and toss old GDSAs
  cat /opt/mhs/etc/rclone/rclone.conf | grep -w "\[tdrive\]" -A 5 > /opt/mhs/etc/mhs/tdrive.info
  cat /opt/mhs/etc/rclone/rclone.conf | grep -w "\[gdrive\]" -A 4 > /opt/mhs/etc/mhs/gdrive.info
  cat /opt/mhs/etc/rclone/rclone.conf | grep -w "\[tcrypt\]" -A 6 > /opt/mhs/etc/mhs/tcrypt.info
  cat /opt/mhs/etc/rclone/rclone.conf | grep -w "\[gcrypt\]" -A 6 > /opt/mhs/etc/mhs/gcrypt.info

  echo "#### rclone rewrite generated by MHS" > /opt/mhs/etc/rclone/rclone.conf
  echo "" >> /opt/mhs/etc/rclone/rclone.conf
  echo "" >> /opt/mhs/etc/rclone/rclone.conf
  cat /opt/mhs/etc/mhs/gdrive.info >> /opt/mhs/etc/rclone/rclone.conf
  echo "" >> /opt/mhs/etc/rclone/rclone.conf
  cat /opt/mhs/etc/mhs/tdrive.info >> /opt/mhs/etc/rclone/rclone.conf
  echo "" >> /opt/mhs/etc/rclone/rclone.conf
  cat /opt/mhs/etc/mhs/tcrypt.info >> /opt/mhs/etc/rclone/rclone.conf
  echo "" >> /opt/mhs/etc/rclone/rclone.conf
  cat /opt/mhs/etc/mhs/gcrypt.info >> /opt/mhs/etc/rclone/rclone.conf

  while [ "$count" != "$keys" ]; do
    ((count++))
    rand=$(echo $((1 + RANDOM * RANDOM)))

    if [ "$count" -ge 1 -a "$count" -le 9 ]; then
      gcloud iam service-accounts create gdsa$rand --display-name “gdsa0$count”
      gcloud iam service-accounts keys create /opt/mhs/etc/rclone/keys/processed/gdsa0$count --iam-account gdsa$rand@$project.iam.gserviceaccount.com --key-file-type="json"
      echo "gdsa0$count" > /var/mhs/state/json.tempbuild
      gdsabuild
      echo ""
    else
      gcloud iam service-accounts create gdsa$rand --display-name “gdsa$count”
      gcloud iam service-accounts keys create /opt/mhs/etc/rclone/keys/processed/gdsa$count --iam-account gdsa$rand@$project.iam.gserviceaccount.com --key-file-type="json"
      echo "gdsa$count" > /var/mhs/state/json.tempbuild
      gdsabuild
      echo ""
    fi
  done

  echo "no" > /var/mhs/state/project.deployed

  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 SYSTEM MESSAGE: Key Generation Complete!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💬 Use the E-Mail Generator Next! Do Not Forget!

EOF
  read -p '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
}

deploykeys2() {
  deploykeys3
}

deploykeys() {
  gcloud iam service-accounts list --filter="gdsa" > /var/mhs/state/gdsa.list
  cat /var/mhs/state/gdsa.list | awk '{print $2}' | tail -n +2 > /var/mhs/state/gdsa.cut
  deploykeys2
}

projectid() {
  # gcloud projects list >/var/mhs/state/projects.list
  gcloud projects list | cut -d' ' -f1 | tail -n +2 > /var/mhs/state/project.cut
  projectlist=$(gcloud projects list | cut -d' ' -f1 | tail -n +2)
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Projects Interface Menu
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$projectlist

EOF

  read -p '↘️  Type EXACT Project Name to Utilize | Press [ENTER]: ' typed2 < /dev/tty
  list=$(cat /var/mhs/state/project.cut | grep $typed2)
  if [ "$list" == "" ]; then
    badinput && projectid
  fi
  gcloud config set project $typed2
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Standby - Enabling Your API
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  gcloud services enable drive.googleapis.com --project $typed2
  echo $typed2 > /var/mhs/state/project.final
  echo
  read -p '🌍 Process Complete | Press [ENTER] ' typed2 < /dev/tty

}

ufsbuilder() {
  downloadpath=$(cat /var/mhs/state/server.hd.path)
  ls -la /opt/mhs/etc/rclone/keys/processed | awk '{ print $9}' | tail -n +4 > /tmp/pg.gdsa.ufs
  rm -rf /tmp/pg.gdsa.build 1> /dev/null 2>&1

  encryption="off"
  ##### Encryption Portion ### END
  file="/var/mhs/state/unionfs.pgpath"
  if [ -e "$file" ]; then rm -rf /var/mhs/state/unionfs.pgpath && touch /var/mhs/state/unionfs.pgpath; fi

  while read p; do
    mkdir -p $downloadpath/move/$p
    echo -n "$downloadpath/move/$p=RO:" >> /var/mhs/state/unionfs.pgpath
  done < /tmp/pg.gdsa.ufs
  builder=$(cat /var/mhs/state/unionfs.pgpath)
}

blitzchecker() {
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Conducting RClone Validation Checks
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  sleep 1
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Creating Test Directory - GDSA01:/mhs
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  sleep 1
  rclone mkdir --config /opt/mhs/etc/rclone/rclone.conf GDSA01:/mhs
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Checking Existance of GDSA01:/mhs
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  rcheck=$(rclone lsd --config /opt/mhs/etc/rclone/rclone.conf GDSA01: | grep -oP mhs | head -n1)

  if [ "$rcheck" != "mhs" ]; then
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: RClone Validation Check Failed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

TIPS:
1. Did you share out your emails to your teamdrives?

EOF
    read -p '↘️  Acknowledge Info | Press [ENTER] ' typed2 < /dev/tty
    question1
  fi
}

rchecker() {
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Conducting RClone Validation Checks
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  sleep 1
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Creating Test Directory - tdrive:/mhs
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  sleep 1
  rclone mkdir --config /opt/mhs/etc/rclone/rclone.conf tdrive:/mhs
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Checking Existance of tdrive:/mhs
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  rcheck=$(rclone lsd --config /opt/mhs/etc/rclone/rclone.conf tdrive: | grep -oP mhs | head -n1)

  if [ "$rcheck" != "mhs" ]; then
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: RClone Validation Check Failed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

TIPS:
1. Did you set your tdrive correctly along with your teamdrive?

EOF
    rchecker=fail
    read -p '↘️  Acknowledge Info | Press [ENTER] ' typed2 < /dev/tty
    question1
  fi
}

pgbdeploy() {
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Blitz Deployed!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -p '↘️  Acknowledge Info | Press [ENTER] ' typed2 < /dev/tty
}

keymenu() {
  gcloud info | grep Account: | cut -c 10- > /var/mhs/state/project.account
  account=$(cat /var/mhs/state/project.account)
  project=$(cat /var/mhs/state/uploader.project)

  if [ "$account" == "NOT-SET" ]; then
    display5="[NOT-SET]"
  else
    display5="$account"
  fi

  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Blitz Key Generation
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] Google Account Login: [ $display5 ]
[2] Project Options     : [ $project ]
[3] Create Service Keys
[4] EMail Generator

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[A] Backup  Keys
[C] Destory All Prior Service Accounts
[Z] Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  read -p '↘️  Type Choice | Press [ENTER]: ' typed < /dev/tty

  if [ "$typed" == "1" ]; then
    gcloud auth login
    gcloud info | grep Account: | cut -c 10- > /var/mhs/state/project.account
    account=$(cat /var/mhs/state/project.account)
    keymenu
  elif [ "$typed" == "2" ]; then
    projectmenu
    keymenu
  elif [ "$typed" == "3" ]; then
    rchecker
    if [ $rchecker=fail ]; then
      deploykeys
      keymenu
    fi
  elif [ "$typed" == "4" ]; then
    bash /opt/mhs/lib/uploader/emails.sh && echo
    read -p '↘️  Confirm Info | Press [ENTER]: ' typed < /dev/tty
    keymenu
  elif [[ "$typed" == "Z" || "$typed" == "z" ]]; then
    question1
  elif [[ "$typed" == "C" || "$typed" == "c" ]]; then
    deletekeys
    keymenu
  elif [[ "$typed" == "A" || "$typed" == "a" ]]; then
    keybackup
    keymenu
  else
    badinput
    keymenu
  fi
}
