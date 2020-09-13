#!/usr/bin/env bash

echo 2 > /var/mhs/state/menu.number

file="/var/mhs/state/server.id"
if [ ! -e "$file" ]; then
  echo NOT-SET > /var/mhs/state/server.id
fi
