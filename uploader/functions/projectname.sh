#!/usr/bin/env bash

projectname() {
  uploadervars

  ############## REMINDERS
  # Make destroying piece quiet and create a manual delete confirmatino
  # When user creates project, give them the option to switch
  # fix existing set project

  ############## REMINDERS

  # prevents user from moving on unless email is set
  if [[ "$uploaderemail" == "NOT-SET" ]]; then
    echo
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    read -r -p '↘️  ERROR! E-Mail is not setup! | Press [ENTER] ' typed < /dev/tty
    clonestart
  fi

  projectcheck="good"
  if [[ $(gcloud projects list --account=${uploaderemail} | grep "pg-") == "" ]]; then
    projectcheck="bad"
  fi

  # prompt user
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 rClone - Project
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CURRENT PROJECT: $uploaderproject

[1] Project: Use Existing Project
[2] Project: Build New & Set Project
[3] Project: Destroy

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Z] Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -r -p '↘️  Input Value | Press [Enter]: ' typed < /dev/tty

  case $typed in
    1)
      if [[ "$projectcheck" == "bad" ]]; then
        echo "BAD"
        clonestart
      elif [[ "$projectcheck" == "good" ]]; then
        exisitingproject
      fi
      ;;
    2)
      projectnameset
      buildproject
      ;;

    3)
      destroyproject
      ;;
    Z)
      clonestart
      ;;
    z)
      clonestart
      ;;
    *)
      keyinputpublic
      ;;
  esac

}

exisitingproject() {
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 rClone - Existing Project
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  projectlist
  tee <<- EOF

Qutting? Type >>> z or exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -r -p '↘️  Use Which Existing Project? | Press [ENTER]: ' typed < /dev/tty
  if [[ "$typed" == "exit" || "$typed" == "Exit" || "$typed" == "EXIT" || "$typed" == "z" || "$typed" == "Z" ]]; then clonestart; fi

  # Repeats if Users Fails the Range
  if [[ "$typed" -ge "1" && "$typed" -le "$pnum" ]]; then
    existingnumber=$(cat /var/mhs/state/prolist/$typed)

    echo
    gcloud config set project ${existingnumber} --account=${uploaderemail}

    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 rClone - Enabling Your API (Standby)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    gcloud services enable drive.googleapis.com --project ${existingnumber} --account=${uploaderemail}
  else exisitingproject; fi
  echo
  read -r -p '↘️  Existing Project Set | Press [ENTER] ' typed < /dev/tty
  echo "${existingnumber}" > /var/mhs/state/uploader.project
  clonestart
}

destroyproject() {
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 rClone - Destroy Project
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  projectlist
  tee <<- EOF

Qutting? Type >>> z or exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -r -p '↘️  Destroy Which Project? | Press [ENTER]: ' typed < /dev/tty
  if [[ "$typed" == "exit" || "$typed" == "Exit" || "$typed" == "EXIT" || "$typed" == "z" || "$typed" == "Z" ]]; then optionsmenu; fi

  # Repeats if Users Fails the Range
  if [[ "$typed" -ge "1" && "$typed" -le "$pnum" ]]; then
    destroynumber=$(cat /var/mhs/state/prolist/$typed)

    # Cannot Destroy Active Project
    if [[ $(cat /var/mhs/state/uploader.project) == "$destroynumber" ]]; then
      echo
      read -r -p '↘️  Unable to Destroy an Active Project | Press [ENTER] ' typed < /dev/tty
      destroyproject
    fi

    echo
    gcloud projects delete ${destroynumber} --account=${uploaderemail}
  else destroyproject; fi
  echo
  read -r -p '↘️  Project Deleted | Press [ENTER] ' typed < /dev/tty
  optionsmenu
}

projectlist() {
  pnum=0
  mkdir -p /var/mhs/state/prolist
  rm -rf /var/mhs/state/prolist/* 1> /dev/null 2>&1

  gcloud projects list --account=${uploaderemail} | tail -n +2 | awk '{print $1}' > /var/mhs/state/prolist/prolist.sh

  while read p; do
    let "pnum++"
    echo "$p" > "/var/mhs/state/prolist/$pnum"
    echo "[$pnum] $p" >> /var/mhs/state/prolist/final.sh
    echo "[$pnum] ${filler}${p}"
  done < /var/mhs/state/prolist/prolist.sh
}

projectnamecheck() {

  uploadervars
  if [[ "$uploaderproject" == "NOT-SET" ]]; then
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 Fail Notice
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💬  The PROJECT must be set first!

NOTE: Without setting a project, Blitz is unable to establish, build
keys, and deploy the proper GDSA Accounts for the Team Drive

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

    read -r -p '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
    clonestart
  fi

}

projectnameset() {

  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 rClone - WARNING! PROJECT CREATION!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
WARNING ~ WARNING ~ WARNING ~ WARNING ~ WARNING ~ WARNING ~ WARNING

Creating a NEW PROJECT will require a new Google CLIENT ID and SECRET from
this project to be created! As a result when finished; this will also
result in destroying the set gdrive/tdrive information due to the new
project being created!

This will also destroy any TRANSPORT MODE deployed and including any
mounts. Emby, Plex, and JellyFin Docker containers will also be REMOVED
to prevent any meta-data loss. When set, just redeploy them and will be
good to!

Do You Want to Proceed?
[1] No
[2] Yes

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -r -p '↘️  Input Choice | Press [Enter]: ' typed < /dev/tty
  case $typed in
    1)
      clonestart
      ;;
    2)
      a=bc
      ;;
    *)
      optionsmenu
      ;;
  esac

  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 rClone - Project Name
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Name of your project? Ensure the PROJECT NAME is one word; all lowercase;
no spaces!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -r -p '↘️  Input Name | Press [Enter]: ' typed < /dev/tty
  if [[ "$typed" == "" ]]; then projectnameset; else buildproject; fi
}

buildproject() {
  echo ""
  date=$(date +%m%d)
  rand=$(echo $((1 + RANDOM + RANDOM + RANDOM)))
  projectid="pg-$typed-${date}${rand}"
  gcloud projects create $projectid --account=${uploaderemail}

  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 ID: $projectid ~ Created
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 rClone - Enabling the API (Standby)!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  gcloud services enable drive.googleapis.com --project $projectid --account=${uploaderemail}
  echo "$projectid" > /var/mhs/state/uploader.project

  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 rClone - Resetting Prior Stored Information
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  rm -rf /var/mhs/state/uploader.secret 1> /dev/null 2>&1
  rm -rf /var/mhs/state/uploader.public 1> /dev/null 2>&1
  rm -rf /var/mhs/state/uploader.secret 1> /dev/null 2>&1
  rm -rf /opt/mhs/etc/mhs/.tdrive 1> /dev/null 2>&1
  rm -rf /opt/mhs/etc/mhs/.gdrive 1> /dev/null 2>&1
  rm -rf /opt/mhs/etc/mhs/.gcrypt 1> /dev/null 2>&1
  rm -rf /opt/mhs/etc/mhs/.tcrypt 1> /dev/null 2>&1
  rm -rf /var/mhs/state/uploader.teamdrive 1> /dev/null 2>&1
  rm -rf /var/mhs/state/deployed.version 1> /dev/null 2>&1

  docker stop jellyfin 1> /dev/null 2>&1
  docker stop plex 1> /dev/null 2>&1
  docker stop emby 1> /dev/null 2>&1
  docker rm jellyfin 1> /dev/null 2>&1
  docker rm plex 1> /dev/null 2>&1
  docker rm emby 1> /dev/null 2>&1

  ansible-playbook /opt/mhs/lib/uploader/ymls/remove.yml
  cleanmounts
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 rClone - Prior Stored Information is Reset!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: If Plex, Emby, and/or JellyFin was deployed; redeploy them through
AppBox when complete! Ensuring that the containers do not self erase
meta-data due to the mounts being offline!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  read -r -p '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
  clonestart
}
