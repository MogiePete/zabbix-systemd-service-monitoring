#!/bin/bash

service="$1"
now=$(date +%s)

# Don't alert if the server has just been restarted
uptime=$(date +%s -d "$(uptime --since)")
if [[ $(( $now - $uptime)) -lt 180 ]]; then
        echo 0
else
        service_start=$(systemctl show "$service" --property=ActiveEnterTimestamp | awk -F= '{print $2}')
        service_start_as_epoch=$(date -d "$service_start" +%s)

        [[ $(( $now - $service_start_as_epoch )) -lt 180 ]] && echo 1 || echo 0
fi
