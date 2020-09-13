#!/usr/bin/env bash

# BAD INPUT
badinput() {
  echo
  read -r -p '⛔️ ERROR - BAD INPUT! | PRESS [ENTER] ' typed < /dev/tty
  question1
}

# FUNCTION - ONE
question1() {

  # Recall Program
  image=$(cat /tmp/program_var)

  # Checks Image List
  file="/opt/mhs/lib/apps-core/image/$image"
  if [ ! -e "$file" ]; then exit; fi

  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌵  Multi Image Selector - $image
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  count=1
  while read p; do
    echo "$count - $p"
    echo "$p" > /tmp/display$count
    count=$((count + 1))
  done < /opt/mhs/lib/apps-core/image/$image
  echo ""
  read -r -p '🚀  Type Number | PRESS [ENTER]: ' typed < /dev/tty

  if [[ "$typed" -ge "1" && "$typed" -lt "$count" ]]; then
    mkdir -p /var/mhs/state/image
    cat "/tmp/display$typed" > "/var/mhs/state/image/$image"
  else badinput; fi
}

# END OF FUNCTIONS ############################################################

question1
