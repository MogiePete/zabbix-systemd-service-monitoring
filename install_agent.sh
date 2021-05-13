#!/bin/bash

set -ex

sudo cp $(realpath ./service_discovery_blacklist) /etc/zabbix/service_discovery_blacklist.example
sudo cp $(realpath ./service_discovery_whitelist) /etc/zabbix/service_discovery_whitelist.example

sudo ln -s $(realpath ./zbx_service_restart_check.sh) /usr/local/bin/
sudo ln -s $(realpath ./zbx_service_discovery.sh) /usr/local/bin/
sudo chmod +x \
	/usr/local/bin/zbx_service_restart_check.sh \
	/usr/local/bin/zbx_service_discovery.sh

sudo ln -s $(realpath ./userparameter_systemd_services.conf) /etc/zabbix/zabbix_agentd.d/

sudo systemctl restart zabbix_agent

