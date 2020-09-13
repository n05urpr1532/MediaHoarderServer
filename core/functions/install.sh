#!/usr/bin/env bash

source /opt/mhs/lib/core/functions/functions.sh
source /opt/mhs/lib/core/functions/serverid.sh
source /opt/mhs/lib/core/functions/emergency.sh
source /opt/mhs/lib/core/functions/serverid.sh
source /opt/mhs/lib/core/functions/update.sh
#######################################################

pginstall() {
  updateprime
  gcecheck
  core aptupdate
  core alias
  core folders
  core dependency
  core mergerfsinstall
  core dockerinstall
  core docstart
  rollingpart
  portainer
  ouroboros
  core motd
  core gcloud
  core cleaner
  core serverid
  core prune
  pgedition
  core mountcheck
  emergency
  pgdeploy
}

############################################################ INSTALLER FUNCTIONS
updateprime() {
  local root_dir="/var/mhs/state"
  mkdir -p ${root_dir}
  chmod 0775 ${root_dir}
  chown 1000:1000 ${root_dir}

  variable ${root_dir}/pgfork.project "UPDATE ME"
  variable ${root_dir}/pgfork.version "changeme"
  variable ${root_dir}/tld.program "portainer"
  variable /opt/mhs/etc/mhs/plextoken ""
  variable ${root_dir}/server.ht ""
  variable ${root_dir}/server.email "NOT-SET"
  variable ${root_dir}/server.domain "NOT-SET"
  variable ${root_dir}/pg.number "New-Install"
  variable ${root_dir}/emergency.log ""
  variable ${root_dir}/pgbox.running ""
  variable ${root_dir}/data.location "/var/mhs/backups"
  variable /var/mhs/state/server.hd.path "/mnt"

  hostname -I | awk '{print $1}' > ${root_dir}/server.ip
  file="${root_dir}/server.hd.path"
  if [[ ! -e "$file" ]]; then echo "/mnt" > ${root_dir}/server.hd.path; fi

  file="${root_dir}/new.install"
  if [[ -f "$file" ]]; then newinstall; fi

  ospgversion=$(lsb_release -si)
  if [[ "$ospgversion" == "Ubuntu" ]]; then
    echo "ubuntu" > ${root_dir}/os.version
  else
    echo "debian" > ${root_dir}/os.version
  fi

  echo "3" > ${root_dir}/pg.mergerfsinstall
  echo "12" > ${root_dir}/pg.aptupdate
  echo "150" > ${root_dir}/pg.preinstall
  echo "24" > ${root_dir}/pg.folders
  echo "16" > ${root_dir}/pg.dockerinstall
  echo "15" > ${root_dir}/pg.server
  echo "1" > ${root_dir}/pg.serverid
  echo "33" > ${root_dir}/pg.dependency
  echo "11" > ${root_dir}/pg.docstart
  echo "2" > ${root_dir}/pg.motd
  echo "115" > ${root_dir}/pg.alias
  echo "3" > ${root_dir}/pg.dep
  echo "3" > ${root_dir}/pg.cleaner
  echo "3" > ${root_dir}/pg.gcloud
  echo "1" > ${root_dir}/pg.amazonaws
  echo "8.4" > ${root_dir}/pg.verionid
  echo "1" > ${root_dir}/pg.installer
  echo "7" > ${root_dir}/pg.prune
  echo "21" > ${root_dir}/pg.mountcheck
  echo "11" > ${root_dir}/pg.watchtower
}
ouroboros() {
  wstatus=$(docker ps --format '{{.Names}}' | grep "watchtower")
  if [[ "$wstatus" == "watchtower" ]]; then
    docker stop watchtower > /dev/null 2>&1
    docker rm watchtower > /dev/null 2>&1
    ansible-playbook /opt/mhs/lib/core/functions/ouroboros.yml
  fi
  ostatus=$(docker ps --format '{{.Names}}' | grep "ouroboros")
  if [[ "$ostatus" != "ouroboros" ]]; then ansible-playbook /opt/mhs/lib/core/functions/ouroboros.yml; fi
}
gcecheck() {
  gcheck=$(dnsdomainname | tail -c 10)
  if [[ "$gcheck" == ".internal" ]]; then
    if [[ "$(tail -n 1 /var/mhs/state/gce.done)" == "1" ]]; then
      tee <<- EOF
        ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        📂  Google Cloud Feeder Edition SET!
        ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
         NVME already mounted on /mnt with size $(df -h /mnt/ --total --local -x tmpfs | grep 'total' | awk '{print $2}')
        ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
		EOF
      echo "YES" > /var/mhs/state/pg.gce
    else bash /opt/mhs/lib/core/pggce/gcechecker.sh; fi
  else echo "NO" > /var/mhs/state/pg.gce; fi
}

rollingpart() {
  touch ${root_dir}/install.roles
  rolenumber=3
  # Roles Ensure that PG Replicates and has once if missing; important for startup, cron and etc
  if [[ $(cat /var/mhs/state/install.roles) != "$rolenumber" ]]; then
    ansible-playbook /opt/mhs/lib/core/pgbox/community/community.yml
    ansible-playbook /opt/mhs/lib/core/pgbox/core/core.yml
    clone
    echo "$rolenumber" > ${root_dir}/install.roles
  fi
}

core() {
  touch ${root_dir}/pg."${1}".stored
  start=$(cat /var/mhs/state/pg."${1}")
  stored=$(cat /var/mhs/state/pg."${1}".stored)
  if [[ "$start" != "$stored" ]]; then
    $1
    cat ${root_dir}/pg."${1}" > ${root_dir}/pg."${1}".stored
  fi
}

alias() {
  ansible-playbook /opt/mhs/lib/core/alias/alias.yml
}
aptupdate() {
  ansible-playbook /opt/mhs/lib/core/mhs.yml --tags update
}
cleaner() {
  ansible-playbook /opt/mhs/lib/core/mhs.yml --tags autodelete,clean,journal
}
dependency() {
  ospgversion=$(cat /var/mhs/state/os.version)
  if [[ "$ospgversion" == "debian" ]]; then
    ansible-playbook /opt/mhs/lib/core/dependency/dependencydeb.yml
  else
    ansible-playbook /opt/mhs/lib/core/dependency/dependency.yml
  fi
}
docstart() {
  ansible-playbook /opt/mhs/lib/core/mhs.yml --tags docstart
}
folders() {
  ansible-playbook /opt/mhs/lib/core/installer/folders.yml
}
prune() {
  ansible-playbook /opt/mhs/lib/core/prune/main.yml
}
gcloud() {
  ansible-playbook /opt/mhs/lib/core/mhs.yml --tags gcloud_sdk
}
mergerfsinstall() {
  ansible-playbook /opt/mhs/lib/core/mhs.yml --tags mergerfsinstall
}
motd() {
  ansible-playbook /opt/mhs/lib/core/motd/motd.yml
}
mountcheck() {
  ansible-playbook /opt/mhs/lib/core/installer/mcdeploy.yml
}
newinstall() {
  rm -rf ${root_dir}/pg.exit 1> /dev/null 2>&1
  file="${root_dir}/new.install"
  if [[ -f "$file" ]]; then
    touch ${root_dir}/pg.number && echo "off" > /tmp/program_source
    file="${root_dir}/new.install"
    if [[ ! -f "$file" ]]; then exit; fi
  fi
}
pgdeploy() {
  touch ${root_dir}/pg.edition && bash /opt/mhs/lib/core/start/start.sh
}
pgedition() {
  file="${root_dir}/project.deployed"
  if [[ ! -e "$file" ]]; then echo "no" > ${root_dir}/project.deployed; fi
  file="${root_dir}/project.keycount"
  if [[ ! -e "$file" ]]; then echo "0" > ${root_dir}/project.keycount; fi
  file="${root_dir}/server.id"
  if [[ ! -e "$file" ]]; then echo "[NOT-SET]" -rf > ${root_dir}/rm; fi
}
portainer() {
  dstatus=$(docker ps --format '{{.Names}}' | grep "portainer")
  if [[ "$dstatus" != "portainer" ]]; then ansible-playbook /opt/mhs/lib/core/functions/portainer.yml; fi
}
# Roles Ensure that PG Replicates and has once if missing; important for startup, cron and etc
pgcore() {
  file="${root_dir}/new.install"
  if [[ -f "$file" ]]; then ansible-playbook /opt/mhs/lib/core/pgbox/core/core.yml; fi
  if [[ -f "$file" ]]; then ansible-playbook /opt/mhs/lib/core/pgbox/community/community.yml; fi
}
clone() {
  file="${root_dir}/new.install"
  if [[ -f "$file" ]]; then
    bash /opt/mhs/lib/uploader/uploader.sh
    sleep 0.1
    bash /opt/mhs/lib/traefik/traefik.sh
  fi
}
dockerinstall() {
  file="${root_dir}/new.install"
  if [[ -f "$file" ]]; then ansible-playbook /opt/mhs/lib/core/mhs.yml --tags docker; fi
}
####EOF###
