#!/bin/bash

id=`id -u`
G="\e[32m"
N="\e[0m"
R="\e[31m"
Y="\e[31m"
nginx=`yum list installed | grep nginx`
if [ $id -ne 0 ]; then
    echo -e "$R Please run as root user $N"
    exit 1
fi

echo "Below are list of packages to install "
echo "1) nginx"
echo "2) redis"
echo "3) nodejs"
echo "4) exit"

echo "Please select package\n" 
read package

case $package in

    1)   
        yum list installed | grep nginx
        if [ $? -eq 0 ]; then
            echo -e  "$Y package alreay installed $N"
            exit 1
        else
            echo -e "$G installing nginx package $N"
            yum install nginx -y
            systemctl statrt nginx
            systemctl enable nginx
        fi    
        ;;
    2)
        echo -e "$G Installing redis package $N"
        yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
        yum module enable redis:remi-6.2 -y
        sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf
        systemctl enable redis
        systemctl start redis

        ;;
    3)
        echo -e "$G Installing nodejs package $N"
        dnf module disable nodejs -y
        dnf module enable nodejs:18 -y
        dnf install nodejs -y

        ;;
    4)
        echo -e "$R exiting $N"
        ;;
    *)
        echo -e "$R please select above options $N"
esac
