#!/bin/bash

DOMAIN_FILE=$1


# add "*." to domains for requesting certs.

while read -r line; do 
    echo "*.$line"

done < $DOMAIN_FILE

# echo domains without wildcard
while read -r line; do 
    echo "$line"

done < $DOMAIN_FILE