#!/bin/bash


# source variables
. /home/ubuntu/build/scripts/runtime_config_vars.prop

# pull from git
sudo -u apprunner git clone git@github.com:adharmonics/secure_post.git /evq/apprunner/${APP_NAME}


## secure-post/link configuration
