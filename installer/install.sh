#!/usr/bin/env bash
################################################################################
# Base installer
################################################################################

################################################################################
### Configuration
################################################################################
MHS_GIT_REPOSITORY_URL="https://github.com/n05urpr1532/MediaHoarderServer.git"
MHS_GIT_REPOSITORY_BRANCH="feature/refactor"

################################################################################
### Functions
################################################################################

# set options
# -e:           Exit immediately if a command exits with a non-zero status (but not when chained with "&&" !!!)
# -u:           Treat unset variables as an error when substituting
# -v:           Print shell input lines as they are read
# -x:           Print commands and their arguments as they are executed
# -o pipefail:  The return value of a pipeline is the status of the last command to exit with a non-zero status, or zero if no command exited with a non-zero status
set -euo pipefail

unsupported_system_error() {
  tee <<- EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔  !!! Media Hoarder Server System Error !!!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Supported: Ubuntu 18+ and Debian 9+

This server is not supported due to having the incorrect OS detected!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
}

check_os_is_debian_like() {
  if [[ ! -f /etc/debian_version ]]; then
    unsupported_system_error
    exit 0
  fi
}

check_os() {
  export DEBIAN_FRONTEND=noninteractive
  (apt-get update && apt-get install apt-transport-https lsb-release -yqq) > /dev/null 2>&1

  local os_distrib
  os_distrib=$(lsb_release -si)
  local os_version
  os_version=$(lsb_release -sr | cut -d"." -f1)

  local bad_os=1
  if [[ "$os_distrib" == "Debian" && $os_version -ge 9 ]]; then
    bad_os=0
  elif [[ "$os_distrib" == "Ubuntu" && $os_version -ge 16 ]]; then
    bad_os=0
  fi

  if [[ "$bad_os" == "1" ]]; then
    unsupported_system_error
    exit 0
  fi
}

init_installer_log_file() {
  local timestamp
  timestamp=$(date +%F-%H%M%S)

  mkdir -p /var/mhs/log/installer
  touch "/var/mhs/log/installer/install_${timestamp}.log"
  if [[ -e /var/mhs/log/installer/install.log ]]; then
    rm -f /var/mhs/log/installer/install.log
  fi
  ln -s "/var/mhs/log/installer/install_${timestamp}.log" /var/mhs/log/installer/install.log
}

logger() {
  local content=$1
  local timestamp
  timestamp=$(date +"%F %T")

  if [[ -n "$content" ]]; then
    echo -e "\n--------------------------------------------------------------------------------\n$timestamp\n" >> /var/mhs/log/installer/install.log
    echo "$content" >> /var/mhs/log/installer/install.log
  fi
}

clone_repo() {
  logger "clone_repo"

  logger "$(apt-get install git -yqq 2>&1)"

  if [[ -d "/opt/mhs/lib" ]]; then
    rm -rf /opt/mhs/lib || (echo "Cannot delete /opt/mhs/lib directory" && logger "Cannot delete /opt/mhs/lib directory" && exit 1)
  fi
  tee <<- EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛  Media Hoarder Server installer is downloading installation files
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Please stand by...

EOF
  logger "$(git clone -b ${MHS_GIT_REPOSITORY_BRANCH} --single-branch ${MHS_GIT_REPOSITORY_URL} /opt/mhs/lib 2>&1)"
}

################################################################################
### Main
################################################################################

tee <<- EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛  Media Hoarder Server installer is initializing
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Please stand by...

EOF

check_os_is_debian_like && check_os && init_installer_log_file && clone_repo

source /opt/mhs/lib/installer/install-functions/global-functions.sh
source /opt/mhs/lib/installer/install-functions/user-info.sh
source /opt/mhs/lib/installer/install-functions/check-sudoer.sh
source /opt/mhs/lib/installer/install-functions/check-disk-space.sh
source /opt/mhs/lib/installer/install-functions/previous-version.sh
source /opt/mhs/lib/installer/install-functions/installer-main-functions.sh

info_start_install
info_google_drive_tos
check_user_is_sudoer_or_root
check_disk_space

has_previous_version=$(check_if_previous_version_exists)

install_mhs

info_install_end "$has_previous_version"

logger "Media Hoarder Server installation done !"
