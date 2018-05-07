#!/bin/bash
# TODO: make it add wildcard instead
# TODO: make python script to do acm request instead?
CERTIFICATE_ARN=$1
for domain in $(cat list); do
    # strip away wildcard for send domain
    stripped_domain=$(echo ${domain} |  sed 's/*.//g')
    echo "resending for domain: ${domain}"
    echo "email domain to use: ${stripped_domain}"
    aws acm resend-validation-email --certificate-arn "${CERTIFICATE_ARN}" --domain "${domain}"  --validation-domain "${stripped_domain}"
    sleep 5
done

