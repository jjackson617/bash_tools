#!/bin/bash

# upgrade pip3 & install wooey/wooey reqs

sudo pip3 install --upgrade pip
sudo pip3 install wooey
sudo pip3 install django
sudo pip3 install django-core




# passenger config
#replace /usr/share/passenger-enterprise/helper-scripts/wsgi-loader.py making it specifically for python3 with something like #!/usr/bin/env python3
#turn off debugging, DEBUG = False; set ALLOWED_HOSTS = ['wooey-staging.adh8.com']

# *** Important passenger will not work if not explicitly told to use python3 that is why we need to #!/usr/bin/env python3 or #!/usr/bin/python3 either should work fine I think*** 