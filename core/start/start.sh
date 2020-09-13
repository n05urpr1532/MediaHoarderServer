#!/usr/bin/env bash

# Create Variables (If New) & Recall
pcloadletter() {
  filevg="/var/mhs/state"
  touch $filevg/uploader.transport
  temp=$(cat /var/mhs/state/uploader.transport)
  if [ "$temp" == "mu" ]; then
    transport="Move"
  elif [ "$temp" == "me" ]; then
    transport="Move: Encrypted"
  elif [ "$temp" == "bu" ]; then
    transport="Blitz"
  elif [ "$temp" == "be" ]; then
    transport="Blitz: Encrypted"
  elif [ "$temp" == "le" ]; then
    transport="Local"
  else transport="NOT-SET"; fi
  echo "$transport" > $filevg/pg.transport
}

variable() {
  file="$1"
  if [ ! -e "$file" ]; then echo "$2" > $1; fi
}

# What Loads the Order of Execution
primestart() {
  pcloadletter
  varstart
  gcetest
}

wisword=$(/usr/games/fortune -as | sed "s/^/ /")

varstart() {
  ###################### FOR VARIABLS ROLE SO DOESNT CREATE RED - START
  filevg="/var/mhs/state"
  if [ ! -e "$filevg" ]; then
    mkdir -p $filevg/logs 1> /dev/null 2>&1
    chown -R 1000:1000 $file 1> /dev/null 2>&1
    chmod -R 775 $file 1> /dev/null 2>&1
  fi
  fileag="/opt/mhs/etc/mhs"
  if [ ! -e "$fileag" ]; then
    mkdir -p $fileag 1> /dev/null 2>&1
    chown -R 1000:1000 $fileag 1> /dev/null 2>&1
    chmod -R 775 $fileag 1> /dev/null 2>&1
  fi

  ###################### FOR VARIABLS ROLE SO DOESNT CREATE RED - START
  variable $filevg/pgfork.project "NOT-SET"
  variable $filevg/pgfork.version "NOT-SET"
  variable $filevg/tld.program "NOT-SET"
  variable $fileag/plextoken "NOT-SET"
  variable $filevg/server.ht ""
  variable $filevg/server.ports "127.0.0.1:"
  variable $filevg/server.email "NOT-SET"
  variable $filevg/server.domain "NOT-SET"
  variable $filevg/tld.type "standard"
  variable $filevg/transcode.path "standard"
  variable $filevg/uploader.transport "NOT-SET"
  variable $filevg/plex.claim ""

  #### Temp Fix - Fixes Bugged AppGuard
  serverht=$(cat /var/mhs/state/server.ht)
  if [ "$serverht" == "NOT-SET" ]; then
    rm $filevg/server.ht
    touch $filevg/server.ht
  fi

  hostname -I | awk '{print $1}' > $filevg/server.ip
  ###################### FOR VARIABLS ROLE SO DOESNT CREATE RED - END
  value="/etc/bash.bashrc.local"
  rm -rf $value && echo -e "export NCURSES_NO_UTF8_ACS=1" >> $value

  # run pg main
  file="/var/mhs/state/update.failed"
  if [ -e "$file" ]; then
    rm -rf /var/mhs/state/update.failed
    exit
  fi
  #################################################################################

  # Touch Variables Incase They Do Not Exist
  touch $filevg/pg.edition
  touch $filevg/server.id
  touch $filevg/pg.number
  touch $filevg/traefik.deployed
  touch $filevg/server.ht
  touch $filevg/server.ports
  touch $filevg/pg.server.deploy

  # For PG UI - Force Variable to Set
  ports=$(cat /var/mhs/state/server.ports)
  if [ "$ports" == "" ]; then
    echo "Open" > $filevg/pg.ports
  else echo "Closed" > $filevg/pg.ports; fi

  ansible --version | head -n +1 | awk '{print $2'} > $filevg/pg.ansible
  docker --version | head -n +1 | awk '{print $3'} | sed 's/,$//' > $filevg/pg.docker
  lsb_release -si > $filevg/pg.os

  file="/var/mhs/state/gce.false"
  if [ -e "$file" ]; then echo "No" > $filevg/pg.gce; else echo "Yes" > $filevg/pg.gce; fi

  # Call Variables
  edition=$(cat /var/mhs/state/pg.edition)

  # Declare Traefik Deployed Docker State
  if [[ $(docker ps --format {{.Names}} | grep "traefik") != "traefik" ]]; then
    traefik="NOT DEPLOYED"
    echo "Not Deployed" > $filevg/pg.traefik
  else
    traefik="DEPLOYED"
    echo "Deployed" > $filevg/pg.traefik
  fi

  if [[ $(docker ps --format {{.Names}} | grep "oauth") != "oauth" ]]; then
    oauth="NOT DEPLOYED"
    echo "Not Deployed" > $filevg/pg.auth
  else
    oauth="DEPLOYED"
    echo "Deployed" > $filevg/pg.oauth
  fi

  # For ZipLocations
  file="/var/mhs/state/data.location"
  if [ ! -e "$file" ]; then echo "/opt/mhs/etc/mhs" > $filevg/data.location; fi

  space=$(cat /var/mhs/state/data.location)
  used=$(df -h / --local | tail -n +2 | awk '{print $3}')
  capacity=$(df -h / --local | tail -n +2 | awk '{print $2}')
  percentage=$(df -h / --local | tail -n +2 | awk '{print $5}')

  # For the PGBlitz UI
  echo "$used" > $filevg/pg.used
  echo "$capacity" > $filevg/pg.capacity
}

gcetest() {
  gce=$(cat /var/mhs/state/pg.server.deploy)

  if [[ $gce == "feeder" ]]; then
    menuprime1
  else menuprime2; fi
}

menuprime1() {
  transport=$(cat /var/mhs/state/pg.transport)
  local pgnumber=$(cat /var/mhs/state/pg.number)
  local serverid=$(cat /var/mhs/state/server.id)

  # Menu Interface
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 $transport | Version: $pgnumber | ID: $serverid
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🌵 Disk Used Space: $used of $capacity | $percentage Used Capacity
EOF

  # Displays Second Drive If GCE
  edition=$(cat /var/mhs/state/pg.server.deploy)
  if [ "$edition" == "feeder" ]; then
    used_gce=$(df -h /mnt --local | tail -n +2 | awk '{print $3}')
    capacity_gce=$(df -h /mnt --local | tail -n +2 | awk '{print $2}')
    percentage_gce=$(df -h /mnt --local | tail -n +2 | awk '{print $5}')
    echo " GCE Disk Used Space: $used_gce of $capacity_gce | $percentage_gce Used Capacity"
  fi

  disktwo=$(cat "/var/mhs/state/server.hd.path")
  if [ "$edition" != "feeder" ]; then
    used_gce2=$(df -h "$disktwo" --local | tail -n +2 | awk '{print $3}')
    capacity_gce2=$(df -h "$disktwo" --local | tail -n +2 | awk '{print $2}')
    percentage_gce2=$(df -h "$disktwo" --local | tail -n +2 | awk '{print $5}')

    if [[ "$disktwo" != "/mnt" ]]; then
      echo " 2nd Disk Used Space: $used_gce2 of $capacity_gce2 | $percentage_gce2 Used Capacity"
    fi
  fi

  # Declare Ports State
  ports=$(cat /var/mhs/state/server.ports)

  if [ "$ports" == "" ]; then
    ports="OPEN"
  else ports="CLOSED"; fi

  tee <<- EOF
     -- GCE optimized surface --

[1] Traefik          : Reverse Proxy
[2] Port Guard       : [$ports] Protects the Server App Ports
[3] MHS-Shield       : Enable Google's OAuthentication Protection
[4] Uploader         : Mount rclone transport
[5] Applications     : Manage containerized applications
[6] Backup & Restore : Manage backups
[7] Traktarr         : Fill Sonarr/Radarr over Trakt lists.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[Z]  Exit

"$wisword"
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  # Standby
  read -r -p '↘️  Type Number | Press [ENTER]: ' typed < /dev/tty

  case $typed in
    1) clear && bash /opt/mhs/lib/traefik/traefik.sh && clear && primestart ;;
    2) clear && bash /opt/mhs/lib/core/portguard/portguard.sh && clear && primestart ;;
    3) clear && bash /opt/mhs/lib/core/shield/pgshield.sh && clear && primestart ;;
    4) clear && bash /opt/mhs/lib/uploader/uploader.sh && clear && primestart ;;
    5) clear && bash /opt/mhs/lib/core/pgbox/select.sh && clear && primestart ;;
    6) clear && bash /opt/mhs/lib/backup-and-restore/pgvault.sh && clear && primestart ;;
    7) clear && bash /opt/mhs/lib/core/traktarr/traktarr.sh && clear && primestart ;;
    z) clear && bash /opt/mhs/lib/core/interface/ending.sh && exit ;;
    Z) clear && bash /opt/mhs/lib/core/interface/ending.sh && exit ;;
    *) primestart ;;
  esac
}

menuprime2() {
  transport=$(cat /var/mhs/state/pg.transport)
  local pgnumber=$(cat /var/mhs/state/pg.number)
  local serverid=$(cat /var/mhs/state/server.id)

  # Menu Interface
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 $transport | Version: $pgnumber | ID: $serverid
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🌵 Disk Used Space: $used of $capacity | $percentage Used Capacity
EOF

  # Displays Second Drive If GCE
  edition=$(cat /var/mhs/state/pg.server.deploy)
  if [ "$edition" == "feeder" ]; then
    used_gce=$(df -h /mnt --local | tail -n +2 | awk '{print $3}')
    capacity_gce=$(df -h /mnt --local | tail -n +2 | awk '{print $2}')
    percentage_gce=$(df -h /mnt --local | tail -n +2 | awk '{print $5}')
    echo " GCE Disk Used Space: $used_gce of $capacity_gce | $percentage_gce Used Capacity"
  fi

  disktwo=$(cat "/var/mhs/state/server.hd.path")
  if [ "$edition" != "feeder" ]; then
    used_gce2=$(df -h "$disktwo" --local | tail -n +2 | awk '{print $3}')
    capacity_gce2=$(df -h "$disktwo" --local | tail -n +2 | awk '{print $2}')
    percentage_gce2=$(df -h "$disktwo" --local | tail -n +2 | awk '{print $5}')

    if [[ "$disktwo" != "/mnt" ]]; then
      echo " 2nd Disk Used Space: $used_gce2 of $capacity_gce2 | $percentage_gce2 Used Capacity"
    fi
  fi

  # Declare Ports State
  ports=$(cat /var/mhs/state/server.ports)

  if [ "$ports" == "" ]; then
    ports="OPEN"
  else ports="CLOSED"; fi

  tee <<- EOF

 [1] Traefik          : Reverse Proxy
 [2] Port Guard       : [$ports] Protects the Server App Ports
 [3] MHS-Shield       : Enable Google's OAuthentication Protection
 [4] Uploader         : Mount rclone transport
 [5] Applications     : Manage containerized applications
 [6] PlexAutoScan     : CloudBox PlexAutoScan
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 [7] Backup & Restore : Manage backups
 [8] Cloud Instances  : GCE & Virtual Instances
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 [9] PlexDupeFinder   : CloudBox PlexDupeFinder
[10] Traktarr         : Fill Sonarr/Radarr over Trakt lists.
[11] Plex Patrol      : Kick transcodes (audio or video or both)
[12] Settings
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Z]  Exit

"$wisword"
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  # Standby
  read -r -p '↘️  Type Number | Press [ENTER]: ' typed < /dev/tty

  case $typed in
    1) clear && bash /opt/mhs/lib/traefik/traefik.sh && clear && primestart ;;
    2) clear && bash /opt/mhs/lib/core/portguard/portguard.sh && clear && primestart ;;
    3) clear && bash /opt/mhs/lib/core/shield/pgshield.sh && clear && primestart ;;
    4) clear && bash /opt/mhs/lib/uploader/uploader.sh && clear && primestart ;;
    5) clear && bash /opt/mhs/lib/core/pgbox/select.sh && clear && primestart ;;
    6) clear && bash /opt/mhs/lib/core/pgscan/pgscan.sh && clear && primestart ;;
    7) clear && bash /opt/mhs/lib/backup-and-restore/pgvault.sh && clear && primestart ;;
    8) clear && bash /opt/mhs/lib/core/interface/cloudselect.sh && clear && primestart ;;
    9) clear && bash /opt/mhs/lib/core/plex_dupe/plex_dupe.sh && clear && primestart ;;
    10) clear && bash /opt/mhs/lib/core/traktarr/traktarr.sh && clear && primestart ;;
    11) clear && bash /opt/mhs/lib/core/plexpatrol/plexpatrol.sh && clear && primestart ;;
    12) clear && bash /opt/mhs/lib/core/interface/settings.sh && clear && primestart ;;
    [zZ]) clear && bash /opt/mhs/lib/core/interface/ending.sh && exit ;;
    *) primestart ;;
  esac
}

primestart
