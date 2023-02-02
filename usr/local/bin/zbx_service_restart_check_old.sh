#!/bin/bash
#
# Version supporting old systemd versions (before 230)
# For example it supports systemd 219
#

service="$1"
now=$(date +%s)

uptime_value_raw=$(systemctl show -p ActiveEnterTimestamp sysinit.target)

# parse the value that is something like "ActiveEnterTimestamp=SOMETHING"
# https://unix.stackexchange.com/q/728424/85666
uptime_value=$(echo "$uptime_value_raw" | cut -d"=" -f2)

# Don't alert if the server has just been restarted
uptime=$(date +%s -d "$uptime_value")
if [[ $(( now - uptime)) -lt 180 ]]; then
        echo 0
else
        # avoid to use the "--value" since it was introduced only in systemd version 230
        service_start_raw=$(systemctl show -p ActiveEnterTimestamp "$service")

        # parse the value that is something like "ActiveEnterTimestamp=SOMETHING"
        # https://unix.stackexchange.com/q/728424/85666
        service_start=$(echo "$service_start_raw" | cut -d"=" -f2)

        service_start_as_epoch=$(date -d "$service_start" +%s)

        [[ $(( now - service_start_as_epoch )) -lt 180 ]] && echo 1 || echo 0
fi
