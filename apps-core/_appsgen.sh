#!/usr/bin/env bash

# Generates App List
ls -la /opt/mhs/lib/apps-core/ | sed -e 's/.yml//g' \
  | awk '{print $9}' | tail -n +4 > /var/mhs/state/app.list

ls -la /opt/mhs/apps-local/ | sed -e 's/.yml//g' \
  | awk '{print $9}' | tail -n +4 >> /var/mhs/state/app.list
# Enter Items Here to Prevent them From Showing Up on AppList
sed -i -e "/traefik/d" /var/mhs/state/app.list
sed -i -e "/image*/d" /var/mhs/state/app.list
sed -i -e "/_appsgen.sh/d" /var/mhs/state/app.list
sed -i -e "/_c*/d" /var/mhs/state/app.list
sed -i -e "/_a*/d" /var/mhs/state/app.list
sed -i -e "/_t*/d" /var/mhs/state/app.list
sed -i -e "/templates/d" /var/mhs/state/app.list
sed -i -e "/retry/d" /var/mhs/state/app.list
sed -i "/^test\b/Id" /var/mhs/state/app.list
sed -i -e "/nzbthrottle/d" /var/mhs/state/app.list
sed -i -e "/watchtower/d" /var/mhs/state/app.list
sed -i "/^_templates.yml\b/Id" /var/mhs/state/app.list
sed -i -e "/oauth/d" /var/mhs/state/app.list
sed -i -e "/dockergc/d" /var/mhs/state/app.list
sed -i -e "/crontabs/d" /var/mhs/state/app.list
sed -i -e "/archive/d" /var/mhs/state/app.list
