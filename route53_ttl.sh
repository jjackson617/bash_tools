#!/bin/bash

#Get Hosted Zones
HOSTED_ZONES=$(aws route53 list-hosted-zones --query 'HostedZones[*].Id')

HZ_IDS=$(aws route53 list-hosted-zones --query 'HostedZones[*].Id')

#for each
for HOST in $(echo "$HOSTED_ZONES"); do
    #Domain name
    DOMAIN=$(echo "$HOST" | tr -d ' ",[]'| sed '/^\s*$/d')
    #Hostzone ID
    HOST_ID=$(echo "$HOST"  | tr -d ' "/hostedzone,[]'| sed '/^\s*$/d')
    echo "$DOMAIN has $HOST_ID"





