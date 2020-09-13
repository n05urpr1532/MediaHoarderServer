#!/usr/bin/env bash

multihdstart() {
  rolevars
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💪 Welcome to MultiHD
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] Add     (HD or MountPoint)
[2] Remove  (HD or MountPoint)
[3] View    (Current MultiHD List)

NOTE: When finished making changes; rClone must redeploy in order for
the changes to take affect in (Union) MergerFS!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Z] Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -rp '↘️  Input Selection | Press [ENTER]: ' typed < /dev/tty
  multihdstartinput
}

multihdstartinput() {
  case $typed in
    1) addpoint ;;
    2) removepoint ;;
    3)
      tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💪 Established and Verified MountPoints
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

      frontoutput=$(cat /var/mhs/state/multihd.paths)
      if [[ "$frontoutput" == "" ]]; then
        echo "NOTHING HAS BEEN SETUP!"
      else cat /var/mhs/state/multihd.paths; fi

      tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
      read -rp '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty

      multihdstart
      ;;
    z) exit ;;
    Z) exit ;;
    *) multihdstart ;;
  esac
  multihdstart
}
