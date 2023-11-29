#!/bin/bash

service_list=$(systemctl list-units -t service --no-pager --no-legend | awk '{print $1}')

filtered_service_list=()

for service in ${service_list}; do
    if ! systemctl show -p Type --value "$service" | grep -q "oneshot"; then
        filtered_service_list+=("$service")
    fi
done


echo -n '{"data":[';for s in ${filtered_service_list[@]}; do echo -n "{\"{#SERVICE}\": \"$s\"},";done | sed -e 's:\},$:\}:';echo -n ']}'