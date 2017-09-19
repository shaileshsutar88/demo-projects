#!/bin/bash
#
# Author : Shailesh Sutar
# Purpose : Vagrant 14.04 setup nginx with custom php page
#
#
sudo sh -c 'echo "deb http://nginx.org/packages/mainline/ubuntu/ trusty nginx" >> /etc/apt/sources.list'
sudo sh -c 'echo "deb-src http://nginx.org/packages/mainline/ubuntu/ trusty nginx"  >> /etc/apt/sources.list'
sudo sh -c 'curl http://nginx.org/keys/nginx_signing.key | apt-key add -'
sudo apt-get update
sudo sh -c 'apt-get install -y nginx'
sudo sh -c 'apt-get install python-software-properties'
sudo sh -c 'add-apt-repository ppa:ondrej/php5 -y'
sudo sh -c 'DEBIAN_FRONTEND=noninteractive apt-get install -y php5 php5-fpm'
sudo sh -c "sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php5/fpm/php.ini"
sudo sh -c "sed -i 's|/var/run/php5-fpm.sock|127.0.0.1:9000|g' /etc/php5/fpm/pool.d/www.conf"
sudo sh -c 'mkdir -p /var/www/html'
cat <<EOT>> /var/www/html/index.php
<?php
$dt = new DateTime();
echo "Today is ". date("l"). " " . date("d-m-Y") . "<br>";
echo "And time now is ". $dt->format('H:i:s');
?>
EOT

cat <<EOT>> /etc/nginx/conf.d/default
server {
        listen   80;

        root /var/www/html;
        index index.php index.html index.htm;
        server_name  example.com www.example.com;

        location / {
                try_files $uri $uri/ /index.html;
        }

        error_page 404 /404.html;
        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
              root /usr/share/nginx/www;
        }

        location ~ .php$ {
                try_files $uri =404;
                fastcgi_pass 127.0.0.1:9000;
                fastcgi_param SCRIPT_FILENAME /scripts$fastcgi_script_name;
                fastcgi_index index.php;
                fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
                include fastcgi_params;
        }
}
EOT

sudo /etc/init.d/nginx restart
sudo /etc/init.d/php-fpm restart
