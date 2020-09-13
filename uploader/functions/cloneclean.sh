#!/usr/bin/env bash

# For Clone Clean
variable /var/mhs/state/cloneclean.nzb "600"
variable /var/mhs/state/cloneclean.torrent "2400"
changeCloneCleanInterval() {

  touch /var/mhs/state/cloneclean.nzb
  touch /var/mhs/state/cloneclean.torrent
  cleanernzb="$(cat /var/mhs/state/cloneclean.nzb)"
  cleanertorrenet="$(cat /var/mhs/state/cloneclean.torrent)"
  if [[ "$cleanernzb" == "600" || "$cleanernzb" == "" || "$cleanernzb" == "NON-SET" ]]; then echo "600" > /var/mhs/state/cloneclean.nzb; fi
  if [[ "$cleanertorrenet" == "2400" || "$cleanertorrenet" == "" || "$cleanertorrenet" == "NON-SET" ]]; then echo "2400" > /var/mhs/state/cloneclean.torrent; fi

  uploadervars

  cleanernzb="$(cat /var/mhs/state/cloneclean.nzb)"
  cleanertorrent="$(cat /var/mhs/state/cloneclean.torrent)"
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Clone Clean
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Clone Clean deletes garbage files in your download folder.

[1] Clone Clean NZB             [ $(cat /var/mhs/state/cloneclean.nzb) min ]
[2] Clone Clean TORRENT         [ $(cat /var/mhs/state/cloneclean.torrent) min ]

[Z] - Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  read -p '↘️  Type Number | Press [ENTER]: ' typed < /dev/tty
  case $typed in
    1) ccleanernzb && changeCloneCleanInterval ;;
    2) ccleanertorrent && changeCloneCleanInterval ;;
    z) clonestart ;;
    Z) clonestart ;;
    *) changeCloneCleanInterval ;;
  esac
}
###################
ccleanernzb() {
  uploadervars
  mxcc="720"
  mmcc="30"
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Clone Clean NZB
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Clone Clean deletes garbage files in your downloads folder per every
[$(cat /var/mhs/state/cloneclean.nzb)] minutes!

minimum is "$mmcc" | maximum is "$mxcc"

WARNING: Do not set this too low because legitmate files!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Z] Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -p '↘️  Type Minutes (Minimum is 30) | PRESS [ENTER]: ' varinput < /dev/tty
  if [[ "$varinput" == "exit" || "$varinput" == "Exit" || "$varinput" == "EXIT" || "$varinput" == "z" || "$varinput" == "Z" ]]; then
    changeCloneCleanInterval
  elif [[ "$varinput" =~ ^[0-9]*$ ]]; then
    if [[ "$varinput" -ge "$mmcc" && "$varinput" -le "$mxcc" ]]; then
      echo "$varinput" > /var/mhs/state/cloneclean.nzb
    fi
  elif [[ "$varinput" =~ ^[0-9a-zA-Z]*$ ]]; then
    echo "Only enter numbers! - Try again:"
    read -p '↘️  Type Minutes (Minimum is 30) | PRESS [ENTER]: ' varinput < /dev/tty
    if [[ "$varinput" -ge "$mmcc" && "$varinput" -le "$mxcc" ]]; then
      echo "$varinput" > /var/mhs/state/cloneclean.nzb
    fi
  else ccleanernzb; fi
}
###################
ccleanertorrent() {
  uploadervars
  mxcc="10800"
  mmcc="30"
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Clone Clean Torrent
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Clone Clean deletes garbage files in your downloads folder per every
[$(cat /var/mhs/state/cloneclean.torrent)] minutes!

minimum is "$mmcc" | maximum is "$mxcc"

WARNING: Do not set this too low because legitmate files!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Z] Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  read -p '↘️  Type Minutes (Minimum is 30) | PRESS [ENTER]: ' varinput < /dev/tty
  if [[ "$varinput" == "exit" || "$varinput" == "Exit" || "$varinput" == "EXIT" || "$varinput" == "z" || "$varinput" == "Z" ]]; then
    changeCloneCleanInterval
  elif [[ "$varinput" =~ ^[0-9]*$ ]]; then
    if [[ "$varinput" -ge "$mmcc" && "$varinput" -le "$mxcc" ]]; then
      echo "$varinput" > /var/mhs/state/cloneclean.torrent
    fi
  elif [[ "$varinput" =~ ^[0-9a-zA-Z]*$ ]]; then
    echo "Only enter numbers! - Try again:"
    read -p '↘️  Type Minutes (Minimum is 30) | PRESS [ENTER]: ' varinput < /dev/tty
    if [[ "$varinput" -ge "$mmcc" && "$varinput" -le "$mxcc" ]]; then
      echo "$varinput" > /var/mhs/state/cloneclean.torrent
    fi
  else ccleanertorrent; fi
}
