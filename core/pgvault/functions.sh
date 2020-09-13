#!/usr/bin/env bash

# BAD INPUT
badinput() {
  echo
  read -r -p '⛔️ ERROR - Bad Input! | Press [ENTER] ' typed < /dev/tty
}

badinput1() {
  echo
  read -r -p '⛔️ ERROR - Bad Input! | Press [ENTER] ' typed < /dev/tty
  question1
}

variable() {
  file="$1"
  if [ ! -e "$file" ]; then echo "$2" > $1; fi
}

removemounts() {
  ansible-playbook /opt/mhs/lib/core/remove/mounts.yml
}

readrcloneconfig() {
  touch /opt/mhs/etc/rclone/rclone.conf
  mkdir -p /var/mhs/state/rclone/

  gdcheck=$(cat /opt/mhs/etc/rclone/rclone.conf | grep gdrive)
  if [ "$gdcheck" != "" ]; then
    echo "good" > /var/mhs/state/rclone/gdrive.status && gdstatus="good"
  else echo "bad" > /var/mhs/state/rclone/gdrive.status && gdstatus="bad"; fi

  gccheck=$(cat /opt/mhs/etc/rclone/rclone.conf | grep "remote = gdrive:/encrypt")
  if [ "$gccheck" != "" ]; then
    echo "good" > /var/mhs/state/rclone/gcrypt.status && gcstatus="good"
  else echo "bad" > /var/mhs/state/rclone/gcrypt.status && gcstatus="bad"; fi

  tdcheck=$(cat /opt/mhs/etc/rclone/rclone.conf | grep tdrive)
  if [ "$tdcheck" != "" ]; then
    echo "good" > /var/mhs/state/rclone/tdrive.status && tdstatus="good"
  else echo "bad" > /var/mhs/state/rclone/tdrive.status && tdstatus="bad"; fi

}

rcloneconfig() {
  rclone config --config /opt/mhs/etc/rclone/rclone.conf
}

keysprocessed() {
  mkdir -p /opt/mhs/etc/rclone/keys/processed
  ls -1 /opt/mhs/etc/rclone/keys/processed | wc -l > /var/mhs/state/project.keycount
}
