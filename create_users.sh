#!/bin/bash
#check if script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Check if the input file is provided
if [ -z "$1" ]; then
  echo "Usage: bash create_users.sh <name-of-text-file>"
  exit 1
fi

INPUT_FILE="$1"
LOG_FILE="/var/log/user_management.log"
PASSWORD_FILE="/var/secure/user_passwords.txt"

# Ensure log and password files exist and have the correct permissions
touch $LOG_FILE
chmod 644 $LOG_FILE

mkdir -p /var/secure
touch $PASSWORD_FILE
chmod 600 $PASSWORD_FILE

# Function to generate random password
generate_password() {
  openssl rand -base64 12
}

# Process the input file
while IFS=';' read -r username groups; do
  # Create personal group for the user
  if ! getent group "$username" &>/dev/null; then
    groupadd "$username"
    echo "Created group $username" | tee -a $LOG_FILE
  fi

  # Check if user already exists
  if id "$username" &>/dev/null; then
    echo "User $username already exists. Skipping..." | tee -a $LOG_FILE
    continue
  fi

  # Create user and personal group
  useradd -m -s /bin/bash -g "$username" "$username"
  if [ $? -eq 0 ]; then
    echo "Created user $username with a personal group $username" | tee -a $LOG_FILE
  else
    echo "Failed to create user $username" | tee -a $LOG_FILE
    continue
  fi

  # Generate password and set it for the user
  password=$(generate_password)
  echo "$username:$password" | chpasswd
  if [ $? -eq 0 ]; then
    echo "$username,$password" >> $PASSWORD_FILE
    echo "Set password for $username" | tee -a $LOG_FILE
  else
    echo "Failed to set password for $username" | tee -a $LOG_FILE
  fi

  # Create additional groups if specified
  if [ -n "$groups" ]; then
    IFS=',' read -ra group_array <<< "$groups"
    for group in "${group_array[@]}"; do
      # Create group if it doesn't exist
      if ! getent group "$group" &>/dev/null; then
        groupadd "$group"
        echo "Created group $group" | tee -a $LOG_FILE
      fi

      usermod -aG "$group" "$username"
      if [ $? -eq 0 ]; then
        echo "Added $username to group $group" | tee -a $LOG_FILE
      else
        echo "Failed to add $username to group $group" | tee -a $LOG_FILE
      fi
    done
  fi
done < "$INPUT_FILE"

echo "User creation process completed." | tee -a $LOG_FILE
