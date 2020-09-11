#!/usr/bin/env bash
################################################################################
# Base installer - Check if user is sudoer or root
################################################################################

check_user_is_sudoer_or_root() {
  logger "check_user_is_sudoer_or_root"

  if [[ $EUID -ne 0 ]]; then
    tee <<- EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔  !!! Media Hoarder Server System Error !!!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

You must run MHS installer as a SUDOER (with sudo) or as ROOT!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    exit 0
  fi
}
