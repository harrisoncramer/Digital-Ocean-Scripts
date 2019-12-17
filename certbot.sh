#!/bin/bash

sudo add-apt-repository ppa:certbot/certbot
sudo apt install python-certbot-nginx

if [[ "${?}" -ne 0 ]]
then
    echo "Could not install Certbot."
    usage
    exit 1
fi

# Turn off firewall for testing purposes...
sudo ufw allow 443
sudo ufw allow 80

usage(){
    echo "${0} DOMAIN.SUFFIX EMAIL"
    # Turn off firewall...
    sudo ufw delete allow 443
    sudo ufw delete allow 80
}

sudo certbot --nginx -d ${1} -d www.${1} -n --agree-tos --email ${2} # Use -n and --agree-tos to run non-interactively, and -m for email.

if [[ "${?}" -ne 0 ]]
then
    echo "Could not setup certbot keys."
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

# Turn off firewall for testing purposes...
sudo ufw delete allow 443
sudo ufw delete allow 80

sudo systemctl reload nginx
echo "Certbot successfully installed."
ABSOLUTE_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")";
rm "${ABSOLUTE_PATH}"