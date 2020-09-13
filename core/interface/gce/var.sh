#!/usr/bin/env bash

echo 9 > /var/mhs/state/menu.number

gcloud info | grep Account: | cut -c 10- > /var/mhs/state/project.account

file="/var/mhs/state/project.final"
if [ ! -e "$file" ]; then
  echo "[NOT SET]" > /var/mhs/state/project.final
fi

file="/var/mhs/state/project.processor"
if [ ! -e "$file" ]; then
  echo "NOT-SET" > /var/mhs/state/project.processor
fi

file="/var/mhs/state/project.location"
if [ ! -e "$file" ]; then
  echo "NOT-SET" > /var/mhs/state/project.location
fi

file="/var/mhs/state/project.ipregion"
if [ ! -e "$file" ]; then
  echo "NOT-SET" > /var/mhs/state/project.ipregion
fi

file="/var/mhs/state/project.ipaddress"
if [ ! -e "$file" ]; then
  echo "IP NOT-SET" > /var/mhs/state/project.ipaddress
fi

file="/var/mhs/state/gce.deployed"
if [ -e "$file" ]; then
  echo "Server Deployed" > /var/mhs/state/gce.deployed.status
else
  echo "Not Deployed" > /var/mhs/state/gce.deployed.status
fi
