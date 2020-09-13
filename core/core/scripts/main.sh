#!/usr/bin/env bash

echo "dummy" > /var/mhs/state/final.choice

#### Note How to Make It Select a Type - echo "removal" > /var/mhs/state/type.choice
program=$(cat /var/mhs/state/type.choice)

menu=$(echo "on")

while [ "$menu" != "break" ]; do
  menu=$(cat /var/mhs/state/final.choice)

  ### Loads Key Variables
  bash /opt/mhs/lib/core/interface/$program/var.sh
  ### Loads Key Execution
  ansible-playbook /opt/mhs/lib/core/core/selection.yml
  ### Executes Actions
  bash /opt/mhs/lib/core/interface/$program/file.sh

  ### Calls Variable Again - Incase of Break
  menu=$(cat /var/mhs/state/final.choice)

  if [ "$menu" == "break" ]; then
    echo ""
    echo "---------------------------------------------------"
    echo "SYSTEM MESSAGE: User Selected to Exit the Interface"
    echo "---------------------------------------------------"
    echo ""
    sleep .5
  fi

done
