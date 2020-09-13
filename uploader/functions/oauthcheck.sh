#!/usr/bin/env bash

oauthcheck() {
  uploadervars

  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Conducting Validation Checks: $oauthcheck
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  rcheck=$(rclone lsd --config /opt/mhs/etc/mhs/.$oauthcheck $oauthcheck: | grep -oP mhs | head -n1)
  if [[ "$rcheck" != "mhs" ]]; then
    rclone mkdir --config /opt/mhs/etc/mhs/.$oauthcheck $oauthcheck:/mhs
    rcheck=$(rclone lsd --config /opt/mhs/etc/mhs/.$oauthcheck $oauthcheck: | grep -oP mhs | head -n1)
  fi

  if [ "$rcheck" != "mhs" ]; then
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔  Validation Checks Failed: $oauthcheck
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTES:

[1] Did you set up your $oauthcheck accordingly to the wiki?
[2] Is your project active?

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    rm -rf /opt/mhs/etc/mhs/.$oauthcheck 1> /dev/null 2>&1

    if [[ "$oauthcheck" == "gdrive" ]]; then rm -rf /opt/mhs/etc/mhs/.gcrypt 1> /dev/null 2>&1; fi
    if [[ "$oauthcheck" == "tdrive" ]]; then rm -rf /opt/mhs/etc/mhs/.tcrypt 1> /dev/null 2>&1; fi

    read -p '↘️  Acknowledge Info | Press [ENTER] ' typed2 < /dev/tty
    clonestart
  else
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Validation Checks Passed - $oauthcheck
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  fi
}
