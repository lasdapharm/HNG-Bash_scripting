# Automated User Management Script for Linux Systems
Nowadays managing user accounts properly is extremely important for DevOps professionals working in dynamic IT setups.
The pro of user provisioning is that it saves time, ensures consistency , security across systems and improve efficiency since much of the process can be automated.
## Overview 
This project contains a shell script for managing user creation in a Linux environment. The script reads user information from a text file, creates users and groups, sets up home directories, generates random passwords, and logs all actions. This is particularly useful for SysOps engineers managing new developers in a company.
### Script Detail
Script: create_users.sh
The create_users.sh script performs the following tasks:

- Checks if the script is run as root.
- Reads a text file containing usernames and groups.
- Creates users and their personal groups.
- Assigns users to specified groups.
- Sets up home directories with appropriate permissions.
- Generates random passwords for users.
- Logs all actions to /var/log/user_management.log.
- Stores generated passwords securely in /var/secure/user_passwords.txt.
#### Example Input File
The input file should be formatted as follows:
```
  light;sudo,dev,www-data
  idimma;sudo
  mayowa;dev,www-data
```
To view more about the project, a detail article about the project is written here: 
https://dev.to/damilola_lawal_b415434987/automated-user-management-script-for-linux-systems-2olo
Run the script and pass the input_file.txt as argument.
Thank you for reading, to learn more kindly join the HNG internship programme to get your tech skill upgraded and land you dream job.
Follow this link
https://hng.tech/internship,
https://hng.tech/hire

