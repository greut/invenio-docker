# Invenio on Ubuntu
#
# VERSION 0.1.0

FROM jedisct1/phusion-baseimage-latest:latest
MAINTAINER Yoan Blanc <yoan@dosimple.ch>

ENV DEBIAN_FRONTEND noninteractive

# Set correct environment variables.
ENV HOME /root

# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# Enabling SSHD
RUN rm -rf /etc/service/sshd/down

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

## Invenio's stuff

EXPOSE 22
EXPOSE 8080

RUN curl -sL https://deb.nodesource.com/setup_4.x | bash -

RUN apt-get -q -y upgrade
RUN apt-get -q -y install \
    ack-grep \
    build-essential \
    curl \
    cython \
    gfortran \
    git \
    libjpeg-dev \
    libffi-dev \
    libfreetype6-dev \
    libmagickwand-dev \
    libmysqlclient-dev \
    libssl-dev \
    libtiff-dev \
    libxml2-dev \
    libxslt-dev \
    libwebp-dev \
    mercurial \
    mariadb-client \
    nodejs \
    python \
    python-dev \
    python-pip \
    python-pycurl \
    python-software-properties \
    redis-tools \
    vim \
    software-properties-common \
    subversion \
    sudo \
    screen

RUN pip install -U \
    pip \
    virtualenvwrapper \
    flower \
    honcho \
    redis \
    uwsgi

RUN npm install -g \
    bower \
    less \
    clean-css \
    requirejs \
    uglify-js \
    jshint

# Locale
RUN locale-gen fr_CH && \
    locale-gen fr_CH.UTF-8 && \
    locale-gen de_CH && \
    locale-gen de_CH.UTF-8 && \
    locale-gen it_CH && \
    locale-gen it_CH.UTF-8 && \
    update-locale LANG=fr_CH.UTF-8 LC_MESSAGES=POSIX

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# pidproxy
ADD scripts/pidproxy.py /usr/local/bin/pidproxy
RUN chmod +x /usr/local/bin/pidproxy

#
# Users
#
ENV USER invenio
RUN useradd -d /home/$USER -m -s /bin/bash $USER
RUN echo $USER:$USER | chpasswd
RUN echo $USER 'ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/$USER
RUN chmod 0440 /etc/sudoers.d/$USER
RUN chmod 0777 /var/run/screen

ADD scripts/bash_profile /home/$USER/.bash_profile
RUN chown $USER:users /home/$USER/.bash_profile
RUN chmod +x /home/$USER/.bash_profile

ADD scripts/setup.sh /home/$USER/setup.sh
RUN chown $USER:users /home/$USER/setup.sh
RUN chmod +x /home/$USER/setup.sh

RUN mkdir -p /home/$USER/.virtualenvs
RUN chown $USER:users /home/$USER/.virtualenvs

# Volumes
VOLUME /code
VOLUME /home/$USER/.virtualenvs
