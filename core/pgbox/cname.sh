#!/usr/bin/env bash

source /opt/mhs/lib/core/functions/functions.sh

# vars
program=$(cat /tmp/program_var)
domain=$(cat /var/mhs/state/server.domain)

variable /var/mhs/state/"$program".cname "$program"

variable /var/mhs/state/"$program".port ""

# FIRST QUESTION
question1() {
  cname=$(cat /var/mhs/state/$program.cname)
  port=$(cat /var/mhs/state/$program.port)
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⌛ $program - Set subdomains & ports
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  if [[ $port != "" ]]; then
    tee <<- EOF
External Url:     https://$cname.$domain:$port
EOF
  else
    tee <<- EOF
External Url:     https://$cname.$domain
EOF
  fi

  tee <<- EOF

[1] Change subdomain
[2] Change external port

EOF

  if [[ $port != "" ]]; then
    tee <<- EOF
[A] Use https://$cname.$domain:$port
EOF
  else
    tee <<- EOF
[A] Use https://$cname.$domain
EOF
  fi
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  read -r -p '↘️  Type Number | Press [ENTER]: ' typed < /dev/tty
  if [[ "$typed" == "A" || "$typed" == "a" ]]; then
    exit
  elif [ "$typed" == "1" ]; then
    read -r -p "🌍 Type subdomain to use for $program | Press [ENTER]: " typed < /dev/tty

    if [[ "$typed" == "" ]]; then
      badinput1
    else
      if ! [[ "$typed" =~ ^(([a-zA-Z0-9_]|[a-zA-Z0-9_][a-zA-Z0-9_\-]*[a-zA-Z0-9_])\.)*([A-Za-z0-9_]|[A-Za-z0-9_][A-Za-z0-9_\-]*[A-Za-z0-9_](\.?))$ ]]; then
        badinput1
      else
        echo "$typed" > "/var/mhs/state/$program.cname"
        question1
      fi
    fi
  elif [ "$typed" == "2" ]; then
    read -r -p "🌍 Type port 1025-65535 to use for $program | blank for default | Press [ENTER]: " typed < /dev/tty
    if [[ "$typed" == "" ]]; then
      echo "" > "/var/mhs/state/$program.port"
    else
      if ! [[ "$typed" =~ ^[0-9]+$ && "$typed" -ge 1025 && "$typed" -le 65535 ]]; then
        badinput1
      else
        echo "$typed" > "/var/mhs/state/$program.port"
      fi
    fi
    question1
  else badinput1; fi
}

question1

manualuser() {
  while read p; do
    echo "$p" > "/var/mhs/state/$program.cname"
  done < /var/mhs/state/pgbox.buildup
  exit
}
