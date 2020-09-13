#!/usr/bin/env bash

# Starting Actions

startscript() {
  while [ 1 ]; do
    rm -rf /var/mhs/state/spaceused.log
    # move and downloads for the UI
    du -sh /mnt/move | awk '{print $1}' >> /var/mhs/state/spaceused.log
    du -sh /mnt/downloads | awk '{print $1}' >> /var/mhs/state/spaceused.log
    sleep 60
  done
}

# keeps the function in a loop
cheeseballs=0
while [[ "$cheeseballs" == "0" ]]; do startscript; done
