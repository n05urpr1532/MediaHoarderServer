#!/usr/bin/env bash

touch /var/mhs/state/plex.updaterole
touch /var/mhs/state/plex.server
touch /var/mhs/state/plex.claim
# FUNCTIONS START ##############################################################

# BAD INPUT
badinput() {
  echo
  read -p '⛔️ ERROR - BAD INPUT! | PRESS [ENTER] ' typed < /dev/tty
}

start0() {
  setserver
  claim
  updateplexlsio
}

# FUNCTIONS END  #############################################################

# SETVALUE START #############################################################
setserver() {
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎  PLEX Installer
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
NOTE: DO NOT SELECT LOCAL SYSTEM for a REMOTE SERVER outside of your
network as in using Hetzner, WholeSale Internet & Etc!
If you do it , it will not work and you will have to reinstall PLEX!

[1] Plex Remote System ~ OUTSIDE your LOCAL NETWORK (i.e 3rd Party)

[2] Plex Local System  ~ INSIDE  your LOCAL NETWORK (i.e Home)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  read -p '↘️  Type Number | Press [ENTER]: ' typed < /dev/tty

  case $typed in

    1) echo "remote" > /var/mhs/state/plex.server ;;
    2) echo "local" > /var/mhs/state/plex.server ;;
    *) badinput ;;
  esac
}

# THIRD QUESTION
claim() {
  tee <<- EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 Remote Plex Server - Claim the Plex Server
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

To Claim the Plex Server, visit https://www.plex.tv/claim/ and input the
code below! You have 5 minutes to do so!

If you are reinstalling plex with existing appdata press enter to skip
this step as you won't need to claim it again.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  read -p 'Plex Server Claim Number | Press [ENTER]: ' typed < /dev/tty
  echo $typed > /var/mhs/state/plex.claim

  #####LSIO part
  plexcontainerversion=$(cat /var/mhs/state/image/plex)
  if [[ $plexcontainerversion == "linuxserver/plex:latest" ]]; then
    bash /opt/mhs/lib/core/plex/lsio-plex-claim.sh $(cat /var/mhs/state/plex.claim)
  fi
}

### for LSIO UPDATE ROLE docker
updateplexlsio() {
  tee <<- EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 Update Plex Server Automatic Update for Linuxserver.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[ 1 ] docker:
Let Docker handle the Plex Version, we keep our
Dockerhub Endpoint up to date with the latest public builds.
This is the same as leaving this setting out of your create command.

[ 2 ] latest:
will update plex to the latest
version available that you are entitled to.

[ 3 ] public:
will update plexpass users to the latest public version,
useful for plexpass users that don't want to
be on the bleeding edge but still want the latest public updates.
´
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  read -p '↘️  Type Number | Press [ENTER]: ' typed < /dev/tty

  case $typed in
    1) echo "docker" > /var/mhs/state/plex.updaterole ;;
    2) echo "latest" > /var/mhs/state/plex.updaterole ;;
    3) echo "public" > /var/mhs/state/plex.updaterole ;;
    *) badinput ;;
  esac
}

# SETVALUE END ##############################################################
start0
#ansible-playbook /opt/mhs/lib/apps-core/plex.yml
