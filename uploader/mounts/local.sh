#!/usr/bin/env bash

sleep 2

hdpath="$(cat /var/mhs/state/server.hd.path)"
mergerfs -o sync_read,auto_cache,dropcacheonclose=true,use_ino,allow_other,func.getattr=newest,category.create=ff,minfreespace=0,fsname=pgunion \
$hdpath/move=RO:$hdpath/downloads=RW:{{multihds}} /mnt/unionfs
