#!/usr/bin/env bash

program=$(cat /tmp/program_var)
cname=$program

if [[ -f "/var/mhs/state/$program.cname" ]]; then
  cname=$(cat /var/mhs/state/$program.cname)
fi

domain=$(cat /var/mhs/state/server.domain)
port=$(cat /tmp/program_port)
ip=$(cat /var/mhs/state/server.ip)
ports=$(cat /var/mhs/state/server.ports)
hdpath=$(cat /var/mhs/state/server.hd.path)

if [ "$program" == "plex" ]; then extra="/web"; else extra=""; fi

tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 Access Configuration Info
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

tee <<- EOF
▫ $program:${port} <- Use this as the url when connecting another app to $program.
EOF

if [ "$ports" == "" ]; then
  tee <<- EOF
▫ $ip:${port}${extra}
EOF
fi

if [ "$domain" != "NOT-SET" ]; then
  if [ "$ports" == "" ]; then
    tee <<- EOF
▫ $domain:${port}${extra}
EOF
  fi
  tee <<- EOF
▫ $cname.$domain${extra}
EOF
fi

if [ "$program" == "plex" ]; then
  tee <<- EOF

First Time Plex Claim Notice
━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  if [ "$domain" != "NOT-SET" ]; then
    tee <<- EOF
▫ http://plex.${domain}:32400 <-- Use http; not https
EOF
  fi

  tee <<- EOF
▫ $ip:${port}${extra}
EOF
fi

if [[ "$program" == *"sonarr"* ]] || [[ "$program" == *"radarr"* ]] || [[ "$program" == *"lidarr"* ]]; then
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💬 Manual Configuration Required
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  $program requires additional manual configuration!
EOF
  if [[ "$program" == *"sonarr"* ]] || [[ "$program" == *"radarr"* ]] || [[ "$program" == *"lidarr"* ]] || [[ "$program" == *"qbittorrent"* ]]; then
    tee <<- EOF

  $program requires "downloader mappings" to enable hardlinking and rapid importing.

  If you do not have these mappings, $program can't rename and move the files on import.
  This will result in files being copied instead of moved, and it will cause other issues.

  The mappings are on the download client settings (advanced setting), at the bottom of the page.

  Visit https://github.com/n05urpr1532-MHA-Team/PTS-Team/wiki/Remote-Path-Mappings for more information.

EOF
  fi
  tee <<- EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠ Failure to perform manual configuration changes will cause problems!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🌍 Visit the wiki for instructions on how to configure $program.

 https://github.com/n05urpr1532-MHA-Team/PTS-Team/wiki/$program

EOF
fi

####--------

if [[ "$program" == *"sabnzbd"* ]] || [[ "$program" == *"nzbget"* ]]; then
  cclean=$(cat /var/mhs/state/cloneclean)
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💬 NOTE / INFO
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  for incomplete downloads $program used the folder $hdpath/incomplete/nzb
  for finished downloads $program used the folder $hdpath/downloads/nzb

  beware the cloneclean is set to $cclean min

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
fi

if [[ "$program" == *"sabnzbd"* ]]; then

  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💬 sabnzbd api_key = $sbakey
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
fi
if [[ "$program" == *"rutorrent"* ]] || [[ "$program" == *"qbittorrent"* ]] || [[ "$program" == *"deluge"* ]]; then
  cclean=$(cat /var/mhs/state/cloneclean)
  tclean=$(($cclean * 2))
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💬 NOTE / INFO
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  for incomplete downloads $program used the folder $hdpath/incomplete/torrent
  for finished downloads $program used the folder $hdpath/downloads/torrent

  beware the cloneclean is set to $tclean min

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
fi
if [ "$program" == "plex" ]; then
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💬 Manual Configuration Required
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

we prefer using plex_autoscan, unlike other alternatives,
that does not put a lot of pressure on the API of your Google Account.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
fi

if [ "$hdpath" != "/mnt" ]; then
  sbakey=$(cat /opt/mhs/apps-data/sabnzbd/sabnzbd.ini | grep "api_key" | head -n 1 | awk '{print $3}')
  tee <<- EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
You must add /mnt self to the docker container again
Your $hdpath is not /mnt
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
fi
