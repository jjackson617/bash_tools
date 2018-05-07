#!/bin/bash

# Global Variables


# source the vars
. /home/ubuntu/build/files/runtime_config_vars.prop


#pull from git

sudo -u apprunner git clone git@github.com:adharmonics/everdrive-reporting.git /evq/apprunner/${APP_NAME}
if [ ! -d /evq/apprunner/${APP_NAME}]; then
    echo "everdrive-reporting code did not pull from git correctly" >> /tmp/${APP_NAME}-config.err
    exit 10
fi

# Get unit file and move to systemd dir
sudo cp ${SHOME}/files/everdrive-reporting.service /etc/systemd/system/everdrive-reporting.service
chmod 664 /etc/systemd/system/everdrive-reporting.service
sudo systemctl enable everdrive-reporting.service
sudo systemctl daemon-reload


#Completion check 

if [ -f /tmp/${APP_NAME}-config.err ] ; then
  echo "config script failed" >> /tmp/${APP_NAME}-config.err
  exit 80
else
  touch /tmp/${APP_NAME}-config.done
  exit 0
fi

