#!/usr/bin/env bash

source /opt/mhs/lib/core/gce/functions/main.sh
suffix=GB
billingdeny() {
  if [[ $(gcloud beta billing accounts list | grep "\<True\>") == "" ]]; then
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 MESSAGE TYPE: ERROR
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

REASON: Billing Failed

INSTRUCTIONS:

Must turn on the billing for first for this project in GCE Panel.

Exiting!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    read -r -p '↘️  Acknowledge Error | Press [ENTER] ' typed < /dev/tty

    projectinterface
  fi

}

badinput() {
  echo
  read -r -p '⛔️ ERROR - BAD INPUT! | PRESS [ENTER] ' typed < /dev/tty
  projectinterface
}

deployfail() {

  gcefail="off"

  fail1=$(cat /var/mhs/state/project.ipregion)
  fail2=$(cat /var/mhs/state/project.processor)
  fail3=$(cat /var/mhs/state/project.account)
  fail4=$(cat /var/mhs/state/project.nvme)
  fail5=$(cat /var/mhs/state/project.ram)
  fail6=$(cat /var/mhs/state/project.imagecount)

  if [[ "$fail1" == "NOT-SET" || "$fail2" == "NOT-SET" || "$fail3" == "NOT-SET" || "$fail4" == "NOT-SET" || "$fail5" == "NOT-SET" || "$fail6" == "NOT-SET" ]]; then
    gcefail="on"
  fi

  if [[ "$gcefail" == "on" ]]; then
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎  Deployment Checks Failed!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Unfortunately, the deploy failed,
some variables have probably not been changed, please check it

possible mistakes are

NVME / CPU / RAM / OS image / IP Region / Project Account

were not changed to desire

Ensure that everything is set before deploying the GCE Server!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    read -r -p '↘️  Acknowledge | Press [ENTER] ' typed < /dev/tty

    gcestart
  fi
}

calculator() {
  clear
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 GCE Calculaor
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

if they want to know what an instance would cost them; click on this link,

https://cloud.google.com/products/calculator/

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  echo
  read -r -p 'Acknowledge Info | PRESS [ENTER] ' < /dev/tty
  clear

  gcestart
}

nvmecount() {
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎  NVME Count
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Most users will only need to utilize 1 - 2 NVME Drives.
The more, the faster the processing, but the faster your credits drain.
If intent is to be in beast mode during the GCEs duration.

INSTRUCTIONS: Set the NVME Count ~ 1 - 4

NOTE : if you use 1 - 3 Nvmes you will get a swraid0
NOTE : if you use 4 Nvmes you will get a swraid5

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -r -p 'Type Number | Press [ENTER]: ' typed < /dev/tty
  ## NVME counter to add dont edit this lines below

  nvmedeploy="/var/mhs/state/deploy.nvme"
  sudo rm -rf $nvmedeploy
  touch $nvmedeploy

  if [[ "$typed" == "1" ]]; then
    echo -e "$typed" > /var/mhs/state/project.nvme
    echo -e "--local-ssd interface=nvme" > $nvmedeploy
  elif [[ "$typed" == "2" ]]; then
    echo -e "$typed" > /var/mhs/state/project.nvme
    echo -e "--local-ssd interface=nvme \\n--local-ssd interface=nvme" > $nvmedeploy
  elif [[ "$typed" == "3" ]]; then
    echo -e "$typed" > /var/mhs/state/project.nvme
    echo -e "--local-ssd interface=nvme \\n--local-ssd interface=nvme \\n--local-ssd interface=nvme" > $nvmedeploy
  elif [[ "$typed" == "4" ]]; then
    echo -e "$typed" > /var/mhs/state/project.nvme
    echo -e "--local-ssd interface=nvme \\n--local-ssd interface=nvme \\n--local-ssd interface=nvme \\n--local-ssd interface=nvme" > $nvmedeploy
  elif [[ "$typed" -gt "4" ]]; then
    echo "more then 4 NVME's is not possible" && sleep 5 && nvmecount
  else nvmecount; fi
}
ramcount() {
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎  RAM Count
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Most users will only need to utilize 8 Gb Ram.
Then more, the faster the processing, but the faster your credits drain.
If intent is to be in beast mode during the GCEs duration.

INSTRUCTIONS: Set the RAM Count ~ 8 - 64 GB

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -r -p 'Type Number | Press [ENTER]: ' typed < /dev/tty

  if [[ "$typed" -lt "8" || "$typed" -gt "64" ]]; then ramcount; fi

  echo -e "$typed""$suffix" > /var/mhs/state/project.ram
}

imagecount() {
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 OS Image
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[ 1 ] Ubuntu 1804 = Public OS Image
[ 2 ] Ubuntu 1804 = Shielded OS Image

if dont know what this means klick the link below

https://cloud.google.com/compute/docs/images

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -r -p 'Type Number | Press [ENTER]: ' typed < /dev/tty

  if [[ "$typed" == "1" ]]; then
    echo -e "ubuntu-os-cloud" > /var/mhs/state/project.imagecount
    echo -e "ubuntu-minimal-1804-lts" > /var/mhs/state/project.image
  elif [[ "$typed" == "2" ]]; then
    echo -e "gce-uefi-images" > /var/mhs/state/project.imagecount
    echo -e "ubuntu-1804-lts" > /var/mhs/state/project.image
  else imagecount; fi
}

processorcount() {
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎  Processor Count
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

INFORMATION:

The processor count utilizes can affect how fast your credits drain.
If usage is light, select 4.
If for average use, 4 or 6 is fine.
Only utilize 8 if the GCE will be used heavily!

INSTRUCTIONS: Set the Processor Count ~ 4 - 16 vCores

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -r -p 'Type Number | Press [ENTER]: ' typed < /dev/tty

  if [[ "$typed" -lt "4" || "$typed" -gt "16" ]]; then processorcount; fi

  echo -e "$typed" > /var/mhs/state/project.processor
}

projectinterface() {
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎  Project Interface
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Project ID: [ $projectid ]

[ 1 ] Utilize/Change Existing Project
[ 2 ] Build a New Project

[ 3 ] Destroy Existing Project

[ Z ] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -r -p 'Type Number | Press [ENTER]: ' typed < /dev/tty

  case $typed in
    1)

      infolist() {
        tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎  Utilize/Change Existing Project
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

QUESTION:

Which existing project will be utilized for the GCE?

[ $prolist ]

[ Z ] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
      }

      pnum=0
      mkdir -p /var/mhs/state/prolist
      rm -rf /var/mhs/state/prolist/* 1> /dev/null 2>&1

      echo "" > /var/mhs/state/prolist/final.sh
      gcloud projects list | cut -d' ' -f1 | tail -n +2 > /var/mhs/state/prolist/prolist.sh

      ### project no exist check
      pcheck=$(cat /var/mhs/state/prolist/prolist.sh)
      if [[ "$pcheck" == "" ]]; then noprojects; fi

      while read p; do
        let "pnum++"
        echo "$p" > "/var/mhs/state/prolist/$pnum"
        echo "[$pnum] $p" >> /var/mhs/state/prolist/final.sh
      done < /var/mhs/state/prolist/prolist.sh
      prolist=$(cat /var/mhs/state/prolist/final.sh)

      typed2=999999999
      while [[ "$typed2" -lt "1" || "$typed2" -gt "$pnum" ]]; do
        infolist
        read -r -p 'Type Number | Press [ENTER]: ' typed2 < /dev/tty
        if [[ "$typed2" == "exit" || "$typed2" == "Exit" || "$typed2" == "EXIT" || "$typed2" == "z" || "$typed2" == "Z" ]]; then projectinterface; fi
      done

      typed=$(cat /var/mhs/state/prolist/$typed2)
      gcloud config set project $typed
      billingdeny

      echo "off" > /var/mhs/state/project.switch

      tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 PLEASE WAIT! Enabling Billing ~ Project $typed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
      accountbilling=$(gcloud beta billing accounts list | tail -1 | awk '{print $1}')
      gcloud beta billing projects link $typed --billing-account "$accountbilling" --quiet

      tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 PLEASE WAIT! Enabling Compute API ~ Project $typed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
      gcloud services enable compute.googleapis.com

      tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 PLEASE WAIT! Enabling Drive API ~ Project $typed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
      echo ""
      gcloud services enable drive.googleapis.com --project $typed

      tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 NOTICE: Project Default Set ~ $typed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
      echo $typed > /var/mhs/state/uploader.project
      echo
      read -r -p '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
      variablepull
      projectinterface
      ;;

    2)

      tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎  Create & Set a Project Name
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

INSTRUCTIONS:

Set a Project Name and keep it short and simple!
No spaces and keep it all lower case!
Failing to do so will result in naming issues.

[ Z ] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
      read -r -p 'Type Project Name | Press [ENTER]: ' projectname < /dev/tty
      echo ""

      # loops user back to exit if typed
      if [[ "$projectname" == "exit" || "$projectname" == "Exit" || "$projectname" == "EXIT" || "$projectname" == "z" || "$projectname" == "Z" ]]; then
        projectinterface
      fi

      # generates a random number within to prevent collision with other Google Projects; yes everyone!
      rand=$(echo $((1 + RANDOM + RANDOM + RANDOM + RANDOM + RANDOM + RANDOM + RANDOM + RANDOM + RANDOM + RANDOM)))
      projectfinal="pg-$projectname-$rand"
      gcloud projects create $projectfinal

      tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎  Project Message
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

INFO: $projectfinal created.

Ensure afterwards to ESTABLISH the project as your default to utilize!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

      read -r -p 'Acknowledge Info | Press [ENTER]' typed < /dev/tty

      projectinterface
      ;;

    3)
      existlist() {
        tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎  Delete Existing Projects
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

WARNING : Deleting projects will result in deleting keys that are
associated with it! Be careful in what your doing!

QUESTION: Which existing project will be deleted?

[ $prolist ]

[ Z ] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
      }

      pnum=0
      mkdir -p /var/mhs/state/prolist
      rm -rf /var/mhs/state/prolist/* 1> /dev/null 2>&1

      echo "" > /var/mhs/state/prolist/final.sh
      gcloud projects list | cut -d' ' -f1 | tail -n +2 > /var/mhs/state/prolist/prolist.sh

      ### prevent bonehead from deleting the project that is active!
      variablepull
      sed -i -e "/${projectid}/d" /var/mhs/state/prolist/prolist.sh

      ### project no exist check
      pcheck=$(cat /var/mhs/state/prolist/prolist.sh)
      if [[ "$pcheck" == "" ]]; then noprojects; fi

      while read p; do
        let "pnum++"
        echo "$p" > "/var/mhs/state/prolist/$pnum"
        echo "[$pnum] $p" >> /var/mhs/state/prolist/final.sh
      done < /var/mhs/state/prolist/prolist.sh
      prolist=$(cat /var/mhs/state/prolist/final.sh)

      typed2=999999999
      while [[ "$typed2" -lt "1" || "$typed2" -gt "$pnum" ]]; do
        existlist
        read -r -p 'Type Number | Press [ENTER]: ' typed2 < /dev/tty
        if [[ "$typed2" == "exit" || "$typed2" == "Exit" || "$typed2" == "EXIT" || "$typed2" == "z" || "$typed2" == "Z" ]]; then projectinterface; fi
      done

      typed=$(cat /var/mhs/state/prolist/$typed2)
      gcloud projects delete "$typed"

      tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 System Message: Project Deleted ~ $typed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
      echo $typed > /var/mhs/state/uploader.project
      echo
      read -r -p '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
      variablepull
      projectinterface
      ;;
    z)
      gcestart
      ;;
    Z)
      gcestart
      ;;
    *) ;;

  esac

}

### Function for if no projects exists
noprojects() {
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎  No Projects Exist
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

WARNING: No projects exists! Cannot delete the default active project if
that exists!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -r -p '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty

  ### go back to main project interface
  projectinterface
}

projectdeny() {
  if [[ $(cat /var/mhs/state/project.id) == "NOT-SET" ]]; then
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 MESSAGE TYPE: ERROR
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

REASON: Project ID Not Set

INSTRUCTIONS: Project ID from the Project Interface must be set first.
Exiting!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    read -r -p '↘️  Acknowledge Error | Press [ENTER] ' typed < /dev/tty
    gcestart
  fi

}

sshdeploy() {
  variablepull
  gcloud compute ssh pg-gce --zone "$ipzone"
  gcestart
}
