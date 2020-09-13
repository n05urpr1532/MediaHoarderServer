#!/usr/bin/env bash

removepoint() {
  rolevars

  # Nothing Exist; kick user back to main menu
  frontoutput=$(cat /var/mhs/state/multihd.paths)
  if [[ "$frontoutput" == "" ]]; then
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💪 Remove an HD or MountPoint
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: No HD's or MountPoints have been stored! Unable to remove something
that does not exist! EXITING!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    read -rp '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
    multihdstart
  fi

  inputphase
}

inputphase() {

  rm -rf /var/mhs/state/.tmp.removepointmenu 1> /dev/null 2>&1

  # Starting Process
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💪 Remove an HD/MountPoint
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
NOTE: Type a number selection in order to remove one of the HD/Mountpoints

EOF
  num=0
  while read p; do
    ((num++))
    echo "[$num] $p"
    echo "[$num] $p" >> /var/mhs/state/.tmp.removepointmenu
  done < /var/mhs/state/multihd.paths

  tee <<- EOF

Quitting? Type >>> exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -rp '↘️  Type Number | Press [ENTER]: ' typed < /dev/tty

  if [[ "$typed" == "exit" || "$typed" == "Exit" || "$typed" == "EXIT" || "$typed" == "z" || "$typed" == "Z" ]]; then multihdstart; fi
  if [[ "$typed" == "" ]]; then inputphase; fi

  if [[ "$typed" -ge "1" && "$typed" -le "$num" ]]; then removepointfinal; fi

  inputphase
}

removepointfinal() {

  cat /var/mhs/state/.tmp.removepointmenu | grep "$typed" > /var/mhs/state/.tmp.removepointmenu.select
  removestore=$(cat /var/mhs/state/.tmp.removepointmenu.select | awk '{print $2}')

  rm -rf /var/mhs/state/.tmp.removebuild 1> /dev/null 2>&1
  num=0
  while read p; do
    if [[ "$removestore" != "$p" ]]; then echo "$p" >> /var/mhs/state/.tmp.removebuild; fi
  done < /var/mhs/state/multihd.paths

  rm -rf /var/mhs/state/multihd.paths
  cp /var/mhs/state/.tmp.removebuild /var/mhs/state/multihd.paths

  # Congrats! The Path Should Now Be Removed
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💪 SUCCESS NOTICE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

PATH: $removestore

NOTE1: The following path has been removed from the MultiHD List!

NOTE2: To take full affect Move/Blitz must be deployed/redeployed
through rClone!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -rp '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty

  multihdstart
}
