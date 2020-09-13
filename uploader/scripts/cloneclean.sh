#!/usr/bin/env bash

if pidof -o %PPID -x "$0"; then
  exit 1
fi

startscript() {
  while true; do

    #NZB
    find "$(cat /var/mhs/state/server.hd.path)/downloads/nzb" -mindepth 1 -type f -amin +"$(cat /var/mhs/state/cloneclean.nzb)" -exec rm -rf {} \; 2> /dev/null
    find "$(cat /var/mhs/state/server.hd.path)/downloads/nzb" -mindepth 1 -type f -size -5M -amin +2 -exec rm -rf {} \; 2> /dev/null
    find "$(cat /var/mhs/state/server.hd.path)/downloads/nzb" -mindepth 1 -type d -empty -exec rm -rf {} \; 2> /dev/null
    find "$(cat /var/mhs/state/server.hd.path)/nzb/" -mindepth 1 -name "*.nzb.*" -type f -amin +60 -exec rm -rf {} \; 2> /dev/null
    #TORRENT
    find "$(cat /var/mhs/state/server.hd.path)/downloads/torrent/" -mindepth 1 -type f -cmin +"$(cat /var/mhs/state/cloneclean.torrent)" -exec rm -rf {} \; 2> /dev/null
    find "$(cat /var/mhs/state/server.hd.path)/downloads/torrent/" -mindepth 1 -type d -empty -amin +"$(cat /var/mhs/state/cloneclean.torrent)" -exec rm -rf {} \; 2> /dev/null
    #ALL
    find "$(cat /var/mhs/state/server.hd.path)/downloads" -mindepth 2 -type d \( ! -name **nzb** ! -name **torrent** ! -name .stfolder ! -name **games** ! -name ebooks ! -name abooks ! -name sonarr** ! -name radarr** ! -name lidarr** ! -name **kids** ! -name **tv** ! -name **movies** ! -name music** ! -name audio** ! -name anime** ! -name software ! -name xxx \) -empty -delete
    find "$(cat /var/mhs/state/server.hd.path)/move/" -mindepth 2 -type d -empty -delete

    sleep 30

    UNWANTED_FILES=(
      '*.nfo'
      '*.jpeg'
      '*.jpg'
      '*.rar'
      '*sample*'
      '*.sh'
      '*.1'
      '*.2'
      '*.3'
      '*.4'
      '*.5'
      '*.6'
      '*.7'
      '*.8'
      '*.9'
      '*.10'
      '*.11'
      '*.12'
      '*.13'
      '*.14'
      '*.15'
      '*.16'
      '*.html~'
      '*.url'
      '*.htm'
      '*.html'
      '*.sfv'
      '*.pdf'
      '*.xml'
      '*.exe'
      '*.lsn'
      '*.nzb'
      'Click.rar'
      'What.rar'
      '*sample*'
      '*SAMPLE*'
      '*SaMpLE*'
      '*.nfo'
      '*.jpeg'
      '*.jpg'
      '*.srt'
      '*.idx'
      '*.rar'
      '*sample*'
    )
    # advanced settings
    FIND=$(which find)
    FIND_BASE_CONDITION='-type f'
    FIND_ADD_NAME='-o -name'
    FIND_ACTION='-delete'
    #Folder Setting
    TARGET_FOLDER=$1"$(cat /var/mhs/state/server.hd.path)/downloads/nzb/"
    if [ ! -d "${TARGET_FOLDER}" ]; then echo 'Target directory does not exist - skipping '; fi
    condition="-name '${UNWANTED_FILES[0]}'"
    for ((i = 1; i < ${#UNWANTED_FILES[@]}; i++)); do
      condition="${condition} ${FIND_ADD_NAME} '${UNWANTED_FILES[i]}'"
    done
    command="${FIND} '${TARGET_FOLDER}' -maxdepth 3 ${FIND_BASE_CONDITION} \( ${condition} \) ${FIND_ACTION}"
    echo "Executing ${command}"
    eval "${command}"
    sleep 30
    ##Sync files between parts
    rsync "$(cat /var/mhs/state/server.hd.path)/downloads/" "$(cat /var/mhs/state/server.hd.path)/move/" \
    -aq --remove-source-files --link-dest="$(cat /var/mhs/state/server.hd.path)/downloads/" \
    --exclude-from="/opt/mhs/lib/uploader/excluded/transport.exclude" \
    --exclude-from="/opt/mhs/lib/uploader/excluded/excluded.folder"
    sleep 30
  done
}
# keeps the function in a loop
cheeseballs=0
while [[ "$cheeseballs" == "0" ]]; do startscript; done
