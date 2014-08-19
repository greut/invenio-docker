# Invenio on Ubuntu
#
# VERSION 0.0.4

FROM phusion/baseimage:latest
MAINTAINER Yoan Blanc <yoan.blanc@cern.ch>

ENV DEBIAN_FRONTEND noninteractive
ENV MYSQL_PASS ''

# Set correct environment variables.
ENV HOME /root

# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# Disabling SSH
#RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

## Invenio's stuff

EXPOSE 22
EXPOSE 4000

VOLUME /var/lib/mysql
VOLUME /home/$USER/.virtualenvs

# setup
RUN /bin/echo -e "LANG=\"en_US.UTF-8\"" > /etc/default/local
RUN apt-get update && apt-get -y upgrade

# pidproxy
RUN apt-get install -y python
ADD pidproxy.py /usr/local/bin/pidproxy
RUN chmod +x /usr/local/bin/pidproxy

# MySQL
RUN apt-get install -y mysql-server
RUN rm -rf /var/lib/mysql/*

RUN mkdir /etc/service/mysql
ADD mysql.sh /etc/service/mysql/run
RUN chmod +x /etc/service/mysql/run

ADD setup-mysql.sh /root/setup-mysql.sh
RUN chmod +x /root/setup-mysql.sh

# Redis
RUN apt-get install -y redis-server

RUN mkdir /etc/service/redis
ADD redis.sh /etc/service/redis/run
RUN chmod +x /etc/service/redis/run

# Toolbox
RUN apt-get install -y vim ack-grep git subversion mercurial curl screen build-essential gfortran
# Python stuff
RUN apt-get install -y python-dev python-pip virtualenvwrapper
RUN apt-get install -y libjpeg-dev libfreetype6-dev libmysqlclient-dev libtiff-dev libxml2-dev libxslt-dev libwebp-dev
# PPA-only packages
RUN apt-get install -y python-software-properties software-properties-common python-pycurl
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C7917B12
RUN add-apt-repository ppa:chris-lea/node.js
RUN apt-get update
RUN apt-get install -y nodejs
# PIP requirements
RUN pip install -U pip virtualenvwrapper flower honcho redis uwsgi
# NPM requirements
RUN npm install -g bower less clean-css requirejs uglify-js jshint

#
# Users
#
ENV USER invenio
RUN useradd -d /home/invenio -m -s /bin/bash $USER
RUN echo $USER:$USER | chpasswd
RUN echo $USER 'ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/$USER
RUN chmod 0440 /etc/sudoers.d/$USER
RUN chmod 0777 /var/run/screen

ADD setup.sh /home/$USER/setup.sh
RUN chown $USER:users /home/$USER/setup.sh
RUN chmod +x /home/$USER/setup.sh

RUN mkdir -p /home/$USER/.virtualenvs
RUN chown $USER:users /home/$USER/.virtualenvs
