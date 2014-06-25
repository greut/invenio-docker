# Invenio on Ubuntu
#
# VERSION 0.0.1

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
RUN apt-get install -y python python-dev python-pip virtualenvwrapper build-essential gfortran
# libraries
RUN apt-get install -y libjpeg-dev libfreetype6-dev libmysqlclient-dev libtiff-dev libxml2-dev libxslt-dev libwebp-dev
# PPA-only packages
RUN apt-get install -y python-software-properties software-properties-common python-pycurl
RUN add-apt-repository ppa:chris-lea/node.js
RUN add-apt-repository ppa:jon-severinsson/ffmpeg
RUN apt-get update
RUN apt-get install -y nodejs ffmpeg
# PIP requirements
RUN pip install -U pip virtualenvwrapper flower honcho redis
# NPM requirements
RUN npm install -g grunt-cli bower

#
# Servers
#
RUN apt-get install -y mysql-server redis-server openssh-server supervisor
# Remove initial database
RUN rm -rf /var/lib/mysql/*
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

#
# Once you're in, simply do $ ~/setup.sh
#
ADD setup-mysql.sh /root/setup-mysql.sh
RUN chmod +x /root/setup-mysql.sh
ADD setup.sh /home/$USER/setup.sh
RUN chown $USER:users /home/$USER/setup.sh
RUN chmod +x /home/$USER/setup.sh
RUN mkdir -p /home/$USER/.virtualenvs
RUN chown $USER:users /home/$USER/.virtualenvs

EXPOSE 22
EXPOSE 4000

VOLUME /var/lib/mysql
VOLUME /home/$USER/.virtualenvs
CMD ["/usr/bin/supervisord"]
