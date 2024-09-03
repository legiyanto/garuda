#!/bin/bash

# Path to the nginx configuration file
NGINX_CONF="/etc/nginx/sites-available/default"

# Create the nginx configuration content
NGINX_CONF_CONTENT='
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.php index.html index.htm index.nginx-debian.html;
    server_name _;

    location / {
        try_files $uri $uri/ /index.php?$args;
    }

    location ~ \.php$ {
        try_files $fastcgi_script_name =404;
        include fastcgi_params;
        fastcgi_connect_timeout 1000;
        fastcgi_send_timeout 1000;
        fastcgi_read_timeout 1000;
        fastcgi_pass unix:/run/php/php7.4-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param DOCUMENT_ROOT $realpath_root;
        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
    }

}'

# Backup the original configuration file
cp $NGINX_CONF $NGINX_CONF.bak

# Write the new configuration to the file
echo "$NGINX_CONF_CONTENT" > $NGINX_CONF

# Test the nginx configuration for syntax errors
nginx -t

# If the test is successful, reload nginx to apply the changes
if [ $? -eq 0 ]; then
    systemctl reload nginx
    echo "Nginx configuration updated and reloaded successfully."
else
    echo "Nginx configuration test failed. Reverting changes."
    mv $NGINX_CONF.bak $NGINX_CONF
    systemctl reload nginx
fi
