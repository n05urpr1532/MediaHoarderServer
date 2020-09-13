#!/usr/bin/env bash

uploadervars() {

  variable() {
    file="$1"
    if [ ! -e "$file" ]; then echo "$2" > $1; fi
  }

  touch /var/mhs/state/uagent
  uagentrandom="$(cat /var/mhs/state/uagent)"
  if [[ "$uagentrandom" == "NON-SET" || "$uagentrandom" == "" || "$uagentrandom" == "rclone/v1.*" || "$uagentrandom" == "random" || "$uagentrandom" == "RANDOM" ]]; then
    randomagent=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1)
    uagent=$(cat /var/mhs/state/uagent)
    echo "$randomagent" > /var/mhs/state/uagent
    echo $(sed -e 's/^"//' -e 's/"$//' <<< $(cat /var/mhs/state/uagent)) > /var/mhs/state/uagent
  fi

  touch /var/mhs/state/cloneclean.nzb
  touch /var/mhs/state/cloneclean.torrent
  cleanernzb="$(cat /var/mhs/state/cloneclean.nzb)"
  cleanertorrenet="$(cat /var/mhs/state/cloneclean.torrent)"
  if [[ "$cleanernzb" == "600" || "$cleanernzb" == "" || "$cleanernzb" == "NON-SET" ]]; then echo "600" > /var/mhs/state/cloneclean.nzb; fi
  if [[ "$cleanertorrenet" == "2400" || "$cleanertorrenet" == "" || "$cleanertorrenet" == "NON-SET" ]]; then echo "2400" > /var/mhs/state/cloneclean.torrent; fi

  # rest standard
  mkdir -p /var/mhs/state/rclone
  variable /var/mhs/state/project.account "NOT-SET"
  variable /var/mhs/state/rclone/deploy.version "null"
  variable /var/mhs/state/uploader.transport "NOT-SET"
  variable /var/mhs/state/move.bw "9M"
  # variable /var/mhs/state/blitz.bw "1000M"
  variable /var/mhs/state/uploader.salt ""
  variable /var/mhs/state/multihd.paths ""
  variable /var/mhs/state/server.hd.path "/mnt"
  hdpath="$(cat /var/mhs/state/server.hd.path)"

  gce="/var/mhs/state/gce.check"
  if [[ ! -e $gce ]]; then
    variable /var/mhs/state/blitz.bw "1000M"
  else variable /var/mhs/state/blitz.bw "4500M"; fi

  variable /var/mhs/state/oauth.check ""
  oauthcheck=$(cat /var/mhs/state/oauth.check)

  variable /var/mhs/state/uploader.password "NOT-SET"
  if [[ $(cat /var/mhs/state/uploader.password) == "NOT-SET" ]]; then
    pstatus="NOT-SET"
  else
    pstatus="ACTIVE"
    clonepassword=$(cat /var/mhs/state/uploader.password)
    clonesalt=$(cat /var/mhs/state/uploader.salt)
  fi

  variable /opt/mhs/etc/mhs/.gdrive "NOT-SET"
  if [[ $(cat /opt/mhs/etc/mhs/.gdrive) == "NOT-SET" ]]; then
    gstatus="NOT-SET"
  else gstatus="ACTIVE"; fi

  variable /opt/mhs/etc/mhs/.tdrive "NOT-SET"
  if [[ $(cat /opt/mhs/etc/mhs/.tdrive) == "NOT-SET" ]]; then
    tstatus="NOT-SET"
  else tstatus="ACTIVE"; fi

  variable /opt/mhs/etc/mhs/.tcrypt "NOT-SET"
  if [[ $(cat /opt/mhs/etc/mhs/.tcrypt) == "NOT-SET" ]]; then
    tcstatus="NOT-SET"
  else tcstatus="ACTIVE"; fi

  variable /opt/mhs/etc/mhs/.gcrypt "NOT-SET"
  if [[ $(cat /opt/mhs/etc/mhs/.gcrypt) == "NOT-SET" ]]; then
    gcstatus="NOT-SET"
  else gcstatus="ACTIVE"; fi

  transport=$(cat /var/mhs/state/uploader.transport)

  variable /var/mhs/state/uploader.teamdrive "NOT-SET"
  tdname=$(cat /var/mhs/state/uploader.teamdrive)

  variable /var/mhs/state/uploader.demo "OFF"
  demo=$(cat /var/mhs/state/uploader.demo)

  variable /var/mhs/state/uploader.teamid ""
  tdid=$(cat /var/mhs/state/uploader.teamid)

  variable /var/mhs/state/rclone/deploy.version ""
  type=$(cat /var/mhs/state/rclone/deploy.version)

  variable /var/mhs/state/uploader.public ""
  uploaderpublic=$(cat /var/mhs/state/uploader.public)

  mkdir -p /opt/mhs/etc/mhs/.blitzkeys
  displaykey=$(ls /opt/mhs/etc/mhs/.blitzkeys | wc -l)

  variable /var/mhs/state/uploader.secret ""
  uploadersecret=$(cat /var/mhs/state/uploader.secret)

  if [[ "$uploadersecret" == "" || "$uploaderpublic" == "" ]]; then uploaderid="NOT-SET"; fi
  if [[ "$uploadersecret" != "" && "$uploaderpublic" != "" ]]; then uploaderid="ACTIVE"; fi

  variable /var/mhs/state/uploader.email "NOT-SET"
  uploaderemail=$(cat /var/mhs/state/uploader.email)

  variable /var/mhs/state/oauth.type "NOT-SET" #output for auth type
  oauthtype=$(cat /var/mhs/state/oauth.type)

  variable /var/mhs/state/uploader.project "NOT-SET"
  uploaderproject=$(cat /var/mhs/state/uploader.project)

  variable /var/mhs/state/deployed.version ""
  dversion=$(cat /var/mhs/state/deployed.version)

  variable /var/mhs/state/.tmp.multihd
  multihds=$(cat /var/mhs/state/.tmp.multihd)

  if [[ "$dversion" == "mu" ]]; then
    dversionoutput="Move"
  elif [[ "$dversion" == "me" ]]; then
    dversionoutput="Move: Encrypted"
  elif [[ "$dversion" == "bu" ]]; then
    dversionoutput="Blitz"
  elif [[ "$dversion" == "be" ]]; then
    dversionoutput="Blitz: Encrypted"
  elif [[ "$dversion" == "le" ]]; then
    dversionoutput="Local"
  else dversionoutput="None"; fi

  # # For Clone Clean
  # if [[ ! -e $gce ]]; then
  # variable /var/mhs/state/cloneclean "600"
  # else variable /var/mhs/state/cloneclean "120"; fi

  variable /var/mhs/state/vfs_bs "16M"
  vfs_bs=$(cat /var/mhs/state/vfs_bs)

  variable /var/mhs/state/vfs_dcs "64M"
  vfs_dcs=$(cat /var/mhs/state/vfs_dcs)

  variable /var/mhs/state/vfs_dct "5m"
  vfs_dct=$(cat /var/mhs/state/vfs_dct)

  variable /var/mhs/state/vfs_cm "writes"
  vfs_cm=$(cat /var/mhs/state/vfs_cm)

  variable /var/mhs/state/vfs_cma "1h"
  vfs_cma=$(cat /var/mhs/state/vfs_cma)

  variable /var/mhs/state/vfs_cms "10G"
  vfs_cms=$(cat /var/mhs/state/vfs_cms)

  variable /var/mhs/state/vfs_rcs "64M"
  vfs_rcs=$(cat /var/mhs/state/vfs_rcs)

  variable /var/mhs/state/vfs_rcsl "2048M"
  vfs_rcsl=$(cat /var/mhs/state/vfs_rcsl)

  variable /var/mhs/state/vfs_ll "ERROR"
  vfs_ll=$(cat /var/mhs/state/vfs_ll)

  if [[ ! -e $gce ]]; then
    variable /var/mhs/state/vfs_t "8"
  else variable /var/mhs/state/vfs_t "16"; fi
  vfs_t=$(cat /var/mhs/state/vfs_t)

  if [[ ! -e $gce ]]; then
    variable /var/mhs/state/vfs_c "16"
  else variable /var/mhs/state/vfs_c "32"; fi
  vfs_c=$(cat /var/mhs/state/vfs_c)

  if [[ ! -e $gce ]]; then
    variable /var/mhs/state/vfs_mt "350G"
  else variable /var/mhs/state/vfs_mt "720G"; fi
  vfs_mt=$(cat /var/mhs/state/vfs_mt)

  if [[ ! -e $gce ]]; then
    variable /var/mhs/state/vfs_test "4G"
  else variable /var/mhs/state/vfs_test "16G"; fi
  vfs_test=$(cat /var/mhs/state/vfs_test)

  # For BWLimit
  if [[ ! -e $gce ]]; then
    variable /var/mhs/state/timetable.bw "14:00,40M"
  else variable /var/mhs/state/timetable.bw "off"; fi

  # Upgrade old var format to new var format

  echo $(sed -e 's/^"//' -e 's/"$//' <<< $(cat /var/mhs/state/uagent)) > /var/mhs/state/uagent
  if [[ $(cat /var/mhs/state/blitz.bw) != *"M"* && $(cat /var/mhs/state/blitz.bw) != 0 ]]; then echo "$(cat /var/mhs/state/blitz.bw)M" > /var/mhs/state/blitz.bw; fi
  if [[ $(cat /var/mhs/state/move.bw) != *"M"* && $(cat /var/mhs/state/move.bw) != 0 ]]; then echo "$(cat /var/mhs/state/move.bw)M" > /var/mhs/state/move.bw; fi
  if [[ $(cat /var/mhs/state/vfs_bs) != *"M" ]]; then echo "$(cat /var/mhs/state/vfs_bs)M" > /var/mhs/state/vfs_bs; fi
  if [[ $(cat /var/mhs/state/vfs_dcs) != *"M" ]]; then echo "$(cat /var/mhs/state/vfs_dcs)M" > /var/mhs/state/vfs_dcs; fi
  if [[ $(cat /var/mhs/state/vfs_dct) != *"m" ]]; then echo "$(cat /var/mhs/state/vfs_dct)m" > /var/mhs/state/vfs_dct; fi
  if [[ $(cat /var/mhs/state/vfs_cma) != *"h" ]]; then echo "1h" > /var/mhs/state/vfs_cma; fi
  if [[ $(cat /var/mhs/state/vfs_cms) != *"G" && $(cat /var/mhs/state/vfs_cms) != "off" ]]; then echo "off" > /var/mhs/state/vfs_cms; fi
  if [[ $(cat /var/mhs/state/vfs_rcs) != *"M" ]]; then echo "$(cat /var/mhs/state/vfs_rcs)M" > /var/mhs/state/vfs_rcs; fi
  if [[ $(cat /var/mhs/state/vfs_rcsl) != *"M" && $(cat /var/mhs/state/vfs_rcsl) != "off" ]]; then echo "2048M" > /var/mhs/state/vfs_rcsl; fi
}
