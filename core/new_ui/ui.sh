#!/usr/bin/env bash
###VRKN_GLOBAL_MAXMIND_LICENSE_KEY
# FUNCTIONS START ##############################################################
variable() {
  file="$1"
  if [[ ! -e "$file" ]]; then echo "$2" >$1; fi
}
base() {
fid1="/var/mhs/state/varken/"
if [[ ! -d "$fid1" ]]; then mkdir -p "$fid1" && apt-get update -yqq; fi
}
api() {
fid="/var/mhs/state/varken/"
if [[ ! -d "$fid" ]]; then mkdir -p "$fid";fi
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📁 VRKN_GLOBAL_MAXMIND_LICENSE_KEY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: In order for this to work, you must retrieve your API Key! Prior to
continuing, please follow the current steps.

MaxMind:

1. Sign up for a MaxMind account. Make sure to verify the account.

2. Go to your Account, then Services >
   My License Key in the side menu, then click "Generate New License Key".

3. Enter a License key description,
   and select "No" for "Will this key be used for GeoIP Update?", then click "Confirm".

4. Enter your License Key of MaxMind

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  read -p '↘️ Type License Key of MaxMind | Press [ENTER]: ' typed </dev/tty
  echo $typed >/var/mhs/state/varken/geoip.key

}
layoutbase() {
filezero="/var/mhs/state/varken/geoip.key"
if [[ ! -f "$filezero" ]]; then
api
else question1; fi
}

apicreate() {
filezero="/var/mhs/state/varken/geoip.key"
if [[ ! -f "$filezero" ]]; then
 echo " ✅ API SET" >/var/mhs/state/varken/api.check
else echo " 🔴 MISSING " >/var/mhs/state/varken/api.check; fi
}
install() {

credits(){
clear
chk=$(figlet MHS - UI | lolcat )
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 MHS UI
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$chk

#########################################################################
# THX to all guys and all dev to create this nice part                  #
# THX to Influx > telegraf > promtail > Loki > Varken > Grafana         #
#                                                                       #
# Author(s):     justinglock40 ( theDockerGuru )                        #
# Layout:        MrDoob ( MainDev of MHS )                              #
# Hunters:       hawkinzz, Porkie, Maikash                              #
#                                                                       #
#                This is only for MHS Members                           #
#########################################################################
#                   GNU General Public License v3.0                     #
#########################################################################
EOF

 echo
  read -p 'Confirm Info | PRESS [ENTER] ' typed </dev/tty
  clear && question1
}

question1() {
status=$(cat /var/mhs/state/varken/api.check)
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 MHS-Varken -EDITION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] MaxmInd API               [ $status ]

[A] Deploy MHS-Varken -EDITION

[R] Remove MHS-Varken -EDITION

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[C] Credits
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Z] - Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  read -p '↘️  Type Number | Press [ENTER]: ' typed </dev/tty

  case $typed in
  1) api && layoutbase ;;
  A) install && clear && question1 ;;
  a) install && clear && question1 ;;
  R) remove && clear && question1 ;;
  r) remove && clear && question1 ;;
  C) credits && clear && question1 ;;
  c) credits && clear && question1 ;;
  z) exit ;;
  Z) exit ;;
  *) question1 ;;
  esac
}
##########################################
base
api
