#!/usr/bin/env bash
################################################################################
# Base installer - User info
################################################################################

info_start_install() {
  clear
  tee <<- EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎  INSTALLING: Media Hoarder Server - Notice
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

By installing Media Hoarder Server, you are agreeing to the terms and conditions of
the GNU AFFERO GENERAL PUBLIC LICENSE v3 (see LICENSE file).

Everyone is welcome and everyone can help make it better !

		┌─────────────────────────────────────┐
		│                                     |
		│ Thank you for your contributions:   │
		│                                     │
		│ Admin9705, MrDoob,                  │
		│ Davaz, Deiteq, FlickerRate,         │
		│ ClownFused, Sub7Seven, TimeKills,   │
		│ The_Creator, Desimaniac, l3uddz,    │
		│ RXWatcher, Calmcacil, ΔLPHΔ,        │
		│ Maikash, Porkie, CDN_RAGE,          │
		│ hawkinzzz, The_Deadpool             │
		│ BugHunter: Krallenkiller            │
		│                                     │
		│ And all the other guys,             │
		│ if you're not in this list,         |
		| just make a commit xD !             |
		│                                     |
		└─────────────────────────────────────┘

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  sleep 1
}

info_google_drive_tos() {
  tee <<- EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠  !!! READ THIS NOTE !!!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

You are advised that in installing MHS you accept the risk of any data being
transferred to your mounted Google Drive account being removed by Google if you are
illegally using an Education account or not adhering to the GSuite Business
Terms of Service by having less than 5 users.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  timer 5
  user_acknowledge_info
}

info_install_end() {
  local has_previous_version=$1
  clear
  tee <<- EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  figlet -c "$(echo -e "Media\nHoarder\nServer")" | lolcat

  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅  Media Hoarder Server is now installed!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ PASSED ! Operations System    : $(lsb_release -sd)
✅ PASSED ! Processor            : $(lshw -class processor | grep "product" | awk '{print $2,$3,$4,$5,$6,$7,$8,$9}')
✅ PASSED ! CPUs                 : $(lscpu | grep "CPU(s):" | tail +1 | head -1 | awk '{print $2}')
✅ PASSED ! IP from Server       : $(hostname -I | awk '{print $1}')
✅ PASSED ! HDD Space            : $(df -h / --total --local -x tmpfs | grep 'total' | awk '{print $2}')
✅ PASSED ! RAM Space            : $(free -m | grep Mem | awk 'NR=1 {print $2}') MB
EOF

  if [[ "$has_previous_version" == "1" ]]; then
    tee <<- EOF
✅ PASSED ! PG/PTS Backup        : /var/mhs/old-pg-backup/
EOF
  fi

  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
↘️  Start anytime by typing >>> sudo mhs
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
↘️  Want to add a user with UID 1000 then type >>> sudo mhs-user-add
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
}
