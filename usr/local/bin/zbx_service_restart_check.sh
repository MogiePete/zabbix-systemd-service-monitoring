#!/bin/bash

service="$1"
now=$(date +%s)

# Don't alert if the server has just been restarted
uptime=$(date +%s -d "$(systemctl show --value -p ActiveEnterTimestamp sysinit.target)")
if [[ $(( now - uptime)) -lt 180 ]]; then
        echo 0
else
        # note that the next line requires systemd version 230 because of "--value"
        service_start=$(systemctl show --value -p ActiveEnterTimestamp "$service")
        service_start_as_epoch=$(date -d "$service_start" +%s)

        [[ $(( now - service_start_as_epoch )) -lt 180 ]] && echo 1 || echo 0
fi
