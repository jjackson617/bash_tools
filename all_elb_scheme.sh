#!/bin/bash

IFS=$'\n'


# Get all elbs

ALL_ELB_DATA=$(aws elb describe-load-balancers --query 'LoadBalancerDescriptions[*].[DNSName,LoadBalancerName,Scheme]' --output text)


# line all this shit up

    for i in $(echo "$ALL_ELB_DATA"); do 
    ELB=$(echo "$i" | awk '{print $1}')

    ELB_NAME=$(echo "$i" | awk '{print $2}')

    SCHEME=$(echo "$i" | awk '{print $3}')

    echo -e "\n$ELB, $ELB_NAME, $SCHEME"
done
