# pj1004/ianseo-combo - docker build

## Combined Docker Build for World Archery IANSEO System and Database


### Info:
 - Author - PJ1004
 - Version - 2.3
 - Last Modified - 17-Dec-2025


### Context:
 - Database - MariaDB:12
 - Apache Webserver - PHP 8.5
 - Ianseo - 20250210

## Docker RUN

Pull the combined ianseo php and mariadb database docker image and run as follows:

```
docker run -dt -p 80:80 [-p 3306:3306] [--env-file ./.env] --name ianseo pj1004/ianseo-combo:latest
```

### Architectures

For the latest docker image with linux/amd64 use:
* pj1004/ianseo-combo:latest
* pj1004/ianseo-combo:amd64

For Apple Silicon devices or aarch64 use:
* pj1004/ianseo-combo:arm64


## Environment Variables

Create an environment file and add it to the docker run command using `--env-file /path/to/env`

### MariaDB - Auto upgrade Database

Default variable to allow MariaDB to automatically upgrade the datbase if version changes.
Set to 0 to disable

```
MARIADB_AUTO_UPGRADE=1
```

### MariaDB - Root Password

Either enable a random password, or manually specifiy a password:

```
#MARIADB_RANDOM_ROOT_PASSWORD=1
MARIADB_ROOT_PASSWORD=
```

### MariaDB - Default DB

Initialise a database for use with IANSEO:

```
MARIADB_DATABASE=ianseo
MARIADB_USER=ianseo
MARIADB_PASSWORD=ianseo
```


### First Run:
When connecting to the database on the IANSEO first-run screen, just enter `localhost` in the write server Host field.  The root password is not required as a blank 'ianseo' database is created at first-time startup along with the 'ianseo' user.

Refer to the .env file if you wish to change the password or database settings before first run.
If you want to retain your customisations in the .env file for future versions, add ".env" to your ".gitignore" file
