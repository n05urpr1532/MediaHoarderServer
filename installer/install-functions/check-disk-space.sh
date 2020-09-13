#!/usr/bin/env bash
################################################################################
# Base installer - Check available disk space
################################################################################

check_disk_space() {
  logger "check_disk_space"

  local leftover
  leftover=$(df / --local | tail -n +2 | awk '{print $4}')
  if [[ "$leftover" -lt "50000000" ]]; then
    tee <<- EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠  !!! Media Hoarder Server System Warning !!!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

You have less than 50GB of storage space available on your root partition,
this can lead to problems.

Please make sure that there is enough space available.

Moving forward, you're carrying out this installation at your own risk.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    user_acknowledge_info
  fi
}
