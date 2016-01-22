#!/bin/sh

report_ip_address()
{
   IP_ADDRESS=`ifconfig | perl -nle'/dr:(\S+)/ && print $1' | tail -1`
   HOSTNAME=`hostname`
   echo "Container Hostname: " ${HOSTNAME} " IP: " ${IP_ADDRESS}
}

update_hosts()
{
    sudo /home/arm/update_hosts.sh
}

run_supervisord()
{
   #tail -f /home/arm/mds/mds-mqtt-gateway/logs/*.log
   /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf 2>&1 1>/tmp/supervisord.log
}

run_mqtt()
{
   cd /home/arm
   su -l arm -s /bin/bash -c "sudo /usr/sbin/mosquitto 2>&1 1>/home/arm/mosquitto.out &"
}

run_mds()
{
   cd /home/arm
   su -l arm -s /bin/bash -c "touch /home/arm/nsp.log 2>&1 1> /dev/null"
   su -l arm -s /bin/bash -c "/home/arm/restart.sh"
}

run_configurator()
{
  cd /home/arm/configurator
  su -l arm -s /bin/bash -c "/home/arm/configurator/runConfigurator.sh 2>&1 1> /tmp/configurator.log &"
}

main() 
{
   report_ip_address
   update_hosts
   # run_mqtt
   run_mds
   run_configurator
   run_supervisord
}

main $*
