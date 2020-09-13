#!/usr/bin/env bash

#####FUNCTION

app=$(cat /tmp/program_var)
##### CHECK START #####

if [ "$app" == "plex" ]; then
  bash /opt/mhs/lib/core/plex/plex.sh
fi

if [ "$app" == "plaxt" ]; then
  bash /opt/mhs/lib/core/pgbox/customparts/plaxt.sh
fi

if [ "$app" == "channelsdvr" ]; then
  bash /opt/mhs/lib/core/pgbox/customparts/channelsdvr.sh
fi

if [ "$app" == "rclonegui" ]; then
  bash /opt/mhs/lib/core/pgbox/customparts/rclonegui.sh
fi

if [ "$app" == "varken" ]; then
  bash /opt/mhs/lib/core/pgbox/customparts/geolite.sh
fi

##### CHECK EXIT #####
