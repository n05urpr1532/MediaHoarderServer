#!/usr/bin/env bash

# To Get List for Rebuilding or TLD
docker ps --format '{{.Names}}' > /tmp/backup.list
sed -i -e "/traefik/d" /tmp/backup.list
sed -i -e "/watchtower/d" /tmp/backup.list
sed -i -e "/wp-*/d" /tmp/backup.list
sed -i -e "/x2go*/d" /tmp/backup.list
sed -i -e "/mhs/d" /tmp/backup.list
sed -i -e "/cloudplow/d" /tmp/backup.list
sed -i -e "/oauth/d" /tmp/backup.list
sed -i -e "/pgui/d" /tmp/backup.list

rm -rf /tmp/backup.build 1> /dev/null 2>&1
#### Commenting Out To Let User See
while read p; do
  echo -n "$p" >> /tmp/backup.build
  echo -n " " >> /tmp/backup.build
done < /tmp/backup.list
running=$(cat /tmp/backup.list)

# If Blank, Exit
if [ "$running" == "" ]; then
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️ WARNING! - No Apps are Running! Exiting!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  sleep 2
  exit
fi

# Menu Interface
tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Traefik - Provider Interface
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
NOTE: App Must Be Actively Running!

EOF
echo PROGRAMS:
echo $running
tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Z] Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

# Standby
read -p 'Type an Application Name | Press [ENTER] | [Z] Exit: ' typed < /dev/tty

if [[ "$typed" == "exit" || "$typed" == "Exit" || "$typed" == "EXIT" || "$typed" == "z" || "$typed" == "Z" ]]; then exit; fi

tcheck=$(echo $running | grep "\<$typed\>")
if [ "$tcheck" == "" ]; then
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️ WARNING! - Type an Application Name! Case Senstive! Restarting!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  sleep 3
  bash /opt/mhs/lib/traefik/tld.sh
  exit
fi

if [ "$typed" == "" ]; then
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️ WARNING! - The TLD Application Name Cannot Be Blank!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  sleep 3
  bash /opt/mhs/lib/traefik/tld.sh
  exit
else
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅️  PASS: TLD Application Set
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  # Prevents From Repeating
  cat /var/mhs/state/tld.program > /var/mhs/state/old.program
  echo "$typed" > /var/mhs/state/tld.program

  sleep 3
fi

tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🍖  NOM NOM - Rebuilding Your Old App & New App Containers!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

sleep 4
old=$(cat /var/mhs/state/old.program)
new=$(cat /var/mhs/state/tld.program)

touch /var/mhs/state/tld.type
tldtype=$(cat /var/mhs/state/tld.type)

if [[ "$old" != "$new" && "$old" != "NOT-SET" ]]; then

  if [[ "$tldtype" == "standard" ]]; then
    if [ -e "/opt/mhs/lib/apps-core/$old.yml" ]; then ansible-playbook /opt/mhs/lib/apps-core/$old.yml; fi
    if [ -e "/opt/mhs/lib/apps-community/$old.yml" ]; then ansible-playbook /opt/mhs/lib/apps-community/apps/$old.yml; fi
  fi

fi

if [ -e "/opt/mhs/lib/apps-core/$new.yml" ]; then ansible-playbook /opt/mhs/lib/apps-core/$new.yml; fi
if [ -e "/opt/mhs/lib/apps-community/$new.yml" ]; then ansible-playbook /opt/mhs/lib/apps-community/apps/$new.yml; fi
echo "standard" > /var/mhs/state/tld.type
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
read -p '✅️ Process Complete! Acknowledge Info | Press [ENTER] ' name < /dev/tty
