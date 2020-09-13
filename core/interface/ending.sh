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
┌─────────────────────────────────────┐
│         -==   Team MHS  ==-         │
│ ————————————————————————————————————│
│ Restart MHS:              mhs       │
│ Update  MHS:              ptsupdate │
│ View the MHS Logs:        blitz     │
│ Download Your MHS Fork:   pgfork    │
│                                     │
│ ————————————————————————————————————│
│ Thanks For Being Part of the Team   │
│                                     │
│ Thanks to:                          │
│                                     │
│ Davaz, Deiteq, FlickerRate,         │
│ ClownFused, MrDoob, Sub7Seven,      │
│ TimeKills, The_Creator, Desimaniac, │
│ l3uddz, RXWatcher, Calmcacil,       │
│ ΔLPHΔ , Maikash , Porkie            │
│ CDN_RAGE , hawkinzzz , The_DeadPool │
│ BugHunter : Krallenkiller           │
│                                     │
└─────────────────────────────────────┘
'
