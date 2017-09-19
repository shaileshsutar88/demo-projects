#!/bin/bash
#
# Purpose : Shell script to deploy Maintenance page before actual web application deployment - Ubuntu.
#
# Author : Shailesh Sutar
#
# Date : 15th September 2016
# 
# Environment : Ubuntu 16.04 LTS with nginx and php-fpm
#

if [ $# -ne 1 ]; then
    echo "Usage:"
    echo "./maintenace-ubuntu.sh <deployment-state>"
    echo "state type should either 'production' or 'maintenance' "
    exit 1
fi
state=$1
serv1="/etc/init.d/nginx"
serv2="/etc/init.d/php7.0-fpm"

function production {
	sudo sed -i "s|/var/www/maintenace|/var/www/example|g" /etc/nginx/conf.d/production.conf
	sudo sed -i "s|/var/www/example|/var/www/maintenance|g" /etc/nginx/conf.d/maintenance.conf
	sudo $serv1 restart
	sudo $serv2 restart
}

function maintenance {
	sudo sed -i "s|/var/www/example|/var/www/maintenance|g" /etc/nginx/conf.d/production.conf
	sudo sed -i "s|/var/www/maintenance|/var/www/example|g" /etc/nginx/conf.d/maintenance.conf
    sudo $serv1 restart
    sudo $serv2 restart
}

if [ $state == "maintenance" ]
then
	maintenance
elif [ $state == "production" ]
then
	production
else
	echo " Wrong Keyword!!!! Use only production or maintenance."
fi
