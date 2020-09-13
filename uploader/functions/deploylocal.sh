#!/usr/bin/env bash

# NOTES
# Variable recall comes from /functions/variables.sh
################################################################################
executelocal() {

  # Reset Front Display
  rm -rf /var/mhs/state/deployed.version

  # Call Variables
  uploadervars

  # flush and clear service logs
  cleanlogs
  # This must be called before docker apps are stopped!
  #prunedocker

  # to remove all service running prior to ensure a clean launch
  ansible-playbook /opt/mhs/lib/uploader/ymls/remove.yml

  cleanmounts

  # builds multipath
  multihdreadonly

  # deploy union
  multihds=$(cat /var/mhs/state/.tmp.multihd)
  ansible-playbook /opt/mhs/lib/uploader/ymls/local.yml -e "multihds=$multihds"

  # stores deployed version
  echo "le" > /var/mhs/state/deployed.version

  # check if services are active and running
  failed=false

  pgunioncheck=$(systemctl is-active pgunion)
  if [[ "$pgunioncheck" != "active" ]]; then failed=true; fi

  if [[ $failed == true ]]; then
    deployFail
  else
    restartapps
    deploySuccess
  fi
}
