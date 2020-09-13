#!/usr/bin/env bash

######################################################## Declare Variables
sname="PG Installer: Set PG Edition"
pg_edition=$(cat /var/mhs/state/pg.edition)
pg_edition_stored=$(cat /var/mhs/state/pg.edition.stored)
######################################################## START: PG Log
sudo echo "INFO - Start of Script: $sname" > /var/mhs/log/pg.log
sudo bash /opt/mhs/lib/core/log/log.sh
######################################################## START: Main Script
if [ "$pg_edition" == "$pg_edition_stored" ]; then
  echo "" 1> /dev/null 2>&1
else
  bash /opt/mhs/lib/core/editions/editions.sh
fi
######################################################## END: Main Script
#
#
######################################################## END: PG Log
sudo echo "INFO - END of Script: $sname" > /var/mhs/log/pg.log
sudo bash /opt/mhs/lib/core/log/log.sh
