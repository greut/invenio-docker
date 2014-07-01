# Invenio test on Ubuntu
#
# VERSION 0.0.3

#FROM ubuntu:12.04
FROM ubuntu:14.04
MAINTAINER Yoan Blanc <yoan.blanc@cern.ch>

ENV DEBIAN_FRONTEND noninteractive
ENV MYSQL_PASS ''

#
# Packages
#
RUN apt-get update && apt-get -y upgrade
# the toolbox
RUN apt-get install -y vim ack-grep git subversion mercurial curl screen sudo \
                       wget
# python-related
RUN apt-get install -y python-dev python-pip python-yaml build-essential \
                       gfortran python-software-properties \
                       software-properties-common python-pycurl
# libraries
RUN apt-get install -y libjpeg-dev libfreetype6-dev libmysqlclient-dev \
                       libtiff-dev libxml2-dev libxslt-dev libwebp-dev
# python libraries
RUN apt-get install -y libssl-dev zlib1g-dev libbz2-dev libreadline-dev \
                       libsqlite3-dev libgdbm-dev
# PIP requirements
RUN pip install -U pip virtualenv
# NPM requirements
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C7917B12
RUN add-apt-repository ppa:chris-lea/node.js
RUN apt-get update
RUN apt-get install -y nodejs
RUN npm install -g grunt-cli bower

#
# Servers
#
RUN apt-get install -y apache2 mysql-server redis-server mongodb
RUN /bin/echo -e "LANG=\"en_US.UTF-8\"" > /etc/default/local
# disabling journaling, see http://docs.mongodb.org/manual/core/journaling/
RUN /bin/sed -i -e s/journal=true/journal=false/ /etc/mongodb.conf

#
# Users
#
RUN echo root:root | chpasswd

ENV USER invenio
RUN useradd -d /home/$USER -m -s /bin/bash $USER
RUN echo $USER:$USER | chpasswd
RUN echo $USER 'ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/$USER
RUN chmod 0440 /etc/sudoers.d/$USER
RUN chmod 0777 /var/run/screen

#
# Python versions
#
# Python 2.6
RUN curl -kL https://raw.github.com/saghul/pythonz/master/pythonz-install | su $USER -c bash
RUN echo "[[ -s ~/.pythonz/etc/bashrc ]] && source ~/.pythonz/etc/bashrc" >> /home/$USER/.bashrc
RUN su $USER -c ". ~/.pythonz/etc/bashrc && pythonz install 2.6.9"
RUN su $USER -c ". ~/.pythonz/etc/bashrc && virtualenv -p \$(pythonz locate 2.6.9) ~/virtualenv/py2.6"
# Python 2.7
RUN su $USER -c "virtualenv ~/virtualenv/py2.7"

#
# Setting up the scripts
#
ADD runtests.sh /usr/local/bin/runtests
RUN chmod +x /usr/local/bin/runtests
ADD travis_retry.sh /usr/local/bin/travis_retry
RUN chmod a+x /usr/local/bin/travis_retry
ADD travis.py /usr/local/bin/travis
RUN chmod a+x /usr/local/bin/travis
