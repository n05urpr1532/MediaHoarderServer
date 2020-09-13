#!/usr/bin/env bash

# NOTES
# Variable recall comes from /functions/variables.sh
################################################################################
executeblitz() {
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
  echo "tdrive" > /var/mhs/state/deploy.version
  echo "bu" > /var/mhs/state/deployed.version
  type=gdrive
  encryptbit=""
  ansible-playbook /opt/mhs/lib/uploader/ymls/drive.yml -e "drive=gdrive"
  type=tdrive
  ansible-playbook /opt/mhs/lib/uploader/ymls/drive.yml -e "drive=tdrive"
  # deploy only if using encryption
  if [[ "$(cat /var/mhs/state/uploader.transport)" == "be" ]]; then
    ansible-playbook /opt/mhs/lib/uploader/ymls/drive.yml -e "drive=gcrypt"
    echo "be" > /var/mhs/state/deployed.version
    type=tcrypt
    encryptbit="C"
    ansible-playbook /opt/mhs/lib/uploader/ymls/drive.yml -e "drive=tcrypt"
  fi
  # builds the list
  ls -la /opt/mhs/etc/mhs/.blitzkeys/ | awk '{print $9}' | tail -n +4 | sort | uniq > /var/mhs/state/.blitzlist
  rm -rf /var/mhs/state/.blitzfinal 1> /dev/null 2>&1
  touch /var/mhs/state/.blitzbuild
  while read p; do
    echo $p > /var/mhs/state/.blitztemp
    if [[ "$(grep "GDSA" /var/mhs/state/.blitztemp)" != "" ]]; then echo $p >> /var/mhs/state/.blitzfinal; fi
  done < /var/mhs/state/.blitzlist
  # deploy union
  ansible-playbook /opt/mhs/lib/uploader/ymls/pgunion.yml -e "transport=$transport type=$type multihds=$multihds encryptbit=$encryptbit"
  ansible-playbook /opt/mhs/lib/uploader/ymls/uploader.yml
  # check if services are active and running
  failed=false

  gdrivecheck=$(systemctl is-active gdrive)
  gcryptcheck=$(systemctl is-active gcrypt)
  tdrivecheck=$(systemctl is-active tdrive)
  tcryptcheck=$(systemctl is-active tcrypt)
  pgunioncheck=$(systemctl is-active pgunion)

  if [[ "$gdrivecheck" != "active" || "$tdrivecheck" != "active" || "$pgunioncheck" != "active" ]]; then failed=true; fi
  if [[ "$gcryptcheck" != "active" || "$tcryptcheck" != "active" ]] && [[ "$transport" == "be" ]]; then failed=true; fi
  if [[ $failed == true ]]; then
    deployFail
  else
    restartapps
    deploySuccess
  fi
}
