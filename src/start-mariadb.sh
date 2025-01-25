#!/bin/bash
echo "Starting MariaDB"
exec /usr/local/bin/docker-entrypoint.sh mariadbd
