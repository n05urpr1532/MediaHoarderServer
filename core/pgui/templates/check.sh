#!/usr/bin/env bash

mkdir -p /var/mhs/state/checkers
truncate -s 0 /var/mhs/state/checkers/*.log
###mergerfs part
touch /var/mhs/state/checkers/mgfs.log
touch /var/mhs/state/checkers/mergerfs.log
mgversion="$(curl -s https://api.github.com/repos/trapexit/mergerfs/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')"
mergfs="$(mergerfs -v | grep 'mergerfs version:' | awk '{print $3}')"
echo "$mergfs" >> /var/mhs/state/checkers/mgfs.log
mgstored="$(tail -n 1 /var/mhs/state/checkers/mgfs.log)"
if [[ "$mgversion" == "$mgstored" ]]; then
  echo " ✅ !" > /var/mhs/state/checkers/mergerfs.log
else
  echo " ⛔ Update possible !" > /var/mhs/state/checkers/mergerfs.log
fi
####rclone part
touch /var/mhs/state/checkers/rclonestored.log
touch /var/mhs/state/checkers/rclone.log
rcversion="$(curl -s https://api.github.com/repos/rclone/rclone/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')"
rcstored="$(rclone --version | awk '{print $2}' | tail -n 3 | head -n 1)"
echo "$rcstored" > /var/mhs/state/checkers/rclonestored.log
rcstored="$(tail -n 1 /var/mhs/state/checkers/rclonestored.log)"
if [[ "$rcversion" == "$rcstored" ]]; then
  echo " ✅ !" > /var/mhs/state/checkers/rclone.log
else
  echo " ⛔  Update possible !" > /var/mhs/state/checkers/rclone.log
fi
