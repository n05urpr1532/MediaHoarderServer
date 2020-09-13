#!/usr/bin/env bash

gcestarter() {
  gcloud info | grep Account: | cut -c 10- > /var/mhs/state/project.account

  file="/var/mhs/state/project.final"
  if [ ! -e "$file" ]; then echo "[NOT SET]" > /var/mhs/state/project.final; fi

  file="/var/mhs/state/project.processor"
  if [ ! -e "$file" ]; then echo "NOT-SET" > /var/mhs/state/project.processor; fi

  file="/var/mhs/state/project.location"
  if [ ! -e "$file" ]; then echo "NOT-SET" > /var/mhs/state/project.location; fi

  file="/var/mhs/state/project.ipregion"
  if [ ! -e "$file" ]; then echo "NOT-SET" > /var/mhs/state/project.ipregion; fi

  file="/var/mhs/state/project.ipaddress"
  if [ ! -e "$file" ]; then echo "IP NOT-SET" > /var/mhs/state/project.ipaddress; fi

  file="/var/mhs/state/gce.deployed"
  if [ -e "$file" ]; then
    echo "Server Deployed" > /var/mhs/state/gce.deployed.status
  else echo "Not Deployed" > /var/mhs/state/gce.deployed.status; fi

  project=$(cat /var/mhs/state/project.final)
  account=$(cat /var/mhs/state/project.account)
  processor=$(cat /var/mhs/state/project.processor)
  ipregion=$(cat /var/mhs/state/project.ipregion)
  ipaddress=$(cat /var/mhs/state/project.ipaddress)
  serverstatus=$(cat /var/mhs/state/gce.deployed.status)
}
