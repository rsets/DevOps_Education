#!/bin/bash

#SOME USEFULL STUFF:
info () { # green info
    lgreen='\e[92m'
    nc='\033[0m'
    printf "${lgreen} ${@}${nc}\n"
}

error () { # red error
    lgreen='\033[0;31m'
    nc='\033[0m'
    printf "${lgreen} ${@}${nc}\n"
}

#VARIABLES:
LOG_FILE="/var/log/script_php_install.txt"
PASS_MYSQL="RagingKraken18!"

mysql_install () {
	info "Installing MySQL is in progress..."
	sudo apt update -y >> $LOG_FILE
	sudo apt install -y mysql-server >> $LOG_FILE

	info "Replacing my.cnf file with the new one. It is located in /etc/mysql/ folder."
	sudo cp /home/rsets/mysql_files/my.cnf /etc/msql/

	sudo systemctl enable mysql.service
	sudo mysql_secure_installation >> $LOG_FILE


	info "Restarting MySQL service for the changes to take effect."
	sudo systemctl restart mysql.service
}

add_user_mysql () {
	info "Creating new user in MySQL and granting all privileges."
	mysql --user="root" --password=$PASS_MYSQL --database="mysql" --execute="CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin';" >> $LOG_FILE
	mysql --user="root" --password=$PASS_MYSQL --database="mysql" --execute="GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost' WITH GRANT OPTION;" >> $LOG_FILE

}

nginx_install () {
	info "Installing NGINX is in progress..."
	sudo apt -y install nginx
	nginx -v
}

php_install () {
	info "Installing PHP is in progress..."
	sudo apt-get install software-properties-common >> $LOG_FILE
	sudo add-apt-repository ppa:ondrej/php >> $LOG_FILE
	sudo apt install -y php8.0-fpm php8.0-common php8.0-mysql php8.0-gmp php8.0-curl php8.0-intl php8.0-mbstring php8.0-xmlrpc php8.0-gd php8.0-xml php8.0-cli php8.0-zip >> $LOG_FILE
}

phpmyadmin_install () {
	info "Installing phpmyadmin is in progress..."
	sudo apt install -y phpmyadmin php-mbstring php-zip php-gd php-json php-curl >> $LOG_FILE
}

phpmyadmin_configuration () {
	info "Copying configurations for php+nginx is in progress..."
	sudo cp /home/rsets/nginx_files/nginx.conf /etc/nginx
	sudo cp /home/rsets/nginx_install/rsets /etc/nginx/sites-available/
	sudo ln -s /etc/nginx/sites-available/rsets /etc/nginx/sites-enabled/
	sudo cd /etc/nginx/sites-enabled/ | unlink default
	
	cp /home/rsets/nginx_files/key.key /etc/ssl/private/
	cp /home/rsets/nginx_files/cert.crt /etc/ssl/private/
	
	nginx -t >> $LOG_FILE
	sudo systemctl restart nginx >> $LOG_FILE
}

firewall_config() {
        sudo ufw allow 'Nginx HTTP'
        sudo ufw status >> $LOG_FILE
}

main () {
	
	mysql_install
	add_user_mysql
	nginx_install
	php_install
	phpmyadmin_install
	phpmyadmin_configuration
	firewall_config
}

main
