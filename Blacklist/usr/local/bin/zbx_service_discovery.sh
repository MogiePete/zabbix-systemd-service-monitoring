#!/bin/bash

service_list=$(for i in $(cat /etc/zabbix/service_discovery_blacklist); do systemctl list-unit-files | grep -E 'generated|enabled' | grep -Ev "$i" | grep ".service" | awk '{print $1}' | sed -e 's/\.service//'; done);

echo -n '{"data":[';for s in ${service_list}; do echo -n "{\"{#SERVICE}\": \"$s\"},";done | sed -e 's:\},$:\}:';echo -n ']}'
