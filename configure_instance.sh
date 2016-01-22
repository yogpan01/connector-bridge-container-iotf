#!/bin/bash


setup_mds() 
{
    cd /home/arm
    unzip -q ./mds-server.zip
    /bin/rm -f ./mds-server.zip
    chown -R arm.arm mds *.sh
    chmod -R 700 mds *.sh
}

setup_configurator()
{
   cd /home/arm
   /bin/rm -rf configurator 2>&1 1> /dev/null
   unzip -q ./configurator-1.0.zip
   /bin/rm -f ./configurator-1.0.zip
   chown -R arm.arm configurator
   chmod -R 700 configurator
   cd configurator/conf
   if [ -f deviceserver.properties ]; then
       rm deviceserver.properties 2>&1 1> /dev/null
   fi
   if [ -f gateway.properties ]; then
       rm gateway.properties 2>&1 1> /dev/null
   fi
   ln -s ../../mds/connector-bridge/conf/gateway.properties .
   cd ../..
}

setup_mqtt()
{
    IP_ADDRESS=`ifconfig | perl -nle'/dr:(\S+)/ && print $1' | tail -1`
    mv /home/arm/mds/connector-bridge/conf/gateway.properties .
    sed "s/192.168.1.34/${IP_ADDRESS}/g" < gateway.properties > /home/arm/mds/connector-bridge/conf/gateway.properties
    chmod 666 /home/arm/mds/connector-bridge/conf/gateway.properties
    /bin/rm -f ./gateway.properties
}

setup_ssh()
{
    cd /home/arm
    tar xpf ssh-keys.tar
    /bin/rm -f ssh-keys.tar
    mkdir /var/run/sshd
    chmod 600 .ssh/*
    chmod 700 .ssh
    echo "MaxAuthTries 10" >> /etc/ssh/sshd_config
}

setup_passwords()
{
    echo "root:arm1234" | chpasswd
    echo "arm:arm1234" | chpasswd
}

setup_sudoers() 
{
    usermod -aG sudo arm
    echo "%arm ALL=NOPASSWD: ALL" >> /etc/sudoers
}

setup_jce()
{
    JRE_HOME=/usr/lib/jvm/java-7-oracle/jre
    cd ${JRE_HOME}/lib/security
    unzip /home/arm/jce7.zip
    mkdir ./backup
    cp *.jar ./backup
    cp UnlimitedJCEPolicy/*.jar . 
    /bin/rm -f /home/arm/jce7.zip
}

setup_java() {
    update-alternatives --set java /usr/lib/jvm/java-7-oracle/jre/bin/java
    # update-alternatives --set java /usr/lib/jvm/java-8-oracle/jre/bin/java
}

cleanup()
{
   /bin/rm -f /home/arm/configure_instance.sh 2>&1 1>/dev/null
}

main() 
{
    setup_mds
    setup_configurator
    setup_ssh
    # setup_mqtt
    setup_passwords
    setup_sudoers
    # setup_jce
    setup_java
    cleanup
}

main $*
