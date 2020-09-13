#!/usr/bin/env bash
# FUNCTIONS START ##############################################################
rmoldinstall() {
  dcheck=$(systemctl is-active plex_autoscan.service)
  if [[ "$dcheck" == "active" ]]; then
    service plex_autoscan stop
    rm -rf /opt/mhs/apps-data/plexautoscan
    rm -rf /etc/systemd/system/plex_autoscan.service
    rm -rf /var/mhs/state/pgscan
    fresh
  else fresh; fi
}
fresh() {
  mkdir -p /var/mhs/state/pgscan
  echo "en" > /var/mhs/state/pgscan/fixmatch.lang
  echo "false" > /var/mhs/state/pgscan/fixmatch.status
  echo "NOT-SET" > /var/mhs/state/pgscan/plex.docker
}
variable() {
  file="$1"
  if [[ ! -e "$file" ]]; then echo "$2" > $1; fi
}
deploycheck() {
  dcheck=$(docker ps --format '{{.Names}}' | grep "plexautoscan")
  if [[ "$dcheck" == "plexautoscan" ]]; then
    dstatus="✅ DOCKER DEPLOYED"
  else dstatus="⚠️ DOCKER NOT DEPLOYED"; fi
}
tokenstatus() {
  ptokendep=$(cat /var/mhs/state/pgscan/plex.token)
  if [[ "$ptokendep" != "" ]]; then
    if [[ ! -f "/opt/mhs/apps-data/plexautoscan/config/config.json" ]]; then
      pstatus="❌ TOKEN DEPLOYED || PAS CONFIG MISSING"
    else
      PGSELFTEST=$(curl -LI "http://$(hostname -I | awk '{print $1}'):32400/system?X-Plex-Token=$(cat /opt/mhs/apps-data/plexautoscan/config/config.json | jq .PLEX_TOKEN | sed 's/"//g')" -o /dev/null -w '%{http_code}\n' -s)
      if [[ $PGSELFTEST -ge 200 && $PGSELFTEST -le 299 ]]; then
        pstatus="✅ TOKEN DEPLOYED"
      else pstatus="❌ DOCKER DEPLOYED || PAS TOKEN FAILED"; fi
    fi
  else pstatus="⚠️ NOT DEPLOYED"; fi
}
plexcheck() {
  pcheck=$(docker ps --format '{{.Names}}' | grep "plex")
  if [[ "$pcheck" == "" ]]; then
    printf '
	━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
	⛔️  WARNING! - Plex is Not Installed or Running! Exiting!
	━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
	'
    dontwork
  fi
}
token() {
  touch /var/mhs/state/pgscan/plex.token
  ptoken=$(cat /var/mhs/state/pgscan/plex.token)
  if [[ ! -f "$ptoken" ]]; then
    tokencreate
    sleep 2
    X_PLEX_TOKEN=$(sudo cat "/opt/mhs/apps-data/plex/database/Library/Application Support/Plex Media Server/Preferences.xml" | sed -e 's;^.* PlexOnlineToken=";;' | sed -e 's;".*$;;' | tail -1)
    ptoken=$(cat /var/mhs/state/pgscan/plex.token)
    if [[ "$ptoken" != "$X_PLEX_TOKEN" ]]; then
      printf '
	━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
	⛔️  WARNING!  Failed to Generate a Valid Plex Token!
	⛔️  WARNING!  Exiting Deployment!
	━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
	'
      dontwork
    fi
  fi
}
tokencreate() {
  printf '
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 START Plex_AutoScan Token Create
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
'

  templatebackup=/opt/mhs/lib/core/pgscan/templates/config.backup
  template=/opt/mhs/lib/core/pgscan/templates/config.json.j2
  X_PLEX_TOKEN=$(sudo cat "/opt/mhs/apps-data/plex/database/Library/Application Support/Plex Media Server/Preferences.xml" | sed -e 's;^.* PlexOnlineToken=";;' | sed -e 's;".*$;;' | tail -1)

  cp -r $template $templatebackup
  echo $X_PLEX_TOKEN > /var/mhs/state/pgscan/plex.token

  printf '
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ FINISHED Plex_AutoScan Token  🚀 START SERVERPASS Create
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
'

  RAN=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
  echo $RAN > /var/mhs/state/pgscan/pgscan.serverpass

  printf '
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ FINISHED Plex_AutoScan Token || SERVERPASS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
'

  timerremove
  question1
}
badinput() {
  echo
  read -p '⛔️ ERROR - BAD INPUT! | PRESS [ENTER] ' typed < /dev/tty
  clear && question1
}
dontwork() {
  echo
  read -p 'Confirm Info | PRESS [ENTER] ' typed < /dev/tty
  clear && exit 0
}
works() {
  echo
  read -p 'Confirm Info | PRESS [ENTER] ' typed < /dev/tty
  clear && question1
}
credits() {
  clear
  printf '
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Plex_AutoScan Credits
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

#########################################################################
# Author:   l3uddz                                                      #
# URL:      https://github.com/l3uddz/plex_autoscan                     #
# Coder of plex_autoscan                                                #
# --                                                                    #
# Author(s):     l3uddz, desimaniac                                     #
# URL:           https://github.com/cloudbox/cloudbox                   #
# Coder of plex_autoscan role                                           #
# --                                                                    #
#         Part of the Cloudbox project: https://cloudbox.works          #
#########################################################################
#                   GNU General Public License v3.0                     #
#########################################################################
'
  read -p 'Confirm Info | PRESS [ENTER] ' typed < /dev/tty
  clear && question1
}
doneenter() {
  echo
  read -p 'All done | PRESS [ENTER] ' typed < /dev/tty
  clear && question1
}

####REMOVEPART start
# KEY VARIABLE RECALL & EXECUTION
timerremove() {
  seconds=10
  date1=$(($(date +%s) + $seconds))
  while [ "$date1" -ge $(date +%s) ]; do
    echo -ne "$(date -u --date @$(($date1 - $(date +%s))) +%H:%M:%S)\r"
  done
}
remove() {
  dcheck=$(docker ps --format '{{.Names}}' | grep "plexautoscan")
  if [[ "$dcheck" == "plexautoscan" ]]; then
    removepas
  else
    notinstalled
  fi
}

removepas() {
  printf '
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 STARTING Remove Plex AutoScan Docker  || l3uddz/plex_autoscan
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
'

  docker stop plexautoscan
  docker rm plexautoscan
  rm -rf /opt/mhs/apps-data/plexautoscan
  rm -rf /var/mhs/state/pgscan
  fresh
  echo "en" > /var/mhs/state/pgscan/fixmatch.lang
  echo "false" > /var/mhs/state/pgscan/fixmatch.status
  echo "NOT-SET" > /var/mhs/state/pgscan/plex.docker

  printf '
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 FINISHED REMOVE Plex AutoScan Docker
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
'
  timerremove
  question1
}
notinstalled() {

  printf '
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  WARNING! - PAS is Not Installed or Running! Exiting!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
'
  timerremove
  question1
}
##### REMOVE END
logger() {
  dcheck=$(docker ps --format '{{.Names}}' | grep "plexautoscan")
  if [[ "$dcheck" == "plexautoscan" ]]; then
    printf '
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 ACTIVE LOGS Plex AutoScan Docker  || l3uddz/plex_autoscan
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
'
    tail -n 50 /opt/mhs/apps-data/plexautoscan/config/plex_autoscan.log
    doneenter
  else
    notinstalled
  fi
}

fxmatch() {
  tee <<- EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Plex_AutoScan FixMatching
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
NOTE :
Plex Autoscan will compare the TVDBID/TMDBID/IMDBID sent
by Sonarr/Radarr with what Plex has matched with, and if
this match is incorrect, it will autocorrect the match on the
item (movie file or TV episode). If the incorrect match is
a duplicate entry in Plex, it will auto split the original
entry before correcting the match on the new item.


[1] Fixmatch Lang                     [ $(cat /var/mhs/state/pgscan/fixmatch.lang) ]
[2] Fixmatch on / off                 [ $(cat /var/mhs/state/pgscan/fixmatch.status) ]

[Z] - Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  read -p '↘️  Type Number | Press [ENTER]: ' typed < /dev/tty

  case $typed in
    1) lang && clear && fxmatch ;;
    2) runs && clear && fxmatch ;;
    z) question1 ;;
    Z) question1 ;;
    *) fxmatch ;;
  esac
}
lang() {

  tee <<- EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Plex_AutoScan FixMatching  Lang
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
NOTE : Sample :

this will work :
en
de
jp
ch

Default is "en"

[Z] - Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  read -p '↘️  Type Lang | Press [ENTER]: ' typed < /dev/tty

  if [[ "$typed" == "exit" || "$typed" == "Exit" || "$typed" == "EXIT" || "$typed" == "z" || "$typed" == "Z" ]]; then
    fxmatch
  else
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ SYSTEM MESSAGE:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Language Set Is: $typed

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

    echo $typed > /var/mhs/state/pgscan/fixmatch.lang
    read -p '🌎 Acknowledge Info | Press [ENTER] ' typed < /dev/tty
    fxmatch
  fi
}
runs() {
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Plex_AutoScan Fix Missmatch
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] True
[2] False

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Z] - Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  read -p '↘️  Type Number | Press [ENTER]: ' typed < /dev/tty

  case $typed in
    1) echo "true" > /var/mhs/state/pgscan/fixmatch.status && fxmatch ;;
    2) echo "false" > /var/mhs/state/pgscan/fixmatch.status && fxmatch ;;
    z) fxmatch ;;
    Z) fxmatch ;;
    *) fxmatch ;;
  esac
}
pversion() {
  plexcontainerversion=$(docker ps --format '{{.Image}}' | grep "plex:")
  if [[ "$plexcontainerversion" == "linuxserver/plex:latest" ]]; then
    echo -e "abc" > /var/mhs/state/pgscan/plex.dockeruserset
  else
    echo "plex" > /var/mhs/state/pgscan/plex.dockeruserset
  fi
  pasuserdocker=$(cat /var/mhs/state/pgscan/plex.dockeruserset)

  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Plex Docker
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Linuxserver Docker  used "abc"
Plex        Docker  used "plex"


Plex Docker Image:          [ $plexcontainerversion ]
Set Plex Docker user:       [ $pasuserdocker ]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  cp -r /var/mhs/state/pgscan/plex.dockeruserset /var/mhs/state/pgscan/plex.docker 1> /dev/null 2>&1
  doneenter

}

showuppage() {
  dpas=$(docker ps --format '{{.Names}}' | grep "plexautoscan")
  dtra=$(docker ps --format '{{.Names}}' | grep "traefik")
  if [[ "$dpas" == "plexautoscan" && "$dtra" == "traefik" ]]; then
    showpaspage="http://plexautoscan:3468/$(cat /var/mhs/state/pgscan/pgscan.serverpass)"
  else showpaspage="http://$(cat /var/mhs/state/server.ip):3468/$(cat /var/mhs/state/pgscan/pgscan.serverpass)"; fi
}

question1() {
  dcheck=$(docker ps --format '{{.Names}}' | grep "plexautoscan")
  if [[ "$dcheck" == "plexautoscan" ]]; then
    deplyoed
  else undeployed; fi
}
pasdeploy() {
  ansible-playbook /opt/mhs/lib/core/pgscan/yml/plexautoscan.yml
  clear
}
undeployed() {
  langfa=$(cat /var/mhs/state/pgscan/fixmatch.status)
  lang=$(cat /var/mhs/state/pgscan/fixmatch.lang)
  dplexset=$(cat /var/mhs/state/pgscan/plex.docker)
  tokenstatus
  deploycheck

  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Plex_AutoScan Interface  || l3uddz/plex_autoscan
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] Deploy Plex Token                     [ $pstatus ]
[2] Fixmatch Lang                         [ $lang | $langfa ]
[3] Plex Docker Version                   [ $dplexset ]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[A] Deploy Plex-Auto-Scan Docker          [ $dstatus ]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Z] - Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  read -p '↘️  Type Number | Press [ENTER]: ' typed < /dev/tty

  case $typed in
    1) tokencreate && clear && question1 ;;
    2) fxmatch && clear && question1 ;;
    3) pversion && clear && question1 ;;
    A) pasdeploy && question1 ;;
    a) pasdeploy && question1 ;;
    C) credits && clear && question1 ;;
    c) credits && clear && question1 ;;
    z) exit 0 ;;
    Z) exit 0 ;;
    *) question1 ;;
  esac
}

deplyoed() {
  langfa=$(cat /var/mhs/state/pgscan/fixmatch.status)
  lang=$(cat /var/mhs/state/pgscan/fixmatch.lang)
  dplexset=$(cat /var/mhs/state/pgscan/plex.docker)
  showuppage
  tokenstatus
  deploycheck

  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Plex_AutoScan Interface  || l3uddz/plex_autoscan
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] Deploy Plex Token                     [ $pstatus ]
[2] Fixmatch Lang                         [ $lang | $langfa ]
[3] Plex Docker Version                   [ $dplexset ]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

PAS Webhook ARRs : [ $showpaspage ]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[A] Redeploy Plex-Auto-Scan Docker          [ $dstatus ]

[S] Show last 50 lines of Plex_AutoScan log
[R] Remove Plex_AutoScan
[C] Credits

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[Z] - Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  read -p '↘️  Type Number | Press [ENTER]: ' typed < /dev/tty

  case $typed in
    1) tokencreate && clear && question1 ;;
    2) fxmatch && clear && question1 ;;
    3) pversion && clear && question1 ;;
    A) pasdeploy && question1 ;;
    a) pasdeploy && question1 ;;
    S) logger ;;
    s) logger ;;
    r) removepas ;;
    R) removepas ;;
    C) credits && clear && question1 ;;
    c) credits && clear && question1 ;;
    z) exit 0 ;;
    Z) exit 0 ;;
    *) question1 ;;
  esac
}
# FUNCTIONS END ##############################################################
rmoldinstall
plexcheck
tokenstatus
variable /var/mhs/state/pgscan/fixmatch.lang "en"
variable /var/mhs/state/pgscan/fixmatch.status "false"
variable /var/mhs/state/pgscan/plex.docker "NOT-SET"
deploycheck
question1
