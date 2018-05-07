#!/bin/bash

# source runtime config variables
. /home/ubuntu/build/files/runtime_config_vars.prop

# copy war file
cp ${SHOME}/files/click.feedback.processor.war ${AHOME}
chown -R ${RunAs}:${RunAs} ${AHOME}


mkdir ${RHOME}/logs
chown -R ${RunAS}:${RunAS} ${RHOME}/logs

service tomcat8 restart
sleep 30


ls -l ${AHOME}/clicks-feedback-processor
if [ $? -ne 0 ] ; 
then 
echo "clicks.feedback.processor.war did not expand" >> /tmp/${APP_NAME}-config.err
exit 1
fi

if [ -f /tmp/${APP_NAME}-config.err ] ; then
  echo "config script failed" >> /tmp/${APP_NAME}-config.err
  exit 80
else
  touch /tmp/${APP_NAME}-config.done
  exit 0
fi