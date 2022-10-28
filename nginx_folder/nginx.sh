#!/bin/bash

#VARIABLES:
GIT="/home/rsets/DevOps_Education/nginx_folder/"

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

if [ $(id -u) -ne 0 ];
then 
	error "Please run as root user!";
	exit 1;
else
	info "You run this script as root user, proceeding with script..."
fi


install_nginx () { 

        info "Nginx installation started."
        sudo apt-get update
        sudo apt-get -y install nginx
		info "Nginx installation completed."
}

conf_site_modifying () {

#Replacing config and site files.
sudo rm /etc/nginx/nginx.conf
sudo cp $GIT/nginx.conf /etc/nginx/

sudo unlink /etc/nginx/sites-available/default
sudo cp $GIT/rsetsite.com
sudo ln -s /etc/nginx/sites-available/rsetsite.com /etc/nginx/sites-enabled/

sudo systemctl daemon-reload
sudo systemctl start nginx
sudo systemctl status nginx
sudo systemctl enable nginx
#Replacing configs are completed.

}



firewall_setup () { 
        info "Making changes in firewall"
        ufw allow 'Nginx HTTP'
        ufw status
}


main () {
sleep 5
install_nginx
sleep 5
conf_site_modifying
sleep 5
firewall_setup
}
main