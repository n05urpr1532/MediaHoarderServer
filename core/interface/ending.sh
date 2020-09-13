#!/usr/bin/env bash

source /opt/mhs/lib/core/functions/install.sh
emergency
file="/bin/mhs"
if [[ ! -f "/bin/mhs" ]]; then
  cp /opt/mhs/lib/core/alias/templates/mhs /bin && chown 1000:1000 /bin/mhs && chmod 0755 /bin/mhs
fi
#
clear
printf '
┌──────────────────────────────────────┐
│     -== Media Hoarder Server ==-     │
│ ———————————————————————————————————— │
│                                      │
│   Restart MHS command:      mhs      │
│                                      │
│ ———————————————————————————————————— │
│                                      │
│             See you soon !           │
│                                      │
└──────────────────────────────────────┘

'
