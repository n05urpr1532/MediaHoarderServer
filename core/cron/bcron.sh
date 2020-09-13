#!/usr/bin/env bash

pgrole=$(cat /tmp/program_var)
path=$(cat /var/mhs/state/server.hd.path)
tarlocation=$(cat /var/mhs/state/data.location)
serverid=$(cat /var/mhs/state/pg.serverid)

doc=no
rolecheck=$(docker ps | grep -c "\<$pgrole\>")
if [ $rolecheck != 0 ]; then docker stop $pgrole && doc=yes; fi

tar \
--ignore-failed-read \
--warning=no-file-changed \
--warning=no-file-removed \
-cvzf $tarlocation/$pgrole.tar /opt/mhs/apps-data/$pgrole/

if [ $doc == yes ]; then docker restart $pgrole; fi

chown -R 1000:1000 $tarlocation
rclone --config /opt/mhs/etc/rclone/rclone.conf copy $tarlocation/$pgrole.tar gdrive:/mhs/backup/$serverid -v --checksum --drive-chunk-size=64M

du -sh --apparent-size /opt/mhs/apps-data/$pgrole | awk '{print $1}'
rm -rf '$tarlocation/$pgrole.tar'
