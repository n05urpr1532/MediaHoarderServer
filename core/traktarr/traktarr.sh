#!/usr/bin/env bash

# KEY VARIABLE RECALL & EXECUTION
mkdir -p /var/mhs/state/traktarr/

# FUNCTIONS START ##############################################################

# FIRST FUNCTION
variable() {
  file="$1"
  if [ ! -e "$file" ]; then echo "$2" > $1; fi
}

deploycheck() {
  dcheck=$(systemctl is-active traktarr.service)
  if [ "$dcheck" == "active" ]; then
    dstatus="✅ DEPLOYED"
  else dstatus="⚠️ NOT DEPLOYED"; fi
}

sonarrcheck() {
  pcheck=$(docker ps --format '{{.Names}}' | grep "sonarr")
  if [ "$pcheck" == "" ]; then

    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  WARNING! - Sonarr is not Installed/Running! Cannot Proceed!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    read -p 'Confirm Info | PRESS [ENTER] ' typed < /dev/tty
    question1
  fi
}

radarrcheck() {
  pcheck=$(docker ps --format '{{.Names}}' | grep "radarr")
  if [ "$pcheck" == "" ]; then

    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  WARNING! - Radarr is not Installed/Running! Cannot Proceed!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    read -p 'Confirm Info | PRESS [ENTER] ' typed < /dev/tty
    question1
  fi
}

squality() {
  sonarrcheck
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📁 Sonarr Profile
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: Type a profile that exists! Check Sonarr's Profiles incase! This is
case senstive! If you mess this up, it will put invalid profiles that do
not exist within Sonarr!

Default Profiles for Sonarr (case senstive):

Any
SD
HD-720p
HD-1080p
Ultra-HD
HD - 720p/1080p
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Go Back? Type > exit

EOF
  read -p '↘️ Type Sonarr Location | Press [ENTER]: ' typed < /dev/tty

  if [[ "$typed" == "exit" || "$typed" == "Exit" || "$typed" == "EXIT" || "$typed" == "z" || "$typed" == "Z" ]]; then
    question1
  else
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ SYSTEM MESSAGE: Sonarr Path Completed!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Quality Set Is: $typed

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

    echo "$typed" > /var/mhs/state/traktarr/pgtrak.sprofile
    read -p '🌎 Acknowledge Info | Press [ENTER] ' typed < /dev/tty
    question1
  fi
}

rquality() {
  radarrcheck
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📁 Radarr Profile
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: Type a profile that exists! Check Raddar's Profiles incase! This is
case senstive! If you mess this up, it will put invalid profiles that do
not exist within Radarr!

Default Profiles for Radarr (case senstive):

Any
SD
HD-720p
HD-1080p
Ultra-HD
HD - 720p/1080p
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Go Back? Type > exit

EOF
  read -p '↘️ Type Radarr Location | Press [ENTER]: ' typed < /dev/tty

  if [[ "$typed" == "exit" || "$typed" == "Exit" || "$typed" == "EXIT" || "$typed" == "z" || "$typed" == "Z" ]]; then
    question1
  else
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ SYSTEM MESSAGE: Radarr Path Completed!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Quality Set Is: $typed

EOF

    echo "$typed" > /var/mhs/state/traktarr/pgtrak.rprofile
    read -p '🌎 Acknowledge Info | Press [ENTER] ' typed < /dev/tty
    question1
  fi
}

api() {
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📁 Trakt API-Key
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: In order for this to work, you must retrieve your API Key! Prior to
continuing, please follow the current steps.

[ 1 ] Visit - https://trakt.tv/oauth/applications
[ 2 ] Click - New Applications
[ 3 ] Name  - Whatever You Like
[ 4 ] Redirect UI - https://google.com
[ 5 ] Permissions - Click /checkin and /scrobble
[ 6 ] Click - Save App
[ 7 ] Copy the Client ID & Secret for the Next Step!

Go Back? Type > exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  read -p '↘️ Type API Client | Press [ENTER]: ' typed < /dev/tty
  echo $typed > /var/mhs/state/traktarr/pgtrak.client
  read -p '↘️ Type API Secret | Press [ENTER]: ' typed < /dev/tty
  echo $typed > /var/mhs/state/traktarr/pgtrak.secret

  if [[ "$typed" == "exit" || "$typed" == "Exit" || "$typed" == "EXIT" || "$typed" == "z" || "$typed" == "Z" ]]; then
    question1
  else
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ SYSTEM MESSAGE: Traktarr API Notice
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: The API Client and Secret is set! Ensure to setup your <paths> and
<profiles> prior to deploying Traktarr.

INFO: Messed up? Rerun this API Interface to update the information!

EOF

    read -p '🌎 Acknowledge Info | Press [ENTER] ' typed < /dev/tty
    question1
  fi
}

spath() {
  hdpath=$(cat /var/mhs/state/server.hd.path)
  tvfolderprint=$(ls -ah $hdpath/unionfs/ | grep -E 'TV*|tv')
  sonarrcheck
  tee <<- EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📁 Sonarr Path
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: In order for this to work, you must set the PATH to where Sonarr is
actively scanning your tv shows.

Possible TV folder

$hdpath/unionfs/ +

$tvfolderprint
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Go Back? Type > exit

EOF
  read -p '↘️ Type Sonarr Location | Press [ENTER]: ' typed < /dev/tty

  if [[ "$typed" == "exit" || "$typed" == "Exit" || "$typed" == "EXIT" || "$typed" == "z" || "$typed" == "Z" ]]; then
    question1
  else
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 SYSTEM MESSAGE: Checking Path $typed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
    sleep 1.5

    ##################################################### TYPED CHECKERS - START
    typed2=$typed
    bonehead=no
    ##### If user forgot to add a / in the beginning, we fix for them
    initial="$(echo $typed | head -c 1)"
    if [ "$initial" != "/" ]; then
      typed="/$typed"
    fi
    ##### If user added a / at the end, we fix for them
    initial="${typed: -1}"
    if [ "$initial" == "/" ]; then
      typed=${typed::-1}
    fi

    ##################################################### TYPED CHECKERS - START
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 SYSTEM MESSAGE: Checking if Location is Valid
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
    sleep 1.5

    mkdir $typed/test 1> /dev/null 2>&1

    file="$typed/test"
    if [ -e "$file" ]; then

      tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ SYSTEM MESSAGE: Sonarr Path Completed!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

      ### Removes /mnt if /mnt/unionfs exists
      #check=$(echo $typed | head -c 12)
      #if [ "$check" == "/mnt/unionfs" ]; then
      #typed=${typed:4}
      #fi

      echo "$typed" > /var/mhs/state/traktarr/pgtrak.spath
      read -p '🌎 Acknowledge Info | Press [ENTER] ' typed < /dev/tty
      echo ""
      question1
    else
      tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔ ALERT: Path $typed DOES NOT Exist! No Changes Made!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Note: Exiting the Process! You must ensure that linux is able to READ
your location.

Advice: Exit MHS and (Test) Type >>> mkdir $typed/testfolder

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
      read -p '🌎 Acknowledge Info | Press [ENTER] ' typed < /dev/tty
      echo "" && question1
    fi
  fi

}

rpath() {
  hdpath=$(cat /var/mhs/state/server.hd.path)
  moviefolderprint=$(ls -ah $hdpath/unionfs/ | grep -E 'Movi*|movi*')
  radarrcheck
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📁 Radarr Path
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: In order for this to work, you must set the PATH to where Radarr is
actively scanning your movies.

Possible Movie folder

$hdpath/unionfs/ +

$moviefolderprint

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Go Back? Type > exit

EOF
  read -p '↘️ Type Radarr Location | Press [ENTER]: ' typed < /dev/tty

  if [[ "$typed" == "exit" || "$typed" == "Exit" || "$typed" == "EXIT" || "$typed" == "z" || "$typed" == "Z" ]]; then
    question1
  else
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 SYSTEM MESSAGE: Checking Path $typed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
    sleep 1.5

    ##################################################### TYPED CHECKERS - START
    typed2=$typed
    bonehead=no
    ##### If user forgot to add a / in the beginning, we fix for them
    initial="$(echo $typed | head -c 1)"
    if [ "$initial" != "/" ]; then
      typed="/$typed"
    fi
    ##### If user added a / at the end, we fix for them
    initial="${typed: -1}"
    if [ "$initial" == "/" ]; then
      typed=${typed::-1}
    fi

    ##################################################### TYPED CHECKERS - START
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 SYSTEM MESSAGE: Checking if Location is Valid
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
    sleep 1.5

    mkdir $typed/test 1> /dev/null 2>&1

    file="$typed/test"
    if [ -e "$file" ]; then

      tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ SYSTEM MESSAGE: Radarr Path Completed!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
      echo "$typed" > /var/mhs/state/traktarr/pgtrak.rpath
      read -p '🌎 Acknowledge Info | Press [ENTER] ' typed < /dev/tty
      echo ""
      question1
    else
      tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔ ALERT: Path $typed DOES NOT Exist! No Changes Made!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Note: Exiting the Process! You must ensure that linux is able to READ
your location.

Advice: Exit MHS and (Test) Type >>> mkdir $typed/testfolder

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
      read -p '🌎 Acknowledge Info | Press [ENTER] ' typed < /dev/tty
      echo "" && question1
    fi
  fi

}
#########################################################################
####Custom parts
#########################################################################
maxyear() {
  ((mnyear = $(date +"%Y") + 1))
  ((mxyear = $(date +"%Y") + 7))

  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Limit the maximum allowed year for traktarr
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Set a Year between [ $mnyear ] and [ $mxyear ]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  read -p '↘️  Type Number | Press [ENTER]: ' typed < /dev/tty
  if [[ "$typed" -ge "$mnyear" && "$typed" -le "$mxyear" ]]; then
    echo "$typed" > /var/mhs/state/traktarr/pgtrakyear.max && question1
  else maxyear; fi
}

minyear() {
  ((mnyear = $(date +"%Y") - 80))
  ((mxyear = $(date +"%Y") - 1))

  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Limit the minimum allowed year for traktarr
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Set a Year between [ $mnyear ] and [ $mxyear ]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  read -p '↘️  Type Number | Press [ENTER]: ' typed < /dev/tty
  if [[ "$typed" -ge "$mnyear" && "$typed" -le "$mxyear" ]]; then
    echo "$typed" > /var/mhs/state/traktarr/pgtrakyear.min && question1
  else minyear; fi
}

lang() {

  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Set language profile for Sonarr
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Language Profile that TV shows are assigned to. Only applies to Sonarr v3.

Note :
you have to write it as it really is,
if you make a mistake, it will not be checked for conformity!
the first letter must be large, otherwise it will not work

Sample:

English
German
France
Spain

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  read -p '↘️  Type your language profile from Sonarr | Press [ENTER]: ' typed < /dev/tty
  echo $typed > /var/mhs/state/traktarr/pgtrak.lang
  if [[ "$typed" == "exit" || "$typed" == "Exit" || "$typed" == "EXIT" || "$typed" == "z" || "$typed" == "Z" ]]; then
    echo -e "English" /var/mhs/state/traktarr/pgtrak.lang
    question1
  else
    clear
    lprofil=$(cat /var/mhs/state/traktarr/pgtrak.lang)
    tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Traktarr Language Profil set
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 You have chosen the language profile =  $lprofil

 If this is wrong now, traktarr will not work 100%
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
    read -p '🌎 Acknowledge Info | Press [ENTER] ' typed < /dev/tty
    question1
  fi
}

avbila() {
  avacbact=$(cat /var/mhs/state/traktarr/pgtrak.minimumavailability)
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Set minimum availability movies for Radarr
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

The minimum availability for movies are actually set to

$avacbact

Choices are announced, in_cinemas, released (Physical/Web), or predb.

[ 1 ] = announced
[ 2 ] = in_cinemas
[ 3 ] = released
[ 4 ] = predb

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  read -p '↘️  Type Number | Press [ENTER]: ' typed < /dev/tty

  case $typed in
    1) echo -e "announced" > /var/mhs/state/traktarr/pgtrak.minimumavailability && question1 ;;
    2) echo -e "in_cinemas" > /var/mhs/state/traktarr/pgtrak.minimumavailability && question1 ;;
    3) echo -e "released" > /var/mhs/state/traktarr/pgtrak.minimumavailability && question1 ;;
    4) echo -e "predb" > /var/mhs/state/traktarr/pgtrak.minimumavailability && question1 ;;
    z) exit ;;
    Z) exit ;;
    *) question1 ;;
  esac
}
##################################################################################
credits() {
  clear
  chk=$(figlet traktarr | lolcat)
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 traktarr Credits
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$chk

#########################################################################
# Author:   l3uddz                                                      #
# URL:      https://github.com/l3uddz/traktarr                          #
# Coder of l3uddz/traktarr                                              #
# --                                                                    #
# Author(s):     l3uddz, desimaniac                                     #
# URL:           https://github.com/cloudbox/cloudbox                   #
# Coder of l3uddz/traktarr role                                         #
# --                                                                    #
#         Part of the Cloudbox project: https://cloudbox.works          #
#########################################################################
#                   GNU General Public License v3.0                     #
#########################################################################
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  echo
  read -p 'Confirm Info | PRESS [ENTER] ' typed < /dev/tty
  question1
}

prefill() {
  clear
  chk=$(figlet traktarr | lolcat)
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 traktarr prefilling the system
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] Prefilling allowed (Runs a daily job that grabs up to 50 shows and
      movies from multiple sources (porkie16 / mrdoob / enormoz / others)
      Warning - this will fill up your queue quickly.

[2] Prefilling disable

[Z] - Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  echo
  read -p 'Confirm Info | PRESS [ENTER] ' typed < /dev/tty

  case $typed in
    1) ansible-playbook /opt/mhs/lib/core/traktarr/traktarr-list/prefillallow.yml && question1 ;;
    2) ansible-playbook /opt/mhs/lib/core/traktarr/traktarr-list/prefillremove.yml && question1 ;;
    z) exit ;;
    Z) exit ;;
    *) question1 ;;
  esac
}
# BAD INPUT
badinput() {
  echo
  read -p '⛔️ ERROR - BAD INPUT! | PRESS [ENTER] ' typed < /dev/tty
  question1
}

endbanner() {
  clear
  chk=$(figlet traktarr | lolcat)
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 traktarr Commands
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$chk

traktarr [COMMAND] [ARGS]...

Commands:
  movie                 Add a single movie to Radarr.
  movies                Add multiple movies to Radarr.
  show                  Add a single show to Sonarr.
  shows                 Add multiple shows to Sonarr.

Args:
  -t, --list-type TEXT               Trakt list to process.
                                     For example:
									 'anticipated', 'trending', 'popular',
									 'person', 'watched', 'played', 'recommended',
                                     'watchlist', or any URL to a list.  [required]

  -l, --add-limit INTEGER            Limit number of movies added to Radarr.
  -d, --add-delay FLOAT              Seconds between each add request to Radarr.  [default: 2.5]
  -s, --sort [rating|release|votes]  Sort list to process.  [default: votes]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  echo
  read -p 'Confirm Info | PRESS [ENTER] ' typed < /dev/tty
  question1
}
#####################################################################################################################################
checkcase() {
  sonarr=$(docker ps --format '{{.Names}}' | grep "sonarr")
  radarr=$(docker ps --format '{{.Names}}' | grep "radarr")
  if [[ "$radarr" == "" ]] && [[ "$sonarr" == "" ]]; then
    tee <<- EOF

		━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
		⛔️  WARNING! - Sonarr/Radarr is not Installed/Running!
		━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

		EOF
    read -p 'Confirm Info | PRESS [ENTER] ' typed < /dev/tty
    exit 0
  elif [[ "$sonarr" == "sonarr" ]] && [[ "$radarr" == "" ]]; then
    echo "⛔  WARNING! - Traktarr will only work for shows! Radarr Not Running!" > /var/mhs/state/traktarr/docker.status
  elif [[ "$radarr" == "radarr" ]] && [[ "$sonarr" == "" ]]; then
    echo "⛔  WARNING! - Traktarr will only work for movies! Sonarr Not Running!" > /var/mhs/state/traktarr/docker.status
  else
    [[ "$radarr" == "radarr" ]] && [[ "$sonarr" == "sonarr" ]]
    echo "🚀 Traktarr - Radarr and Sonarr detected | it will work for both" > /var/mhs/state/traktarr/docker.status
  fi
}

question1() {

  api=$(cat /var/mhs/state/traktarr/pgtrak.secret)
  if [ "$api" == "NOT-SET" ]; then api="NOT-SET"; else api="SET"; fi

  rpath=$(cat /var/mhs/state/traktarr/pgtrak.rpath)
  spath=$(cat /var/mhs/state/traktarr/pgtrak.spath)
  rprofile=$(cat /var/mhs/state/traktarr/pgtrak.rprofile)
  sprofile=$(cat /var/mhs/state/traktarr/pgtrak.sprofile)
  mxyear=$(cat /var/mhs/state/traktarr/pgtrakyear.max)
  mnyear=$(cat /var/mhs/state/traktarr/pgtrakyear.min)
  langprofil=$(cat /var/mhs/state/traktarr/pgtrak.lang)
  avmin=$(cat /var/mhs/state/traktarr/pgtrak.minimumavailability)
  status=$(cat /var/mhs/state/traktarr/docker.status)

  deploycheck

  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Traktarr Interface
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$status

NOTE: Changes Made? Must Redeploy Traktarr when Complete!

[1] Trakt API-Key                       [ $api ]
[2] Sonarr Path                         [ $spath ]
[3] Raddar Path                         [ $rpath ]
[4] Sonarr Profile                      [ $sprofile ]
[5] Radarr Profile                      [ $rprofile ]
[6] Max Year allowed      | Sonarr      [ $mxyear ]
[7] Min Year allowed      | Sonarr      [ $mnyear ]
[8] Lang Profil           | Sonarr      [ $langprofil ]
[9] Minimum Availability  | Radarr      [ $avmin ]

[10] Deploy Traktarr                     [ $dstatus ]

[11] traktarr prefilling the system
[12] traktarr commands

[C] Credits

[Z] - Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  read -p '↘️  Type Number | Press [ENTER]: ' typed < /dev/tty

  case $typed in
    1) api && question1 ;;
    2) spath && question1 ;;
    3) rpath && question1 ;;
    4) squality && question1 ;;
    5) rquality && question1 ;;
    6) maxyear && question1 ;;
    7) minyear && question1 ;;
    8) lang && question1 ;;
    9) avbila && question1 ;;
    10)
      sonarr=$(docker ps --format '{{.Names}}' | grep "sonarr")
      radarr=$(docker ps --format '{{.Names}}' | grep "radarr")
      if [ "$radarr" == "" ] && [ "$sonarr" == "" ]; then
        tee <<- EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  WARNING! - Sonarr or Radarr must be Running!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
        read -p '🌎 Acknowledge Info | Press [ENTER] ' typed < /dev/tty
        question1
      else
        if [ "$sonarr" = "sonarr" ] && [ "$radarr" = "" ]; then
          tee <<- EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  WARNING! - Traktarr will only work for shows! Radarr Not Running!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
          read -p '🌎 Acknowledge Info | Press [ENTER] ' typed < /dev/tty
        fi

        if [ "$radarr" = "radarr" ] && [ "$sonarr" = "" ]; then
          tee <<- EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  WARNING! - Traktarr will only work for movies! Sonarr Not Running!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
          read -p '🌎 Acknowledge Info | Press [ENTER] ' typed < /dev/tty
        fi

        if [ "$radarr" = "radarr" ] && [ "$sonarr" = "sonarr" ]; then
          tee <<- EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Traktarr - Radarr and Sonarr detected | it will work for both
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
          read -p '🌎 Acknowledge Info | Press [ENTER] ' typed < /dev/tty
        fi

        file="/opt/mhs/apps-data/radarr/config.xml"
        if [ -e "$file" ]; then
          info=$(cat /opt/mhs/apps-data/radarr/config.xml)
          info=${info#*<ApiKey>} 1> /dev/null 2>&1
          info1=$(echo ${info:0:32}) 1> /dev/null 2>&1
          echo "$info1" > /var/mhs/state/traktarr/pgtrak.rapi
        fi

        file="/opt/mhs/apps-data/sonarr/config.xml"
        if [ -e "$file" ]; then
          info=$(cat /opt/mhs/apps-data/sonarr/config.xml)
          info=${info#*<ApiKey>} 1> /dev/null 2>&1
          info2=$(echo ${info:0:32}) 1> /dev/null 2>&1
          echo "$info2" > /var/mhs/state/traktarr/pgtrak.sapi
        fi
      fi
      ansible-playbook /opt/mhs/lib/core/mhs.yml --tags traktarr && question1
      ;;

    11) prefill && clear && question1 ;;
    12) endbanner && clear && question1 ;;
    C) credits && clear && question1 ;;
    c) credits && clear && question1 ;;
    z) exit ;;
    Z) exit ;;
    *) question1 ;;
  esac
}

# FUNCTIONS END ##############################################################

checkcase

variable /var/mhs/state/traktarr/pgtrak.client "NOT-SET"
variable /var/mhs/state/traktarr/pgtrak.secret "NOT-SET"
variable /var/mhs/state/traktarr/pgtrak.rpath "NOT-SET"
variable /var/mhs/state/traktarr/pgtrak.spath "NOT-SET"
variable /var/mhs/state/traktarr/pgtrak.sprofile "NOT-SET"
variable /var/mhs/state/traktarr/pgtrak.rprofile "NOT-SET"
variable /var/mhs/state/traktarr/pgtrakyear.max "2022"
variable /var/mhs/state/traktarr/pgtrakyear.min "1990"
variable /var/mhs/state/traktarr/pgtrak.lang "English"
variable /var/mhs/state/traktarr/pgtrak.minimumavailability "released"

deploycheck
question1
