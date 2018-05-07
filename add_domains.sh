#!/bin/bash


#Declare VARIABLE declaration for user given file

DOMAINS_FILE=$1

#Random generator function for caller-reference option
hash() {
    echo $RANDOM$RANDOM | md5
}

#Safety check to avoid creating duplicate hosted zones.... 
#Function is listing hosted zones.

duplicate_check() {
    if [[ $(aws route53 list-hosted-zones --query 'HostedZones[*].Name' | grep $line) ]]; then
        echo "Domain already exists"
    fi
}


while read -r line; do
    duplicate_check;
        if [[ $(duplicate_check) == "Domain already exists" ]]; then 
            echo "Duplicate of $line found. Please remove $line from your list"
            exit 30
        else
            aws route53 create-hosted-zone --name $line --caller-reference $(hash)
        fi
done < $DOMAINS_FILE