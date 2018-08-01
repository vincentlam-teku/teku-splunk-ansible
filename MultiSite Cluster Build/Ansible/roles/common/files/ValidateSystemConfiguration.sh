#!/bin/bash

echo "Check OS version"
if [ "$(uname -r | awk -F "." '{print $NF}')" = "x86_64" ]
then
 echo "Passed"
else
 echo "Failed"
fi

echo "Check SELinux status"
if [ "$(/usr/sbin/getenforce)" = "Disabled" ]
then
 echo "Passed"
else
 echo "Failed"
fi

echo "Check execution permission in /tmp"
if [ -z "$(mount | grep '/tmp.*noexec')" ]
then
 echo "Passed"
else
 echo "Failed"
fi

echo "Check local firewall status"
if [ "$(uname -r | awk -F "." '{print $(NF-1)}')" = "el6" ]
then
  if [ -n "$(sudo service iptables status | grep "not running")" ]
  then
   echo "Passed"
  else
   echo "Failed"
  fi
else
  if [ -n "$(sudo systemctl status firewalld | grep "inactive")" ]
  then
   echo "Passed"
  else
   echo "Failed"
  fi
fi

echo "Check passwordless sudo"
if [ "$(sudo touch /root/test)" ] && [ "$(sudo rm -f /root/test)" ]
then
 echo "Passed"
else
 echo "Failed"
fi

echo "Check system limits for file handles and concurrent processes"
if [ "$(ulimit -n)" -gt "262144" ] && [ "$(ulimit -u)" -gt "65535" ]
then
 echo "Passed"
else
 echo "Failed"
fi

echo "Check THP status"
if [ "$(grep "\[never\]" /sys/kernel/mm/transparent_hugepage/enabled)" ]
then
 echo "Passed"
else
 echo "Failed"
fi

echo "Check THP defrag status"
if [ "$(grep "\[never\]" /sys/kernel/mm/transparent_hugepage/defrag)" ]
then
 echo "Passed"
else
 echo "Failed"
fi
