#!/bin/bash
################################# secure-leads-config.sh #############################

#!/bin/bash -x
# source commonly used variables
. /home/ubuntu/build/files/runtime_config_vars.prop

# generate random password to be used for the jmx monitorRole user
JMX_PASSWORD=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;)
if [ $? -ne 0 ] ; then
    echo "${DATE} - failed to generate random password for JMX." >> ${APP_ERROR_LOG}
    exit 1

fi

### setup datadog config:
sed -i -e "s/ThisPasswordChangesInTheBuildScript/${JMX_PASSWORD}/g" /home/ubuntu/build/files/tomcat.yaml
if [ $? -ne 0 ] ; then
    echo "${DATE} - failed set password to tomcat plugin for datadog." >> ${APP_ERROR_LOG}
    exit 1
fi

# copy the datadog config
cp /home/ubuntu/build/files/tomcat.yaml /etc/dd-agent/conf.d/tomcat.yaml
if [ $? -ne 0 ] ; then
    echo "${DATE} - failed to generate random password for JMX." >> ${APP_ERROR_LOG}
    exit 1

fi

# dd-agent should own the yaml file
chown dd-agent. /etc/dd-agent/conf.d/tomcat.yaml

# validate tomcat config works with this command manually: sudo /etc/init.d/datadog-agent info
# restart datadog agent
service datadog-agent restart
if [ $? -ne 0 ] ; then
    echo "${DATE} - failed to restart datadog." >> ${APP_ERROR_LOG}
    exit 1

fi

### setup JMX config

# setup jmxremote.password
echo "monitorRole ${JMX_PASSWORD}" > /opt/tomcat/conf/jmxremote.password

# and jmxremote.access
echo "monitorRole readonly" > /opt/tomcat/conf/jmxremote.access

# own jmxremote.* as tomcat & set to readonly
chown tomcat. /opt/tomcat/conf/jmxremote.*
chmod 400 /opt/tomcat/conf/jmxremote.*

# fail if jmxremote files don't exist
if [[ ! -e /opt/tomcat/conf/jmxremote.password ]]; then
    echo "${DATE} - failed to configure jmxremote.password file" >> ${APP_ERROR_LOG}
    exit 1
fi

# fail if it doesn't exist
if [[ ! -e /opt/tomcat/conf/jmxremote.access ]]; then
    echo "${DATE} - failed to configure jmxremote.access file" >> /tmp/${APP_NAME}-config.err
    exit 1
fi

# Download the war file from s3. NOTE, WAR_FILE_S3_PATH is pulled from `s3cmd ls`.
s3cmd sync ${WAR_FILE_S3_PATH} /home/ubuntu/build/files/${WAR}.war
if [ ! -e /home/ubuntu/build/files/${WAR}.war ]; then
    echo "${DATE} - War file does not download properly from ${WAR_FILE_S3_PATH}" >> ${APP_ERROR_LOG}
    exit 1
fi


# copy files to destinations
cp ${SHOME}/files/${WAR}.war /opt/tomcat/webapps
cp ${SHOME}/files/setenv.sh /opt/tomcat/bin
cp ${SHOME}/files/tomcat-users.xml /opt/tomcat/conf/tomcat-users.xml
cp ${SHOME}/files/server.xml /opt/tomcat/conf/server.xml
chown -R tomcat:tomcat /opt/tomcat/

# TODO: determine if this is necessary
#set env
#./opt/tomcat/bin/setenv.sh


# restart Tomcat to expand war file
service tomcat restart
sleep 30

ls -l /opt/tomcat/webapps/${WAR}
#TODO: figure out better logic for this
if [ $? -ne 0 ] ; then
    echo "${DATE} - ${WAR}.war did not expand" >> ${APP_ERROR_LOG}
    #exit 1
fi

# touch done file for master script
touch /tmp/${APP_NAME}-config.done
