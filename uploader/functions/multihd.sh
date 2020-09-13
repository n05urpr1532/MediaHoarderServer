#!/usr/bin/env bash

multihdreadonly() {

  # calls up standard variables
  uploadervars

  # removes the temporary variable when starting
  rm -rf /var/mhs/state/.tmp.multihd 1> /dev/null 2>&1

  # reads the list of paths
  while read p; do

    # prevents copying blanks areas
    if [[ "$p" != "" ]]; then
      echo -n "$p=NC:" >> /var/mhs/state/.tmp.multihd
      chown -R 1000:1000 "$p"
      chmod -R 755 "$p"
    fi

  done < /var/mhs/state/multihd.paths

}
