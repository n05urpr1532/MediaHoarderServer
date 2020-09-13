#!/usr/bin/env bash

docker ps -a --format "{{.Names}}" > /var/mhs/state/container.running

sed -i -e "/traefik/d" /var/mhs/state/container.running
sed -i -e "/watchtower/d" /var/mhs/state/container.running
sed -i -e "/wp-*/d" /var/mhs/state/container.running
sed -i -e "/x2go*/d" /var/mhs/state/container.running
sed -i -e "/authclient/d" /var/mhs/state/container.running
sed -i -e "/dockergc/d" /var/mhs/state/container.running
sed -i -e "/oauth/d" /var/mhs/state/container.running

count=$(wc -l < /var/mhs/state/container.running)
((count++))
((count--))

tee <<- EOF

	━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
	⚠️  PortGuard - Rebuilding Containers!
	━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
sleep 2
for ((i = 1; i < $count + 1; i++)); do
  app=$(sed "${i}q;d" /var/mhs/state/container.running)

  tee <<- EOF

		━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
		↘️  PortGuard - Rebuilding [$app]
		━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

	EOF
  echo "$app" > /tmp/program_var
  sleep 1

  if [ -e "/opt/mhs/lib/apps-core/$app.yml" ]; then ansible-playbook /opt/mhs/lib/apps-core/$app.yml; fi
  if [ -e "/opt/mhs/lib/apps-community/$app.yml" ]; then ansible-playbook /opt/mhs/lib/apps-community/apps/$app.yml; fi
  if [ -e "/opt/mhs/apps-local/$app.yml" ]; then ansible-playbook /opt/mhs/apps-local/apps/$app.yml; fi
done

echo ""
tee <<- EOF
	━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
	✅️  PortGuard - All Containers Rebuilt!
	━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
read -r -p 'Continue? | Press [ENTER] ' name < /dev/tty
