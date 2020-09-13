#!/usr/bin/env bash

source /opt/mhs/lib/core/gce/functions/main.sh
##note remove duplicate ips / regions
##rm -rf /var/mhs/state/project.ipregion
##rm -rf /var/mhs/state/project.ipaddress

regioncenter() {

  pnum=0
  mkdir -p /var/mhs/state/prolist
  rm -r /var/mhs/state/prolist/*

  echo "" > /var/mhs/state/prolist/final.sh
  gcloud compute regions list | awk '{print $1}' | tail -n +2 > /var/mhs/state/prolist/1.output
  awk '{print substr($0, 1, length($0)-1)}' /var/mhs/state/prolist/1.output > /var/mhs/state/prolist/2.output
  sort -u /var/mhs/state/prolist/2.output > /var/mhs/state/prolist/1.output

  while read p; do
    let "pnum++"
    echo "$p" > "/var/mhs/state/prolist/$pnum"
    echo "[$pnum] $p" >> /var/mhs/state/prolist/final.sh
  done < /var/mhs/state/prolist/1.output

  typed2=999999999
  profinal=$(cat /var/mhs/state/prolist/final.sh)
  while [[ "$typed2" -lt "1" || "$typed2" -gt "$pnum" ]]; do

    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Select a GCE Region
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[ $profinal ]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

    read -r -p 'Type Number | Press [ENTER]: ' typed2 < /dev/tty
    if [[ "$typed2" == "exit" || "$typed2" == "Exit" || "$typed2" == "EXIT" || "$typed2" == "z" || "$typed2" == "Z" ]]; then projectinterface; fi
  done

  typed=$(cat /var/mhs/state/prolist/$typed2)
  echo $typed > /var/mhs/state/project.ipregion

  gcloud compute zones list | grep $typed | head -n1 | awk '{print $2}' > /var/mhs/state/project.ipregion

  echo
  variablepull
  gcloud compute addresses create pg-gce --region $ipregion --project $projectid
  gcloud compute zones list | grep $typed | head -n1 | awk '{print $1}' > /var/mhs/state/project.ipzone
  gcloud compute addresses list | grep pg-gce | awk '{print $2}' > /var/mhs/state/project.ipaddress

  echo
  read -r -p '↘️  IP Address & Region Set | Press [ENTER] ' typed < /dev/tty

}
