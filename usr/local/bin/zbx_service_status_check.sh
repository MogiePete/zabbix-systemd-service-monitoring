#!/bin/bash

service=$1

service_real="${service/_AT_/@}"

systemctl status $service_real 2>/dev/null | grep -Ei 'running|active \(exited\)|active \(running\)' > /dev/null && echo 0 || echo 1
