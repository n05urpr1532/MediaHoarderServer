#!/usr/bin/env bash

# Regular color(s)
NORMAL="\033[0;39m"
GREEN="\033[32m"

echo -e "
$GREEN
 ┌───────────────────────────────────────────────────────────────────────────────────┐
 │ Title:             Restart Running Containers Script                              │
 │ Author(s):         desimaniac                                                     │
 │ Description:       Stop running containers and start them back up.                │
 ├───────────────────────────────────────────────────────────────────────────────────┤
 │                        GNU General Public License v3.0                            │
 └───────────────────────────────────────────────────────────────────────────────────┘
$NORMAL
"

containers=$(comm -12 <(docker ps -a -q | sort) <(docker ps -q | sort))
for container in $containers;
do
    echo Stopping "$container"
    docker stop "$container"
done

sleep 10

for container in $containers;
do
    echo Starting "$container"
    docker start "$container"
done
