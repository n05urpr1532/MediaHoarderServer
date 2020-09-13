#!/usr/bin/env bash

### assists in creating default variables if they do not exist
variable() {
  file="$1"
  if [ ! -e "$file" ]; then echo "$2" > $1; fi
}

### key variable pull
variablepull() {

  ### sets variables if they do not exist
  variable /var/mhs/state/project.account NOT-SET
  variable /var/mhs/state/project.ipaddress NOT-SET
  variable /var/mhs/state/project.ipregion NOT-SET
  variable /var/mhs/state/project.ipzone NOT-SET
  variable /var/mhs/state/project.processor NOT-SET
  variable /var/mhs/state/project.ram NOT-SET
  variable /var/mhs/state/project.nvme NOT-SET
  variable /var/mhs/state/project.imagecount NOT-SET
  variable /var/mhs/state/project.image NOT-SET
  variable /var/mhs/state/project.id NOT-SET
  variable /var/mhs/state/project.switch off

  ### variables being called

  #account=$(cat /var/mhs/state/project.account)
  account=$(gcloud config configurations list | tail -n 1 | awk '{print $3}')
  if [[ "$account" != "" ]]; then echo $account > /var/mhs/state/project.account; fi

  ipaddress=$(cat /var/mhs/state/project.ipaddress)
  ipregion=$(cat /var/mhs/state/project.ipregion)
  ipzone=$(cat /var/mhs/state/project.ipzone)
  nvmecount=$(cat /var/mhs/state/project.nvme)
  ramcount=$(cat /var/mhs/state/project.ram)
  processor=$(cat /var/mhs/state/project.processor)
  imagecount=$(cat /var/mhs/state/project.imagecount)
  osdrive=$(cat /var/mhs/state/project.image)

  # if user switches usernames, this turns on. turns of when user sets project again
  switchcheck=$(cat /var/mhs/state/project.switch)
  if [[ "$switchcheck" != "on" ]]; then
    projectid=$(gcloud config configurations list | tail -n 1 | awk '{print $4}')
    if [[ "$projectid" != "" ]]; then echo $projectid > /var/mhs/state/project.id; fi
  fi

  serverstatus=serverstatus
  sshstatus=notready
}

servercheck() {

  gcedeployedcheck="NOT DEPLOYED"
  minicheck=$(cat /var/mhs/state/project.id)
  if [[ "$minicheck" != "NOT-SET" ]]; then

    temp55=$(gcloud compute instances list | grep pg-gce)
    if [[ "$temp55" != "" ]]; then gcedeployedcheck="DEPLOYED"; fi

  fi
}
