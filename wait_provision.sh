#!/bin/bash

check_puppet_apply() {
  ps -aux | grep  "puppet apply"  | grep -v grep > /dev/null
  result=$?
  if [ ${result} -eq 0 ]; then
    return 1
  else
    return 0
  fi
}

# is cloud-init available?
if [ -d "/var/lib/cloud/instance/" ]; then
  echo "Cloud-init is found"
  # wait until finished for max 30 minutes
  wait_seconds="${1:-1800}"
  until test $((wait_seconds--)) -eq 0 -o -f "/var/lib/cloud/instance/boot-finished" ; do sleep 1; done
  ((++wait_seconds))
  echo "Cloud-init is finished"
else
  echo "Cloud init is not found, checking if puppet apply is running"
  wait_seconds="${1:-1800}"
  until check_puppet_apply $((wait_seconds--)) ; do sleep 1; done
  ((++wait_seconds))
  echo "Puppet is finished"
fi
