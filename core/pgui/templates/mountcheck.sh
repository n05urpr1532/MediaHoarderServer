#!/usr/bin/env bash

mountcheckloop() {
  while true; do
    rm -rf /var/mhs/state/emergency/*
    mkdir -p /var/mhs/state/emergency
    gdrivecheck=$(systemctl is-active gdrive)
    gcryptcheck=$(systemctl is-active gcrypt)
    tdrivecheck=$(systemctl is-active tdrive)
    tcryptcheck=$(systemctl is-active tcrypt)
    pgunioncheck=$(systemctl is-active pgunion)
    pgblitzcheck=$(systemctl is-active pgblitz)
    pgmovecheck=$(systemctl is-active pgmove)

    pgblitz=$(systemctl list-unit-files | grep pgblitz.service | awk '{ print $2 }')
    pgmove=$(systemctl list-unit-files | grep pgmove.service | awk '{ print $2 }')
    upper=$(docker ps --format '{{.Names}}' | grep "uploader")
    uppercheck="/opt/mhs/apps-data/uploader/"

    rm -rf /var/mhs/state/pg.blitz && touch /var/mhs/state/pg.blitz

    if [[ "$pgmove" == "enabled" ]]; then
      if [[ "$pgmovecheck" != "active" ]]; then
        echo " 🔴 MOVE" > /var/mhs/state/pg.blitz
      else echo " ✅ MOVE" > /var/mhs/state/pg.blitz; fi
    elif [[ "$pgblitz" == "enabled" ]]; then
      if [[ "$pgblitzcheck" != "active" ]]; then
        echo " 🔴 BLITZ" > /var/mhs/state/pg.blitz
      else echo " ✅ BLITZ" > /var/mhs/state/pg.blitz; fi
    elif [[ -d "$uppercheck" ]]; then
      if [[ "$upper" == "uploader" ]]; then
        echo " ✅ Uploader" > /var/mhs/state/pg.blitz
      else echo " 🔴 Uploader" > /var/mhs/state/pg.blitz; fi
    else
      echo " 🔴 Not Operational UPLOADER" > /var/mhs/state/pg.blitz
    fi

    rm -rf /var/mhs/state/pg.blitz && touch /var/mhs/state/pg.blitz
    if [[ "$upper" == "uploader" ]]; then
      echo " ✅ Uploader" > /var/mhs/state/pg.blitz
    else echo " 🔴 Uploader" > /var/mhs/state/pg.blitz; fi

    config="/opt/mhs/etc/rclone/rclone.conf"
    if grep -q "gdrive" $config; then
      if [[ "$gdrivecheck" != "active" ]]; then
        echo " ⚠ " > /var/mhs/state/pg.gdrive
      else echo " ✅ " > /var/mhs/state/pg.gdrive; fi
    else echo " 🔴 " > /var/mhs/state/pg.gdrive; fi
    if grep -q "gcrypt" $config; then
      if [[ "$gcryptcheck" != "active" ]]; then
        echo " ⚠ " > /var/mhs/state/pg.gcrypt
      else echo " ✅ " > /var/mhs/state/pg.gcrypt; fi
    else echo " 🔴 " > /var/mhs/state/pg.gcrypt; fi
    if grep -q "tdrive" $config; then
      if [[ "$tdrivecheck" != "active" ]]; then
        echo " ⚠ " > /var/mhs/state/pg.tdrive
      else echo " ✅ " > /var/mhs/state/pg.tdrive; fi
    else echo " 🔴 " > /var/mhs/state/pg.tdrive; fi
    if grep -q "tcrypt" $config; then
      if [[ "$tcryptcheck" != "active" ]]; then
        echo " ⚠ " > /var/mhs/state/pg.tcrypt
      else echo " ✅ " > /var/mhs/state/pg.tcrypt; fi
    else echo " 🔴 " > /var/mhs/state/pg.tcrypt; fi
    if grep -q "pgunion" $config; then
      if [[ "$pgunioncheck" != "active" ]]; then
        echo " ⚠ " > /var/mhs/state/pg.union
      else echo " ✅ " > /var/mhs/state/pg.union; fi
    else echo " 🔴 " > /var/mhs/state/pg.union; fi
    # Disk Calculations - 5000000 = 5GB
    leftover=$(df / --local | tail -n +2 | awk '{print $4}')
    diskspace27=0
    if [[ "$leftover" -lt "5000000" ]]; then
      diskspace27=1
      echo "Emergency: Primary DiskSpace Under 5GB - Stopped Downloading Programs (i.e. NZBGET, RuTorrent)" > /var/mhs/state/emergency/message.1
      docker stop nzbget 1> /dev/null 2>&1
      docker stop sabnzbd 1> /dev/null 2>&1
      docker stop rutorrent 1> /dev/null 2>&1
      docker stop deluge 1> /dev/null 2>&1
      docker stop qbittorrent 1> /dev/null 2>&1
      docker stop deluge-vpn 1> /dev/null 2>&1
      docker stop transmission 1> /dev/null 2>&1
      docker stop rflood-vpn 1> /dev/null 2>&1
      docker stop rutorrent-vpn 1> /dev/null 2>&1
      docker stop transmission-vpn 1> /dev/null 2>&1
      docker stop jdownloader2 1> /dev/null 2>&1
      docker stop jd2-openvpn 1> /dev/null 2>&1
    elif [[ "$leftover" -gt "3000000" && "$diskspace27" == "1" ]]; then
      docker start nzbget 1> /dev/null 2>&1
      docker start sabnzbd 1> /dev/null 2>&1
      docker start rutorrent 1> /dev/null 2>&1
      docker start deluge 1> /dev/null 2>&1
      docker start qbittorrent 1> /dev/null 2>&1
      docker start deluge-vpn 1> /dev/null 2>&1
      docker start transmission 1> /dev/null 2>&1
      docker start rflood-vpn 1> /dev/null 2>&1
      docker start rutorrent-vpn 1> /dev/null 2>&1
      docker start transmission-vpn 1> /dev/null 2>&1
      docker start jdownloader2 1> /dev/null 2>&1
      docker start jd2-openvpn 1> /dev/null 2>&1
      rm -rf /var/mhs/state/emergency/message.1
      diskspace27=0
    fi
    ##### Warning for Ports Open with Traefik Deployed
    if [[ $(cat /var/mhs/state/pg.ports) != "Closed" && $(docker ps --format '{{.Names}}' | grep "traefik") == "traefik" ]]; then
      echo "Warning: Traefik deployed with ports open! Server at risk for explotation!" > /var/mhs/state/emergency/message.a
    elif [[ -e "/var/mhs/state/emergency/message.a" ]]; then rm -rf /var/mhs/state/emergency/message.a; fi

    if [[ $(cat /var/mhs/state/pg.ports) == "Closed" && $(docker ps --format '{{.Names}}' | grep "traefik") == "" ]]; then
      echo "Warning: Apps Cannot Be Accessed! Ports are Closed & Traefik is not enabled! Either deploy traefik or open your ports (which is worst for security)" > /var/mhs/state/emergency/message.b
    elif [[ -e "/var/mhs/state/emergency/message.b" ]]; then rm -rf /var/mhs/state/emergency/message.b; fi
    ##### Warning for Bad Traefik Deployment - message.c is tied to traefik showing a status! Do not change unless you know what your doing
    touch /opt/mhs/etc/mhs/traefik.check
    domain=$(cat /var/mhs/state/server.domain)
    cname="portainer"
    if [[ -f "/var/mhs/state/portainer.cname" ]]; then
      cname=$(cat "/var/mhs/state/portainer.cname")
    fi
    wget -q "https://${cname}.${domain}" -O "/opt/mhs/etc/mhs/traefik.check"
    if [[ $(cat /opt/mhs/etc/mhs/traefik.check) == "" && $(docker ps --format '{{.Names}}' | grep "traefik") == "traefik" ]]; then
      echo "Traefik is Not Deployed Properly! Cannot Reach the Portainer SubDomain!" > /var/mhs/state/emergency/message.c
    else
      if [[ -e "/var/mhs/state/emergency/message.c" ]]; then
        rm -rf /var/mhs/state/emergency/message.c
      fi
    fi
    ##### Warning for Traefik Rate Limit Exceeded
    if [[ $(cat /opt/mhs/etc/mhs/traefik.check) == "" && $(docker logs traefik | grep "rateLimited") != "" ]]; then
      echo "$domain's rated limited exceed | Traefik (LetsEncrypt)! Takes upto one week to clear up (or use a new domain)" > /var/mhs/state/emergency/message.d
    else
      if [[ -e "/var/mhs/state/emergency/message.d" ]]; then
        rm -rf /var/mhs/state/emergency/message.d
      fi
    fi
    ##################
    sleep 2
    ################# Generate Output
    echo "" > /var/mhs/state/emergency.log
    if [[ $(ls /var/mhs/state/emergency) != "" ]]; then
      countmessage=0
      while read p; do
        let countmessage++
        echo -n "${countmessage}. " >> /var/mhs/state/emergency.log
        echo "$(cat /var/mhs/state/emergency/$p)" >> /var/mhs/state/emergency.log
      done <<< "$(ls /var/mhs/state/emergency)"
    else
      echo "NONE" > /var/mhs/state/emergency.log
    fi
    sleep 15
  done
}

# keeps the function in a loop
mountcheckloop=0
while [[ "$mountcheckloop" == "0" ]]; do mountcheckloop; done
