#!/usr/bin/env bash
################################################################################
# Base installer - Main functions
################################################################################

# set options
# -e:           Exit immediately if a command exits with a non-zero status (but not when chained with "&&" !!!)
# -u:           Treat unset variables as an error when substituting
# -v:           Print shell input lines as they are read
# -x:           Print commands and their arguments as they are executed
# -o pipefail:  The return value of a pipeline is the status of the last command to exit with a non-zero status, or zero if no command exited with a non-zero status
set -euo pipefail

reload_environment() {
  logger "reload_environment"

  set +u
  if grep -q "PATH" /etc/environment; then
    source /etc/environment
  else
    source /etc/profile
  fi
  export PATH
  set -u
}

install_base_packages() {
  logger "install_base_packages"

  local base_list="lsof software-properties-common dirmngr"

  export DEBIAN_FRONTEND=noninteractive
  # shellcheck disable=SC2086
  logger "$(apt-get update && apt-get install -yqq $base_list 2>&1)"
}

check_existing_webservers() {
  logger "check_existing_webservers"

  tee <<- EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛  MHS is checking for existing active Webserver(s)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Please stand by...
EOF
  if logger "$(lsof -Pi :80 -sTCP:LISTEN -t 2>&1)"; then
    logger "$(service apache2 stop 2>&1)"
    logger "$(service nginx stop 2>&1)"
    logger "$(apt-get purge apache nginx -yqq 2>&1)"
    logger "$(apt-get autoremove -yqq 2>&1)"
    logger "$(apt-get autoclean -yqq 2>&1)"
  elif logger "$(lsof -Pi :443 -sTCP:LISTEN -t 2>&1)"; then
    logger "$(service apache2 stop 2>&1)"
    logger "$(service nginx stop 2>&1)"
    logger "$(apt-get purge apache nginx -yqq 2>&1)"
    logger "$(apt-get autoremove -yqq 2>&1)"
    logger "$(apt-get autoclean -yqq 2>&1)"
  fi
  tee <<- EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅  MHS check for existing Webserver(s) is now completed !
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
}

add_packages_repositories() {
  logger "add_packages_repositories"

  local os_distrib
  os_distrib=$(lsb_release -si)
  if [[ $os_distrib == "Debian" ]]; then
    logger "$(add-apt-repository main 2>&1)"
    logger "$(add-apt-repository non-free 2>&1)"
    logger "$(add-apt-repository contrib 2>&1)"
    logger "$(apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367 2>&1)"
  elif [[ $os_distrib == "Ubuntu" ]]; then
    logger "$(add-apt-repository main 2>&1)"
    logger "$(add-apt-repository universe 2>&1)"
    logger "$(add-apt-repository restricted 2>&1)"
    logger "$(add-apt-repository multiverse 2>&1)"
  else
    exit 1
  fi
}

upgrade_os_and_install_packages() {
  logger "upgrade_os_and_install_packages"

  tee <<- EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛  MHS is now updating your system and installing packages
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Please stand by...
EOF
  local package_list="curl wget software-properties-common git zip unzip dialog sudo nano htop mc lshw fortune python3-apt intel-gpu-tools lolcat figlet"

  export DEBIAN_FRONTEND=noninteractive
  echo -ne '                         (0%)\r'
  logger "$(apt-get update -yqq 2>&1)"
  echo -ne '#####                    (20%)\r'
  logger "$(apt-get upgrade -yqq 2>&1)"
  echo -ne '##########                (40%)\r'
  logger "$(apt-get dist-upgrade -yqq 2>&1)"
  echo -ne '###############            (60%)\r'
  logger "$(apt-get autoremove -yqq 2>&1)"
  # shellcheck disable=SC2086
  logger "$(apt-get install -yqq $package_list 2>&1)"
  echo -ne '####################       (80%)\r'
  logger "$(apt-get purge unattended-upgrades -yqq 2>&1)"
  echo -ne '#######################    (90%)\r'

  # Make lolcat globally available
  if [[ ! -e /usr/local/bin/lolcat ]]; then
    logger "$(ln -s /usr/games/lolcat /usr/local/bin/lolcat 2>&1)"
  fi

  reload_environment

  echo -ne '#########################    (100%)\r'
  echo -ne '\n'

  tee <<- EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅  MHS finished updating your system!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
}

install_python_pip() {
  logger "install_python_pip"

  logger "$(apt-get install -y python3-pip 2>&1)"
}

install_ansible_with_pip() {
  logger "install_ansible_with_pip"

  logger "$(pip3 install ansible 2>&1)"

  reload_environment
}

configure_ansible() {
  logger "configure_ansible"

  logger "$(mkdir -p /etc/ansible/inventories/ 2>&1)"
  cat << 'EOF' > /etc/ansible/inventories/local
[local]
localhost ansible_connection=local

[local:vars]
ansible_python_interpreter=/usr/bin/python3
EOF
  ### Reference: https://docs.ansible.com/ansible/2.4/intro_configuration.html
  cat << 'EOF' > /etc/ansible/ansible.cfg
[defaults]
callback_whitelist = profile_tasks
command_warnings = False
deprecation_warnings = False
interpreter_python = auto
inventory = /etc/ansible/inventories/local
nocows = 1
EOF
}

deploy_mhs() {
  logger "deploy_mhs"

  tee <<- EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛  MHS is now deploying on your system
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Please stand by...
EOF
  echo -ne '                           (0%)\r'
  # Clean previous installation
  if [[ -e "/opt/plexguide" ]]; then logger "$(rm -rf /opt/plexguide 2>&1)"; fi
  if [[ -e "/opt/pgstage" ]]; then logger "$(rm -rf /opt/pgstage 2>&1)"; fi
  if [[ -e "/var/plexguide" ]]; then logger "$(rm -rf /var/plexguide 2>&1)"; fi
  if [[ -e "/opt/ptsupdate" ]]; then logger "$(rm -rf /opt/ptsudate 2>&1)"; fi
  echo -ne '##                         (10%)\r'
  echo "" > /var/mhs/server.ports
  install_python_pip
  echo -ne '#####                      (20%)\r'
  install_ansible_with_pip
  configure_ansible
  echo -ne '#######                    (30%)\r'
  logger "$(ansible-galaxy install --force stefangweichinger.ansible_rclone 2>&1)"
  echo -ne '##########                 (40%)\r'
  logger "$(ansible-playbook /opt/mhs/lib/installer/ansible-tasks/create-folders.yml 2>&1)"
  logger "$(ansible-playbook /opt/mhs/lib/menu/alias/alias.yml 2>&1)"
  logger "$(ansible-playbook /opt/mhs/lib/menu/motd/motd.yml 2>&1)"
  echo -ne '############               (50%)\r'
  logger "$(ansible-playbook /opt/mhs/lib/menu/pg.yml --tags journal,system 2>&1)"
  echo -ne '##############             (60%)\r'
  logger "$(ansible-playbook /opt/mhs/lib/menu/pg.yml --tags docker-install 2>&1)"
  echo -ne '#################          (70%)\r'
  logger "$(ansible-playbook /opt/mhs/lib/menu/pg.yml --tags rclone-install 2>&1)"
  echo -ne '####################       (80%)\r'
  logger "$(ansible-playbook /opt/mhs/lib/menu/pg.yml --tags mergerfs-install 2>&1)"
  echo -ne '######################     (90%)\r'
  logger "$(ansible-playbook /opt/mhs/lib/menu/pg.yml --tags update 2>&1)"
  echo -ne '#########################  (100%)\r'
  echo -ne '\n'

  tee <<- EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅  MHS is now deployed on your system!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
}

check_mhs_install() {
  logger "check_mhs_install"

  if [[ -e "/bin/mhs" ]]; then
    tee <<- EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛  MHS is now verifying that its install went well
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  else
    tee <<- EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔  !!! Media Hoarder Server System Error !!!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Installation failed !

Please check log and retry.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    user_confirm_info
    exit 1
  fi
}

installer_error() {
  logger "installer_error"

  tee <<- EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔  !!! Media Hoarder Server System Error !!!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

MHS Installer failed in function "$1" !

Please check log and retry.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  exit 1
}

install_mhs() {
  logger "install_mhs"

  install_base_packages || installer_error "install_base_packages"
  check_existing_webservers || installer_error "check_existing_webservers"
  add_packages_repositories || installer_error "add_packages_repositories"
  upgrade_os_and_install_packages || installer_error "upgrade_os_and_install_packages"
  deploy_mhs || installer_error "deploy_mhs"
  check_mhs_install || installer_error "check_mhs_install"
}
