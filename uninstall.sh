#!/bin/bash

# Function to print text in green
green() {
  printf "\e[32m$1\e[0m\n"
}

# Function to print text in red
red() {
  printf "\e[31m$1\e[0m\n"
}

# Warning message
red "WARNING: YOU ARE ABOUT TO DELETE SERVICES, DB's, AND MORE."
red "ARE YOU SURE YOU WANT TO CONTINUE? (y/N): "
read -r response

if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  # Step 1: Stop service
  green "Stopping service..."
  sudo service odoo-server stop
  sudo pkill -u odoo

  # Step 2: Remove config file(s)
  green "Removing config files..."
  sudo rm -f /etc/odoo-server.conf
  sudo rm -f /etc/odoo.conf

  # Step 3: Remove application code
  green "Removing application code..."
  sudo rm -R /odoo

  # Step 4: Remove startup process
  green "Removing startup process..."
  sudo update-rc.d -f odoo-server remove
  sudo rm -f /etc/init.d/odoo-server

  # Step 5: Remove logs
  green "Removing logs..."
  sudo rm -R /var/log/odoo
  # Step 6: Remove databases
  green "Would you like to remove PostgreSQL completely or just a specific database? [COMPLETE/DB_NAME]: "
  read -r db_choice

  if [[ $db_choice == "COMPLETE" ]]; then
    green "Removing PostgreSQL..."
    sudo service postgresql stop
    sudo apt-get remove postgresql -y
    sudo apt-get --purge remove postgresql* -y
    sudo rm -r -f /etc/postgresql/
    sudo rm -r -f /etc/postgresql-common/
    sudo rm -r -f /var/lib/postgresql/
  else
    green "Removing the database $db_choice..."
    sudo su - postgres -c "psql -c \"SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = '$db_choice' AND pid <> pg_backend_pid();\""
    sudo su - postgres -c "psql -c \"DROP DATABASE $db_choice;\""
  fi


 
  # Step 7: Delete users and groups
  green "Deleting users and groups..."
  sudo userdel -r postgres
  sudo groupdel postgres
  sudo userdel -r odoo
  sudo groupdel odoo

  green "Odoo removal complete."
else
  red "Odoo removal cancelled."
fi
