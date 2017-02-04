# docker image
FROM ubuntu:16.04

# maintainer information
MAINTAINER ayapapa ayapapajapan@yahoo.co.jp

# environment vars
ENV ALM_HOME="/home/alm"  \
    ALM_HOSTNAME="localhost" \
    ALM_ENABLE_SSL="N" \
    ALM_RELATIVE_URL_ROOT="" \
    ALM_DB_HOST=db \
    ALM_DB_ROOT_PASS= \
    ALM_ENABLE_JENKINS="N" \
    ALM_ENABLE_AUTO_BACKUP="y" \
    ALM_BACKUP_MINUTE="0" \
    ALM_BACKUP_HOUR="3" \
    ALM_BACKUP_DAY="*/2" \
    ALM_BACKUP_EXPIRY="14" \
    ALM_BACKUP_DIR="/var/opt/alminium-backup" \
    ALM_BACKUP_LOG="/opt/alminium/log/backup.log" \
    ALM_DB_SETUP="N" \
    ALM_VER="dev" \
    RM_VER="3.3.2" \
    DEBIAN_FRONTEND="noninteractive"
    
  # auto backup in every 2 days at 3 A.M.

# upgrade
#RUN apt-get update && apt-get dist-upgrade -y

# install git
RUN apt-get update && apt-get dist-upgrade -y && \
    apt-get install -y apache2 bc g++ git \
      imagemagick libapache2-mod-passenger libapache2-mod-perl2 \
      libapache2-mod-wsgi libapache2-svn libdbd-mysql-perl \
      libdbi-perl libmagickcore-dev libmagickwand-dev \
      libmysqlclient-dev libsqlite3-dev libssl-dev make \
      mercurial mysql-client php-mysql ruby ruby-dev subversion \
      supervisor unzip wget && \
    apt-get clean -y && apt-get autoremove -y && apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt /tmp/*

# clone alminium
COPY ./install.sh ${ALM_HOME}/install.sh
RUN ${ALM_HOME}/install.sh

# Expose web
EXPOSE 80 443

# Define data volumes
VOLUME ["/opt/alminium/files", "/var/opt/alminium", "/var/lib/mysql", "/var/log/alminium"]

# supervisor config
COPY ./supervisord.conf /etc/supervisord.conf

# working directory
WORKDIR ${ALM_HOME}

# deamon
ENTRYPOINT /usr/bin/supervisord -c /etc/supervisord.conf

# command
CMD /bin/bash

