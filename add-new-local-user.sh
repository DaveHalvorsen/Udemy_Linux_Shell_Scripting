#!/bin/bash
#
# This shell script creates a new user on the Linux system.
# It requires a username at minimum. You can also add a comment afterwards.
# This script will create, and assign, a random password for the account. 
# Finally, this script will print out the username, comment and hostname.
#

# User running this script must have root privileges, otherwise exit status 1
if [[ "${UID}" -ne 0 ]]
then
  echo "You are not root! The account was not created. Goodbye."
  exit 1
fi

# Count the number of parameters entered
NUMBER_OF_PARAMETERS="${#}"

# Provide a usage statement if the user does not supply an account name, otherwise exit status 1
if [[ "${NUMBER_OF_PARAMETERS}" -lt 1 ]]
then
  echo "Usage: You need to enter at least the user name." 
  exit 1
fi

# use first argument as the username for the account, remaining arguments are comments
USER_NAME=${1}

# All remaining entires are entered as comments
shift
COMMENT="${@}"

# Create the user account with the comment
useradd -c "${COMMENT}" -m ${USER_NAME}

# inform the user if the account creation step failed and make exit status 1
if [[ "${?}" -ne 0 ]]
then
  echo "The account creation step failed."
  exit 1
fi

# create a password
CREATED_PASSWORD=$(date +%s%N | sha256sum | head -c48)

# assign the randomly created password to the user account
echo ${CREATED_PASSWORD} | passwd --stdin ${USER_NAME}

# inform the user if the password addition failed and exit with status 1
if [[ "${?}" -ne 0 ]]
then
  echo "The password creation step failed."
  exit 1
fi

# make the user create a new password after first login
passwd -e ${USER_NAME}

# display the username, password, and host where the account was created. 
echo "Your username is ${USER_NAME}"
echo
echo "Your hostname is ${HOSTNAME}"
echo
echo "Your password is ${CREATED_PASSWORD}"
exit 0
