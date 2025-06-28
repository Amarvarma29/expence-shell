#!/bin/bash

#!/bin/bash

LOGS_FOLDER="/var/log/expense"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME-$TIMESTAMP.log"
mkdir -p $LOGS_FOLDER

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

CHECK_ROOT(){
    if [ $USERID -ne 0 ]
    then
        echo -e "$R Please run this script with root priveleges $N" | tee -a $LOG_FILE
        exit 1
    fi
}

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 is...$R FAILED $N"  | tee -a $LOG_FILE
        exit 1
    else
        echo -e "$2 is... $G SUCCESS $N" | tee -a $LOG_FILE
    fi
}

echo "Script started executing at: $(date)" | tee -a $LOG_FILE

CHECK_ROOT

dnf install mysql-server -y &>>$LOG_FILE
VALIDATE $? "Installing MySQL Server"

systemctl enable mysqld &>>$LOG_FILE
VALIDATE $? "Enabled MySQL Server"

systemctl start mysqld &>>$LOG_FILE
VALIDATE $? "Started MySQL server"

mysql -h mysql.daws81s.online -u root -pExpenseApp@1 -e 'show databases;' &>>$LOG_FILE
if [ $? -ne 0 ]
then
    echo "MySQL root password is not setup, setting now" &>>$LOG_FILE
    mysql_secure_installation --set-root-pass ExpenseApp@1
    VALIDATE $? "Setting UP root password"
else
    echo -e "MySQL root password is already setup...$Y SKIPPING $N" | tee -a $LOG_FILE
fi

# Assignment
# check MySQL Server is installed or not, enabled or not, started or not
# implement the above things

# # LOGS_FOLDER="/var/log/shell_script"
# # script_NAME=$( echo $0 | cut -d "." -f1)
# # TIME_STAMP=$(date +%y-%m-%d-%H-%M-%S)
# # LOGS_FILE="$LOGS_FOLDER/$SCRIPT_NAME-$TIME_STAMP.log"

# # mkdir -p $LOGS_FOLDER

# # R="\e[31m"
# # G="\e[32m"
# # Y="\e[0m"

# echo "script started executing : $(date)"

# USERID=$( id -u )
# if [ USERID -ne 0 ]
# then 
#      echo "please run the script with r0ot previliges"
#      exit 1
# fi


# VALIDATE(){
#     if [ $1 -ne 0 ]
#     then 
#         echo " command $2 is not succes"
#         exit 1
#     else
#         echo "command $2 is sucess"
#     fi    
# }

# dnf install mysql-server -y
# VALIDATE $? "installing mysql-server"

# systemctl enable mysqld 
# VALIDATE $? "enable mysqld"

# systemctl start mysqld
# VALIDATE $? "start the service"

# mysql -h mysql.amarvarma81s.online -u root -pExpenceApp@1 -e "show databases"
# if [ $? -ne 0 ]
# then
#      echo" passwd not set plese set up"
#      mysql_secure_installation --set-root-pass ExpenseApp@1
#      VALIDATE $? "set root password"
# else 
#      echo " passwd is alredy set up"
# fi









