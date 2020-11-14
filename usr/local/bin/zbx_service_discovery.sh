#!/bin/bash

service_list=$(systemctl list-unit-files | grep -E '\.service\s+(generated|enabled)' | awk -F'\\.service ' '{print $1}')

[[ -r /etc/zabbix/service_discovery_whitelist ]] && {
    service_list=$(echo "$service_list" | grep -E -f /etc/zabbix/service_discovery_whitelist)
}

[[ -r /etc/zabbix/service_discovery_blacklist ]] && {
    service_list=$(echo "$service_list" | grep -Ev -f /etc/zabbix/service_discovery_blacklist)
}

service_list_convert="${service_list//\@/_AT_}"

echo -n '{"data":[';for s in ${service_list_convert}; do echo -n "{\"{#SERVICE}\": \"$s\"},";done | sed -e 's:\},$:\}:';echo -n ']}'
