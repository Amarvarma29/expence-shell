#!/bin/bash

# LOGS_FOLDER="/var/log/shell_script"
# script_NAME=$( echo $0 | cut -d "." -f1)
# TIME_STAMP=$(date +%y-%m-%d-%H-%M-%S)
# LOGS_FILE="$LOGS_FOLDER/$SCRIPT_NAME-$TIME_STAMP.log"

# mkdir -p $LOGS_FOLDER

# R="\e[31m"
# G="\e[32m"
# Y="\e[0m"

echo "script started executing : $(date)"

USERID=$( id -u )
if [ USERID -ne 0 ]
then 
     echo "please run the script with r0ot previliges"
     exit 1
fi


VALIDATE(){
    if [ $1 -ne 0 ]
    then 
        echo " command $2 is not succes"
        exit 1
    else
        echo "command $2 is sucess"
    fi    
}

dnf install mysql-server -y
VALIDATE $? "installing mysql-server"

systemctl enable mysqld 
VALIDATE $? "enable mysqld"

systemctl start mysqld
VALIDATE $? "start the service"

mysql -h mysql.amarvarma81s.online -u root -pExpenceApp@1 -e "show databases"
if [ $? -ne 0 ]
then
     echo" passwd not set plese set up"
     mysql_secure_installation --set-root-pass ExpenseApp@1
     VALIDATE $? "set root password"
else 
     echo " passwd is alredy set up"
fi









