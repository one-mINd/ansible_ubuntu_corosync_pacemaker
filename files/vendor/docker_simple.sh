#!/bin/bash

param=$1

CONTAINER=$OCF_RESKEY_container

meta_data() {
  cat <<END
<?xml version="1.0"?>
<!DOCTYPE resource-agent SYSTEM "ra-api-1.dtd">
<resource-agent name="foobar" version="0.1">
  <version>0.1</version>
  <longdesc lang="en">
My Testing Resource</longdesc>
  <shortdesc lang="en">My Testing Resource</shortdesc>
<parameters>
<parameter name="container" unique="0" required="1">
<longdesc lang="en">
Monitored container
</longdesc>
<shortdesc lang="en">monitoring container</shortdesc>
</parameter>
</parameters>
  <actions>
    <action name="start"        timeout="20" />
    <action name="stop"         timeout="20" />
    <action name="monitor"      timeout="20"
                                interval="10" depth="0" />
    <action name="meta-data"    timeout="5" />
  </actions>
</resource-agent>
END
}

if [ "start" == "$param" ] ; then
  docker start $CONTAINER
  exit 0
elif [ "stop" == "$param" ] ; then
  docker stop $CONTAINER
  exit 0;
elif [ "monitor" == "$param" ] ; then
  container_status=$(docker inspect $CONTAINER --format {{.State.Running}})
  if [[ $container_status == "true" ]]; then
    exit 0
  else
    exit 1
  fi
elif [ "meta-data" == "$param" ] ; then
  meta_data
  exit 0
else
  exit 1;
fi
