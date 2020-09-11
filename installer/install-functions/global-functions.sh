#!/usr/bin/env bash
################################################################################
# Base installer - Global functions
################################################################################

timer() {
  local seconds=$1
  local date1=$(($(date +%s) + seconds))
  while [ "$date1" -ge "$(date +%s)" ]; do
    echo -ne "$(date -u --date @$((date1 - $(date +%s))) +%H:%M:%S)\r"
  done
}

user_confirm_info() {
  echo
  read -r -p 'Confirm Info | PRESS [ENTER] ' < /dev/tty
  echo
}
