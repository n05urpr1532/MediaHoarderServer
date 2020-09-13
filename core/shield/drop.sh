#!/usr/bin/env bash

touch /var/mhs/state
if [[ $(docker ps | grep oauth) == "" ]]; then
  echo null > /var/mhs/state/auth.var
else
  echo good > /var/mhs/state/auth.var
fi
