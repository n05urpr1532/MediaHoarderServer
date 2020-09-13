#!/usr/bin/env bash

dt=$(date '+%d/%m/%Y %H:%M:%S')
log=$(cat /var/mhs/log/pg.log)
echo "$dt $log" >> "/var/mhs/log/pg.log"
