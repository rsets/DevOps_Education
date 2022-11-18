#!/bin/bash

info () {
    lgreen='\e[92m'
    nc='\033[0m'
    printf "${lgreen}[Info] ${@}${nc}\n"
}

error () {
    lgreen='\033[0;31m'
    nc='\033[0m'
    printf "${lgreen}[Error] ${@}${nc}\n"
}

LOG_FILE="/var/log/script_backup_logfile.txt"
BACKUP_DIR="/home/rsets2/sql_backup"

if [ $(id -u) -ne 0 ];
then 
	error "Please run as root user!";
	exit 1;
else
	info "You run this script as root user, proceeding with script..."
fi


backup_create () {

info "Starting backup creation..."

mkdir $BACKUP_DIR

mysqldump -u root -p  DevOps_Education > $BACKUP_DIR/mysqlbak.sql

if [ $? -eq 0 ];
        then
	        info "Backup DB compelete succesffully."
	else
		error "Backup DB failed."
	exit 1
    fi
}

main () {

backup_create

}
main
