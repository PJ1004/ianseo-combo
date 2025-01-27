#!/bin/bash

## Set default variables of no ENV File is provided
echo "Configuring default environment"
if [ -z "$MARIADB_AUTO_UPGRADE" ]; then
  echo "Setting MARIADB_AUTO_UPGRADE=1"
  export MARIADB_AUTO_UPGRADE=1
fi

if [ -z "$MARIADB_ROOT_PASSWORD" ]; then
  echo "No root password provided, generating random password"
  export MARIADB_RANDOM_ROOT_PASSWORD=1
fi

if [ -z "$MARIADB_DATABASE" ]; then
  echo "Setting MARIADB_DATABASE=ianseo"
  export MARIADB_DATABASE="ianseo"
fi

if [ -z "$MARIADB_USER" ]; then
  echo "Setting MARIADB_USER=ianseo"
  export MARIADB_USER="ianseo"
fi

if [ -z "$MARIADB_PASSWORD" ]; then
  echo "Setting MARIADB_PASSWORD=ianseo"
  export MARIADB_PASSWORD="ianseo"
fi

exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
