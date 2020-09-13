# #!/usr/bin/env bash
#
# uagent="$(cat /var/mhs/state/uagent)"
# tee <<-EOF

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 🚀 User Agent for RClone
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# NOTE: Don't use Google Chrome user agent strings, your mounts may go down.

# Current User Agent: ${uagent}

# Changing the useragent is useful when experience 429 problems from Google

# Do not wrap the string in double quotes!

# for Random useragent typ >> random or RANDOM

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# [Z] Exit
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# EOF

# read -p '↘️  Type User Agent | PRESS [ENTER]: ' varinput </dev/tty
# if [[ "$varinput" == "exit" || "$varinput" == "Exit" || "$varinput" == "EXIT" || "$varinput" == "z" || "$varinput" == "Z" ]]; then rcloneSettings; fi
# #######userinput##
# echo "$varinput" >/var/mhs/state/uagent
# echo $(sed -e 's/^"//' -e 's/"$//' <<<$(cat /var/mhs/state/uagent)) >/var/mhs/state/uagent
# settingUpdatedNotice;
# rcloneSettings
# #######random part###
# uagentrandom="$(cat /var/mhs/state/uagent)"
# if [[ "$uagentrandom" == "random" || "$uagentrandom" == "RANDOM"  ]]; then
# randomagent=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
# uagent=$(cat /var/mhs/state/uagent)
# echo "$randomagent" >/var/mhs/state/uagent
# echo $(sed -e 's/^"//' -e 's/"$//' <<<$(cat /var/mhs/state/uagent)) >/var/mhs/state/uagent
# fi
# sleep 5
# tee <<-EOF
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 🚀 Updated User Agent for RClone now $(cat /var/mhs/state/uagent)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# EOF
# settingUpdatedNotice ;
# rcloneSettings
