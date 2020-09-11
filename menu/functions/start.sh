#!/usr/bin/env bash
#
# Title:      PTS major file
# org.Author(s):  Admin9705 - Deiteq
# Mod from MrDoob for PTS
# GNU:        General Public License v3.0
################################################################################
source /opt/mhs/lib/menu/functions/functions.sh
source /opt/mhs/lib/menu/functions/install.sh

sudocheck() {
  if [[ $EUID -ne 0 ]]; then
    tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  You Must Execute as a SUDO USER (with sudo) or as ROOT!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
    exit 0
  fi
}

downloadpg() {
  rm -rf /opt/mhs/lib
  git clone --single-branch https://github.com/MHA-Team/PTS-Team.git /opt/mhs/lib  1>/dev/null 2>&1
  ansible-playbook /opt/mhs/lib/menu/version/missing_pull.yml
  ansible-playbook /opt/mhs/lib/menu/alias/alias.yml  1>/dev/null 2>&1
  rm -rf /opt/mhs/lib/place.holder >/dev/null 2>&1
  rm -rf /opt/mhs/lib/.git* >/dev/null 2>&1
}

missingpull() {
  file="/opt/mhs/lib/menu/functions/install.sh"
  if [ ! -e "$file" ]; then
    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  Base folder went missing!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    sleep 2
    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 🍖  NOM NOM - Re-Downloading PTS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
    sleep 2
    downloadpg
    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅️  Repair Complete! Standby!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    sleep 2
  fi
}

exitcheck() {
  bash /opt/mhs/lib/menu/version/file.sh
  file="/var/plexguide/exited.upgrade"
  if [ ! -e "$file" ]; then
    bash /opt/mhs/lib/menu/interface/ending.sh
  else
    rm -rf /var/plexguide/exited.upgrade 1>/dev/null 2>&1
    echo ""
    bash /opt/mhs/lib/menu/interface/ending.sh
  fi
}
