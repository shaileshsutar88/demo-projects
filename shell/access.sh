#!/bin/bash
#
#
# Purpose : Shell script to grant/revoke access to user for particular group of servers.
#
# Author : Shailesh Sutar
#
# Date : 28th July 2016
# 

if [ $# -ne 4 ]; then
    echo "Usage:"
    echo "./dev-enable.sh <username> <file> <public-key-file> <access-type>"
    echo "username should name of users who's access needs to be enable or disable "
    echo "file which contains list of IP's of servers"
    echo "acess type should either 'grant' or 'revoke' particularly"
    exit 1
fi
user=$1
file=$2
keyfile=$3
access=$4
basekey="/home/test-user/aws/test.pem" 
userkey="/home/test-user/.ssh/id_rsa.pub"
user1="ec2-user"

function grant-access {
	for line in `cat $file`
	do
		ssh -i $basekey -o strictHostKeyChecking=no $user1@$line sudo useradd -m -d /home/$user $user
		ssh -i $basekey -o strictHostKeyChecking=no $user1@$line sudo mkdir /home/$user/.ssh
		ssh -i $basekey -o strictHostKeyChecking=no $user1@$line sudo touch /home/$user/.ssh/authorized_keys
		ssh -i $basekey -o strictHostKeyChecking=no $user1@$line sudo chmod 777 -R /home/$user/.ssh
		ssh -i $basekey -o strictHostKeyChecking=no $user1@$line sudo bash -c "'cat > /home/$user/.ssh/authorized_keys'" < $userkey
		ssh -i $basekey -o strictHostKeyChecking=no $user1@$line sudo chmod 600 /home/$user/.ssh/authorized_keys
		ssh -i $basekey -o strictHostKeyChecking=no $user1@$line sudo chown $user.$user /home/$user/.ssh/authorized_keys
		ssh -i $basekey -o strictHostKeyChecking=no $user1@$line sudo chmod 700 /home/$user/.ssh
		ssh -i $basekey -o strictHostKeyChecking=no $user1@$line sudo chown $user.$user /home/$user/.ssh
	done
}

function revoke-access {
	for line in `cat $file`
	do
		#echo ssh -i $basekey -o strictHostKeyChecking=no $user1@$line sudo userdel -f $user
		ssh -i $basekey -o strictHostKeyChecking=no $user1@$line sudo userdel -f $user
		echo "Deleting users .ssh directory with key access"
		ssh -i $basekey -o strictHostKeyChecking=no $user1@$line sudo rm -rf /home/$user/.ssh
	done
}

if [ $access == "grant" ]
then
	grant-access
elif [ $access == "revoke" ]
then
	revoke-access
else
	echo " Wrong Keyword!!!! Use only grant or revoke"
fi
