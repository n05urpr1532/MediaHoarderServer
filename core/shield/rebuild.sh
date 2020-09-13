#!/usr/bin/env bash
#
# [Rebuilding Containers]
#
# GitHub:   https://github.com/PGBlitz/PGBlitz.com
# Author:   Admin9705 - Deiteq
# URL:      https://pgblitz.com
#
# PGBlitz Copyright (C) 2018 PGBlitz.com
# Licensed under GNU General Public License v3.0 GPL-3 (in short)
#
#   You may copy, distribute and modify the software as long as you track
#   changes/dates in source files. Any modifications to our software
#   including (via compiler) GPL-licensed code must also be made available
#   under the GPL along with build & install instructions.
#
#################################################################################
docker ps -a --format "{{.Names}}" > /var/mhs/state/container.running

sed -i -e "/traefik/d" /var/mhs/state/container.running
sed -i -e "/oauth/d" /var/mhs/state/container.running
sed -i -e "/watchtower/d" /var/mhs/state/container.running
sed -i -e "/wp-*/d" /var/mhs/state/container.running
sed -i -e "/plex/d" /var/mhs/state/container.running
sed -i -e "/jellyfin/d" /var/mhs/state/container.running
sed -i -e "/emby/d" /var/mhs/state/container.running
sed -i -e "/x2go*/d" /var/mhs/state/container.running
sed -i -e "/authclient/d" /var/mhs/state/container.running
sed -i -e "/dockergc/d" /var/mhs/state/container.running

count=$(wc -l < /var/mhs/state/container.running)
((count++))
((count--))

tee <<- EOF

	━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
	⚠️  MHS-Shield - Rebuilding Containers!
	━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
sleep 1.5
for ((i = 1; i < $count + 1; i++)); do
  app=$(sed "${i}q;d" /var/mhs/state/container.running)

  tee <<- EOF

		━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
		↘️  MHS-Shield - Rebuilding [$app]
		━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

	EOF
  echo "$app" > /tmp/program_var
  sleep 1.5

  if [ -e "/opt/mhs/lib/apps-core/$app.yml" ]; then ansible-playbook /opt/mhs/lib/apps-core/$app.yml; fi
  if [ -e "/opt/mhs/lib/apps-community/apps/$app.yml" ]; then ansible-playbook /opt/mhs/lib/apps-community/apps/$app.yml; fi
done

echo ""
tee <<- EOF
	━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
	✅️  MHS-Shield - All Containers Rebuilt!
	━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
read -p 'Continue? | Press [ENTER] ' name < /dev/tty
