#!/usr/bin/env bash

message=$(cat /var/mhs/state/message.phase)

echo ""
echo "----------------------------------------------------"
echo "PLEASE STANDBY"
echo "System Message: $message"
echo "----------------------------------------------------"
sleep 2
