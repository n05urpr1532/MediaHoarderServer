#!/usr/bin/env bash

# NOTES
# Variable recall comes from /functions/variables.sh
################################################################################

executemove() {
  # Reset Front Display
  rm -rf /var/mhs/state/deployed.version
  # Call Variables
  uploadervars
  # flush and clear service logs
  cleanlogs
  # to remove all service running prior to ensure a clean launch
  ansible-playbook /opt/mhs/lib/uploader/ymls/remove.yml
  cleanmounts
  buildrcloneenv
  # gdrive deploys by standard
  echo "gdrive" > /var/mhs/state/deploy.version
  echo "mu" > /var/mhs/state/deployed.version
  type=gdrive
  ansible-playbook /opt/mhs/lib/uploader/ymls/drive.yml -e "drive=gdrive"
  # deploy only if pgmove is using encryption
  if [[ "$transport" == "me" ]]; then
    echo "me" > /var/mhs/state/deployed.version
    type=gcrypt
    ansible-playbook /opt/mhs/lib/uploader/ymls/drive.yml -e "drive=gcrypt"
  fi
  # deploy union
  ansible-playbook /opt/mhs/lib/uploader/ymls/pgunion.yml -e "transport=$transport multihds=$multihds type=$type"
  ansible-playbook /opt/mhs/lib/uploader/ymls/uploader.yml
  # output final display
  if [[ "$type" == "gdrive" ]]; then
    finaldeployoutput="Move - Unencrypted"
  else finaldeployoutput="Move - Encrypted"; fi
  # check if services are active and running
  failed=false
  gdrivecheck=$(systemctl is-active gdrive)
  gcryptcheck=$(systemctl is-active gcrypt)
  pgunioncheck=$(systemctl is-active pgunion)

  if [[ "$gdrivecheck" != "active" || "$pgunioncheck" != "active" ]]; then failed=true; fi
  if [[ "$gcryptcheck" != "active" && "$transport" == "me" ]]; then failed=true; fi

  if [[ $failed == true ]]; then
    deployFail
  else
    restartapps
    deploySuccess
  fi
}
