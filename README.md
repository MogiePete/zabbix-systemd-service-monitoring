systemd Service Monitoring template for Zabbix
===========================================


FEATURES
--------
* Discovery of systemd Services
* Provides alerting when a service stops or restarts

REQUIREMENTS
------------
* RHEL/CentOS/Oracle EL
* Ubuntu 16.04/18.04
* Zabbix 4.0

INSTALLATION
------------
* Server
  * Import template __Template\_App\_systemd\_Services.xml__ file
  * Link template to host
* Agent
  * Place the following files inside /etc/zabbix/:
  * service\_discovery\_blacklist
  * Place the following file inside /usr/local/bin/:
  * zbx\_service\_restart\_check.sh
  * zbx\_service\_discovery.sh
  * If running SELinux run restorecon on the two scripts in /usr/local/bin e.g. __restorecon -v /usr/local/bin/zbx*.sh__
  * Copy __userparameter\_systemd\_services.conf__ to __/etc/zabbix/zabbix\_agentd.d/userparameter\_systemd\_services.conf__
  * Restart zabbix_agent
* SELinux
  * For system running SELinux you will need to create a custom policy module
  * Please follow the directions above to install the template on the server and copy the files to the agent and then allow the agent to attempt discovery. (This can be sped up by changing the discovery update interval to 5m from 24H)
  * Once this has completed run the following commands to create a custom SELinux Policy Module
  * __grep zabbix\_agent\_t /var/log/audit/audit.log | grep denied | audit2allow -M zabbix_agent__
  * __semodule -i zabbix_agent.pp__
  * If you add additional services you will need to repeat this process. Sorry

NOTES
------------

This assumes you have disabled all unnecessary services prior to enabling the template. Any service that is enabled and not running will result in an alert.

If you cannot, use the service_discovery_blacklist to add services that you don’t want to monitor.

Additionally this excludes getty and autovt which are not reported by systemctl with the tty and will result in an error.

Testing
-------
To test that everything works use `zabbix_agentd -t` to query the statistics :

```bash
# Discover systemd services
zabbix_agentd -t "systemd.service.discovery"
zabbix_agentd -t "systemd.service.status[sshd]"
zabbix_agentd -t "systemd.service.restart[sshd]"
```
