#!/bin/bash

service=$1

date_compare() {
  system_date=$(date +%F | tr -d -)
  service_date=$(systemctl show "$service" --property=ActiveEnterTimestamp | awk '{print $2}' | tr -d -)

  if [ "$system_date" -gt "$service_date" ]
    then
      echo 0
    else
      echo 1
  fi
}

time_compare() {
  system_time=$(date +%H%M%S)
  service_time=$(systemctl show "$service" --property=ActiveEnterTimestamp | awk '{print $3}' | tr -d : | sed 's/^0*//')
  diff=$(( ${system_time#0} - ${service_time#0} ))

  if [ $diff -lt 180 ]
    then
      echo 1
    else
      echo 0
  fi
}

if [ "$(date_compare)" == 1 ]
  then
    time_compare
  else
    echo 0
fi
