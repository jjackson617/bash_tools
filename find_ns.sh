#!/bin/bash

# Declare VARIABLE for user given file

DOMAIN_FILE=$1

# NS look up 

while read -r line; do 
    NS=$(whois $line | grep "Name Server" | head -4);
    if [[ $(echo $NS | grep -o AWSDNS | head -1) == "AWSDNS" ]]; then 
        echo -e "\n$line already pointing to AMAZON"
    else
        if [[ $(echo $NS | grep -o DYNECT.NET | head -1) == DYNECT.NET ]]; then
            echo -e "\n$line is pointing to DYN"
        else
            if [[ $(echo $NS | grep -o STABLETRANSIT.COM | head -1) == STABLETRANSIT.COM ]]; then
                echo -e "\n$line is pointing to RACKSPACE"
            else
                echo -e "\n$line is pointing to $NS"
            fi
        fi
    fi

done < $DOMAIN_FILE

