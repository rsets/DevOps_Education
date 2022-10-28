#!/bin/bash



info (){ #green info

        lgreen='\e[92m'

        nc='\033[0m'

        printf "${lgreen} ${@}${nc}\n"

}



install_nginx () { 

        info "Nginx installation started"

        sudo apt-get update

        sudo apt-get -y install nginx

}



firewall_setup () { 

        info "Making changes in firewall"

        ufw allow 'Nginx HTTP'

        ufw status

}



install_nginx
sleep 5
firewall_setup
