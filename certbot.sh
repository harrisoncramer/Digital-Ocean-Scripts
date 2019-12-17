#!/bin/bash

usage(){
    echo "${0} DOMAIN.SUFFIX EMAIL"
    echo "This script sets up cerbot. Must provide domain name, and email."
}

sudo certbot --nginx -d ${1} -d www.${1} -n --agree-tos --email ${2} # Use -n and --agree-tos to run non-interactively, and -m for email.

if [[ "${?}" -ne 0 ]]
then
    echo "Could not install certbot."
    usage
    exit 1
fi


sudo certbot renew --dry-run

if [[ "${?}" -ne 0 ]]
then
    echo "Something is misconfigured in Certbot."
    usage
    exit 1
fi

sudo nginx -t

if [[ "${?}" -ne 0 ]]
then
    echo "Nginx is misconfigured."
    exit 1
fi

sudo systemctl reload nginx
echo "Certbot successfully installed."
ABSOLUTE_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")";
rm "${ABSOLUTE_PATH}"