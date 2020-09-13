#!/usr/bin/env bash

main() {
  # Menu Interface
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚥 TroubleShoot Interface
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] Pre-Installer: Force the Entire Process Again
[2] UnInstaller  : Docker & Running Containers | Force Pre-Install
[3] UnInstaller  : MHS

[Z] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  # Standby
  read -r -p '↘️  Type Number | Press [ENTER]: ' typed < /dev/tty

  case $typed in
    1)
      tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🍖  NOM NOM - Resetting the Starting Variables!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
      sleep 3
      echo "0" > /var/mhs/state/pg.preinstall.stored
      echo "0" > /var/mhs/state/pg.ansible.stored
      echo "0" > /var/mhs/state/pg.rclone.stored
      echo "0" > /var/mhs/state/pg.python.stored
      echo "0" > /var/mhs/state/pg.docker.stored
      echo "0" > /var/mhs/state/pg.docstart.stored
      echo "0" > /var/mhs/state/pg.watchtower.stored
      echo "0" > /var/mhs/state/pg.label.stored
      echo "0" > /var/mhs/state/pg.alias.stored
      echo "0" > /var/mhs/state/pg.dep.stored

      tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅️ WOOT WOOT - Process Complete! Exit & Restart MHS Now!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
      sleep 5
      ;;

    2)
      tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🍖  NOM NOM - Uninstalling Docker & Resetting the Variables!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
      sleep 3

      rm -rf /etc/docker
      apt-get purge docker-ce && apt-get autoremove -yqq
      rm -rf /var/lib/docker
      rm -rf /var/mhs/state/dep*
      echo "0" > /var/mhs/state/pg.preinstall.stored
      echo "0" > /var/mhs/state/pg.ansible.stored
      echo "0" > /var/mhs/state/pg.rclone.stored
      echo "0" > /var/mhs/state/pg.python.stored
      echo "0" > /var/mhs/state/pg.docstart.stored
      echo "0" > /var/mhs/state/pg.watchtower.stored
      echo "0" > /var/mhs/state/pg.label.stored
      echo "0" > /var/mhs/state/pg.alias.stored
      echo "0" > /var/mhs/state/pg.dep

      tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅️ WOOT WOOT - Process Complete! Exit & Restart MHS Now!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
      sleep 5
      ;;
    3)
      tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🍖  NOM NOM - Starting the MHS UnInstaller
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
      sleep 3
      echo "uninstall" > /var/mhs/state/type.choice && bash /opt/mhs/lib/core/core/scripts/main.sh
      ;;
    z) exit ;;
    Z) exit ;;
  esac
}

#### function start

main
