# Invenio test on Ubuntu
#
# VERSION 0.0.2

FROM ubuntu:14.04
MAINTAINER Yoan Blanc <yoan.blanc@cern.ch>

ENV DEBIAN_FRONTEND noninteractive
ENV MYSQL_PASS ''

#
# Packages
#
RUN apt-get update && apt-get -y upgrade
# the toolbox
RUN apt-get install -y vim ack-grep git subversion mercurial curl screen
# python-related
RUN apt-get install -y python-dev python-pip python-yaml build-essential gfortran
# libraries
RUN apt-get install -y libjpeg-dev libfreetype6-dev libmysqlclient-dev libtiff-dev libxml2-dev libxslt-dev libwebp-dev
# PPA-only packages
RUN apt-get install -y python-software-properties software-properties-common python-pycurl
RUN add-apt-repository ppa:chris-lea/node.js
RUN apt-get update
RUN apt-get install -y nodejs
# PIP requirements
RUN pip install -U pip virtualenv redis
# NPM requirements
RUN npm install -g grunt-cli bower requirejs clean-css uglifyjs less

#
# Servers
#
RUN apt-get install -y mysql-server redis-server openssh-server supervisor
# Prepare SSHD
RUN mkdir -p /var/run/sshd
RUN sed -i 's/.*session.*required.*pam_loginuid.so.*/session optional pam_loginuid.so/g' /etc/pam.d/sshd
RUN /bin/echo -e "LANG=\"en_US.UTF-8\"" > /etc/default/local
# Put supervisord config in place
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

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
# Setting up the scripts
#
ADD runtests.sh /usr/local/bin/runtests
RUN chmod +x /usr/local/bin/runtests
ADD travis_retry.sh /usr/local/bin/travis_retry
RUN chmod a+x /usr/local/bin/travis_retry
ADD travis.py /usr/local/bin/travis
RUN chmod a+x /usr/local/bin/travis

EXPOSE 22

# TODO put all the logs there
#VOLUME /home/invenio/logs
CMD ["/usr/bin/supervisord --nodaemon"]
