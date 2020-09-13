#!/usr/bin/env bash

source /opt/mhs/lib/core/gce/functions/main.sh

deployserver() {
  variablepull
  ### checks to make sure common variables are filled out
  deployfail
  ### prevents deployment if one exists!
  servercheck
  if [[ "$gcedeployedcheck" == "DEPLOYED" ]]; then
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 ERROR: GCE Instance Already Detected
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

INFORMATION: The prior GCE Server must be deleted prior to deloying a
another one! Exiting!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    read -r -p '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
    gcestart
  fi

  ### deletes deployed ip if it exists for some odd reason
  #  ipcheck=$(gcloud compute instances list | grep pg-gce | head -n +1 | awk '{print $2}' | grep ".")
  #  if [[ "$ipcheck" != "" ]]; then
  #tee <<-EOF

  #━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  #🚀 Deleting Old IP Address
  #━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  #EOF
  #gcloud compute addresses delete pg-gce --region $ipregion --quiet
  #echo
  #fi

  ### builds mhs firewall if it does not exist
  rulecheck=$(gcloud compute firewall-rules list | grep mhs)
  if [[ "$rulecheck" == "" ]]; then
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Creating Firewall Rules | Does Not Exist
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

    gcloud compute firewall-rules create mhs --allow all
    echo
  fi

  ### checks for template; if it exist; it will delete it
  blueprint=$(gcloud compute instance-templates list | grep pg-gce-blueprint)
  if [ "$blueprint" != "" ]; then
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Deleting Old Template
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    gcloud compute instance-templates delete pg-gce-blueprint --quiet
    echo
  fi
  ### Recalls Variables
  variablepull

  ### Deploys the MHS Template
  gcloud compute instance-templates create pg-gce-blueprint \
  --custom-cpu $processor --custom-memory $ramcount \
  --image-family $osdrive --image-project $imagecount \
  --boot-disk-auto-delete --boot-disk-size 200GB \
  $(tail /var/mhs/state/deploy.nvme)

  # ### Deploys the PG Template
  #gcloud compute instance-templates create pg-gce-blueprint \
  # --custom-cpu $processor --custom-memory $ramcount \
  # --image-family ubuntu-1804-lts --image-project ubuntu-os-cloud \
  # --boot-disk-auto-delete --boot-disk-size 200GB \
  ####note --image-family ubuntu-1804-lts --image-project gce-uefi-images
  #### for shielded vms with ram/drive secure boot

  ### Deploy the GCE Server
  echo
  gcloud compute instances create pg-gce --source-instance-template pg-gce-blueprint --zone $ipzone

  ### Assigning the IP Address to GCE Box
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Finalizing - Assigned IP Address to Instance
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  variablepull
  echo
  gcloud compute instances delete-access-config pg-gce --access-config-name "external-nat" --zone $ipzone --quiet

  echo
  gcloud compute instances add-access-config pg-gce --access-config-name "external-nat" --zone $ipzone --address $ipaddress
  echo
  read -r -p '↘️  Process Complete | Press [ENTER] ' typed < /dev/tty

}
