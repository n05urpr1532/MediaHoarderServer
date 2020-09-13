#!/usr/bin/env bash

emailgen() {

  rm -rf /var/mhs/state/.emailbuildlist 1> /dev/null 2>&1
  rm -rf /var/mhs/state/.emaillist 1> /dev/null 2>&1

  ls -la /opt/mhs/etc/mhs/.blitzkeys | awk '{print $9}' | tail -n +4 > /var/mhs/state/.emailbuildlist
  while read p; do
    cat /opt/mhs/etc/mhs/.blitzkeys/$p | grep client_email | awk '{print $2}' | sed 's/"//g' | sed 's/,//g' >> /var/mhs/state/.emaillist
  done < /var/mhs/state/.emailbuildlist

  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 EMail Share Generator
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

PURPOSE: Share out the service accounts for the TeamDrives.
Failing to do so will result in Blitz Failing!

Shortcut to Google Team Drives

NOTE 1: Share the E-Mails with the CORRECT TEAMDRIVE: $tdname
NOTE 2: SAVE TIME! Copy & Paste the all the E-Mails into the share!"

EOF
  cat /var/mhs/state/.emaillist
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  read -rp '↘️  Completed? | Press [ENTER] ' typed < /dev/tty
  clonestart

}
