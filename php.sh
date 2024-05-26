#!/bin/bash

# Path to the php.ini file
PHP_INI="/etc/php/7.4/fpm/php.ini"

# New values
MEMORY_LIMIT="512M"
UPLOAD_MAX_FILESIZE="512M"
POST_MAX_SIZE="512M"
MAX_EXECUTION_TIME="1500"
MAX_INPUT_TIME="1500"
DATE_TIMEZONE="Asia/Jakarta"

# Function to update the php.ini configuration
update_php_ini() {
    local param="$1"
    local value="$2"
    local file="$3"

    if grep -q "^$param" "$file"; then
        # Parameter exists, update its value
        sed -i "s|^$param.*|$param = $value|" "$file"
    else
        # Parameter does not exist, add it
        echo "$param = $value" >> "$file"
    fi
}

# Update the php.ini settings
update_php_ini "memory_limit" "$MEMORY_LIMIT" "$PHP_INI"
update_php_ini "upload_max_filesize" "$UPLOAD_MAX_FILESIZE" "$PHP_INI"
update_php_ini "post_max_size" "$POST_MAX_SIZE" "$PHP_INI"
update_php_ini "max_execution_time" "$MAX_EXECUTION_TIME" "$PHP_INI"
update_php_ini "max_input_time" "$MAX_INPUT_TIME" "$PHP_INI"
update_php_ini "date.timezone" "$DATE_TIMEZONE" "$PHP_INI"

# Restart PHP-FPM and Nginx to apply changes
sudo systemctl restart php7.4-fpm
sudo systemctl restart nginx

echo "PHP configuration updated successfully."