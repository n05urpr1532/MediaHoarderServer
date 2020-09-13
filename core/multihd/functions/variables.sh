#!/usr/bin/env bash

rolevars() {
  mkdir -p /var/mhs/state/

  variable() {
    file="$1"
    if [ ! -e "$file" ]; then echo "$2" > $1; fi
  }

  variablet() {
    file="$1"
    if [ ! -e "$file" ]; then touch "$1"; fi
  }

  # set variables if they do not exist
  variable /var/mhs/state/vfs_rcsl "2048M"
  vfs_rcsl=$(cat /var/mhs/state/vfs_rcsl)
  variable /var/mhs/state/multihd.paths ""

}
