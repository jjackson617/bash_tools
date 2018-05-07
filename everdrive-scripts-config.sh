#!/bin/bash

# source runtime config variables
. /home/ubuntu/build/files/runtime_config_vars.prop

# ensure apprunner homedir is 
chown -R apprunner:apprunner /evq

# pull the git code 
sudo -u apprunner git clone git@github.com:adharmonics/everdrive-analytics.git /evq/apprunner/${APP_NAME}
if [ ! -d ${AHOME} ] ; then
  echo "the ${APP_NAME} repo did not pull from git correctly" >> /tmp/${APP_NAME}-config.err
  exit 10
fi

# install required packages 
sudo pip3 install -r /evq/apprunner/${APP_NAME}/requirements.txt -i https://cheeseshop.adh8.com/eq/base 
if [ $? -ne 0 ] ; then
   echo "${DATE} - new pip requirements not installed" >> /tmp/${APP_NAME}-config.err
   exit 10
fi

# copy everdrive-scripts-ps.txt

sudo cp ${SHOME}/files/everdrive-scripts-ps.txt ${AHOME}/config.py

# create crontab entries
#crontab -u apprunner ${AHOME}/crontab.txt
#if [ $? -ne 0 ] ; then
#    echo "failed to install crontab" >> /tmp/${APP_NAME}-config.err
#    exit 40
#fi

# chown the dir tree to apprunner
sudo chown -R apprunner:apprunner /evq
if [ $? -ne 0 ] ; then
   echo "${DATE} - evq apprunner chown command failed" >> /tmp/${APP_NAME}-config.err
   exit 70
fi

if [ -f /tmp/${APP_NAME}-config.err ] ; then
  echo "config script failed" >> /tmp/${APP_NAME}-config.err
  exit 80
else
  touch /tmp/${APP_NAME}-config.done
  exit 0
fi