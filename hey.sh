#!/bin/bash
set -x

LIST=$1    #provide list.txt of domain names to be checked

curl_me() {
  curl --silent --output /dev/null http://$DOMAIN --connect-timeout 5
  
}

while read -r DOMAIN; do 
    curl_me; 
    if [[ $(curl_me) ]]; then
        if [ $? -eq 0 ]; then # curl didn't return 0 - failure
            
            echo -e "\n$DOMAIN $?"
        fi
        
        if [ $? -eq 60 ]; then # curl didn't return 0 - failure
                
            echo -e "\n$DOMAIN $? SSL Cert not authenticated"
        fi

          if [ $? -gt 0 ]; then # capture other infrequent errors
    
            echo -e "\n$DOMAIN $?"
          fi
       
    fi
    if [ $? == 0 ]; then
      echo "its fine"
    fi
done < $LIST