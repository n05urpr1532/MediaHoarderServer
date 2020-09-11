#!/usr/bin/env bash
################################################################################
# Base installer - Previous Plexguide, PGBlitz and PTS versions management
################################################################################

# set options
# -e:           Exit immediately if a command exits with a non-zero status (but not when chained with "&&" !!!)
# -u:           Treat unset variables as an error when substituting
# -v:           Print shell input lines as they are read
# -x:           Print commands and their arguments as they are executed
# -o pipefail:  The return value of a pipeline is the status of the last command to exit with a non-zero status, or zero if no command exited with a non-zero status
set -euo pipefail

check_if_previous_version_exists() {
  logger "check_if_previous_version_exists"

  local file="/opt/plexguide/menu/pg.yml"
  if [[ -f $file ]]; then
    ask_overwrite_previous_version
  else
    echo "0"
  fi
}

backup_previous_version() {
  logger "backup_previous_version"

  local time
  time=$(date +%Y-%m-%d-%H:%M:%S)
  logger "$(mkdir -p /var/mhs/old-pg-backup/ 2>&1)"
  tee <<- EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛  Backup existing Plexguide / PGBlitz / PTS installation
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Please stand by...
EOF
  logger "$(
    tar --warning=no-file-changed --ignore-failed-read --absolute-names --warning=no-file-removed \
    -C /opt/plexguide -cf /var/mhs/old-pg-backup/plexguide-opt-old-"$time".tar.gz ./ 2>&1
  )"
  logger "$(
    tar --warning=no-file-changed --ignore-failed-read --absolute-names --warning=no-file-removed \
    -C /var/plexguide -cf /var/mhs/old-pg-backup/plexguide-var-old-"$time".tar.gz ./ 2>&1
  )"

  printfiles=$(ls -ah /var/mhs/old-pg-backup/*)
  logger "$printfiles"
  tee <<- EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅  Backup of existing Plexguide / PGBlitz / PTS installation
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Backup of existing Plexguide / PGBlitz / PTS installation done !

Files:
$printfiles
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  user_confirm_info
  tee <<- EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛  Cleaning up existing PG / PTS installation
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Please stand by...
EOF
  if [[ -e "/opt/plexguide" ]]; then logger "$(rm -rf /opt/plexguide 2>&1)"; fi
  if [[ -e "/opt/pgstage" ]]; then logger "$(rm -rf /opt/pgstage 2>&1)"; fi
  if [[ -e "/var/plexguide" ]]; then logger "$(rm -rf /var/plexguide 2>&1)"; fi
  if [[ -e "/opt/ptsupdate" ]]; then logger "$(rm -rf /opt/ptsudate 2>&1)"; fi
  tee <<- EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅  Cleanup of existing PG / PTS installation done !
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  user_confirm_info
}

ask_overwrite_previous_version_badinput() {
  echo
  read -r -p '⛔️ ERROR - Bad Input! | Press [ENTER] ' < /dev/tty
  ask_overwrite_previous_version
}

ask_overwrite_previous_version_nope() {
  echo
  exit 0
}

do_upgrade_previous_version() {
  backup_previous_version || exit 1
}

ask_overwrite_previous_version() {
  logger "ask_overwrite_previous_version"

  local typed
  tee <<- EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠  !!! Existing PG/PTS installation found !!!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
What would you like to do now ?

Select from the two option below:

[ Y ] Yes, I want a clean PTS installation. (Recommended)
( This will create a backup from 2 folders. )

[ N ] No, I want to keep my PG/PTS installation
( This will stop the installation now. )

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[ Z ] EXIT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  read -r -p '↘️  Type Y | N or Z | Press [ENTER]: ' typed < /dev/tty

  case $typed in
    [Yy]) echo "" && do_upgrade_previous_version && echo "1" && return ;;
    [Nn] | [Zz]) ask_overwrite_previous_version_nope ;;
    *) ask_overwrite_previous_version_badinput ;;
  esac

  echo "0"
}
