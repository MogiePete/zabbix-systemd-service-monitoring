systemd Service Monitoring template for Zabbix
===========================================

Features
--------
* Discovery of systemd Services
  * Provides option of blacklisting or whitelisting services
* Provides alerting when a service stops or restarts

Requirements
------------

OS:

* RHEL/CentOS/Oracle EL
* Ubuntu 16.04/18.04

Zabbix:

* 4.0.x
* 5.0.x

Installation
------------

* Server
  * Import template `Template_App_systemd_Services_v4.xml` file if you have Zabbix 4
  * Import template `Template_App_systemd_Services_v5.xml` file if you have Zabbix 5
  * Link template to host
* Agent
  * Place the following files inside `/etc/zabbix/`:
      * `service_discovery_blacklist` or `service_discovery_whitelist`
  * Place the following file inside `/usr/local/bin/`:
      * `zbx_service_restart_check.sh`
      * `zbx_service_discovery.sh`
  * Set executable permissions on both scripts:
      * `chmod +x /usr/local/bin/zbx*.sh`
  * If running SELinux run restorecon on the two scripts in `/usr/local/bin` e.g.:
      * `restorecon -v /usr/local/bin/zbx*.sh`
  * Copy `userparameter_systemd_services.conf` to `/etc/zabbix/zabbix_agentd.d/userparameter_systemd_services.conf`
  * Restart `zabbix_agent`
* SELinux
  * For system running SELinux you will need to create a custom policy module
  * Please follow the directions above to install the template on the server and copy the files to the agent and then allow the agent to attempt discovery. (This can be sped up by changing the discovery update interval to 5m from 24H)
  * Once this has completed run the following commands to create a custom SELinux Policy Module
      * `grep zabbix_agent_t /var/log/audit/audit.log | grep denied | audit2allow -M zabbix_agent`
      * `semodule -i zabbix_agent.pp`
  * If you add additional services you will need to repeat this process. Sorry

Notes
-----

The filter files can take extended regular expressions, one per line.

If neither `service_discovery_whitelist` nor `service_discovery_blacklist` exist on the system, the default behavior is to monitor all services. In other words it is the equivalent of a blank blacklist and a non-existent whitelist.

If both files exist, both will be used, with the whitelist filter being applied first. Their behavior is explained as follows.

Blacklist Option:

This assumes you have disabled all unnecessary services prior to enabling the template. Any service that is enabled and not running will result in an alert.

If you cannot, use the `service_discovery_blacklist` to add services that you don't want to monitor.

Additionally, this excludes getty and autovt which are not reported by systemctl with the tty and will result in an error.

Whitelist Option:

I have added the whitelist option as a way allow users to select the services they wish to monitor.

To do so modify the `service_discovery_whitelist` which is already populated with sshd|zabbix-agent.

Testing
-------

To test that everything works use `zabbix_agentd -t` to query the statistics:

```bash
# Discover systemd services
zabbix_agentd -t "systemd.service.discovery"
zabbix_agentd -t "systemd.service.status[sshd]"
zabbix_agentd -t "systemd.service.restart[sshd]"
```

License
-------

Copyright (c) 2018-2021 [Mogie Pete](https://github.com/MogiePete) and contributors

This Zabbix template is Free and Open Source software released under the same license of Zabbix, the GNU General Public License.

You can redistribute it and/or modify it under the terms of the GNU GPL as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version. See the file `LICENSE.md` or:

https://www.zabbix.com/license

https://www.fsf.org/licenses/
