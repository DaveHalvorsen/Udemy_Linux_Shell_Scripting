#!/bin/bash

# This is exercise 2 from the Udemy: Linux Shell Scripting Class
# The task is to create a shell script that creates a new user on a local system
# The script will ask you for a username, person's name, and thier password

# This checks to make sure that the user running it is root before continuing
# -ne stands for "not equal to 0". UID is user id. Root UID is always 0.
if [[ "${UID}" -ne 0 ]]
then 
  echo "You are not root! The accout was not created. Goodbye."
  exit 1
fi

# This prompts you for the username for the new user
read -p 'Enter the username to create: ' USER_NAME

# This asks you for the real name of the user (to be stored as a comment)
read -p 'Enter the real name of the user: ' COMMENT

# This asks you to enter a password for the new user
read -p 'Enter the password to use for the account: ' PASSWORD

# try to create the user account. -c is comment. -m creates user's home directory
useradd -c "${COMMENT}" -m ${USER_NAME}

# This checks that the previous command (make user) ran alright
if [[ "${?}" -ne 0 ]]
then
  echo 'The user creation command did not complete successfully'
  exit 1
fi

# This creates a password for the user that was just created
echo ${PASSWORD} | passwd --stdin ${USER_NAME}

# This checks that the previously run command (create password) worked
if [[ "${?}" -ne 0 ]]
then 
  echo 'The password creation command did not complete successfully'
  exit 1
fi

# make them change the initial password once they login
passwd -e ${USER_NAME}

# display username, password, and host where the password was created
echo "Your username is ${USER_NAME}"
echo "Your hostname is ${HOSTNAME}"
echo "Your password is ${PASSWORD}"
exit 0

