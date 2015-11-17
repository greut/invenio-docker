# Invenio on Ubuntu
#
# VERSION 0.2.0

FROM buildpack-deps:wily
MAINTAINER Yoan Blanc <yoan@dosimple.ch>

ENV DEBIAN_FRONTEND noninteractive

# Set correct environment variables.
ENV HOME /root

## Invenio's stuff

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
    python-pycurl \
    python-software-properties \
    redis-tools \
    vim \
    software-properties-common \
    subversion \
    sudo

# Locale
RUN locale-gen en_US && \
    locale-gen en_US.UTF-8 && \
    locale-gen fr_CH && \
    locale-gen fr_CH.UTF-8 && \
    locale-gen de_CH && \
    locale-gen de_CH.UTF-8 && \
    locale-gen it_CH && \
    locale-gen it_CH.UTF-8 && \
    update-locale LANG=en_US.UTF-8 LC_MESSAGES=POSIX

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# if pip is not present as a native module, then grab it from pypa.io
RUN python -m pip version && \
    python -m pip install -U pip || \
    curl --silent --show-error --retry 5 \
        https://bootstrap.pypa.io/get-pip.py | python2.7

# pyopenssl, supervisor and uwsgi are not related to invenio but specific to
# this deployment.
RUN pip install -U pyOpenSSL uwsgi virtualenvwrapper redis supervisor

RUN npm install -g \
    bower \
    less \
    node-sass \
    clean-css \
    requirejs \
    uglify-js \
    jshint

#
# Users
#
ENV USER invenio
RUN useradd -d /home/$USER -m -s /bin/bash $USER
RUN echo $USER:$USER | chpasswd
RUN echo $USER 'ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/$USER
RUN chmod 0440 /etc/sudoers.d/$USER

ADD scripts/bash_profile /home/$USER/.bash_profile
RUN chown $USER:users /home/$USER/.bash_profile
RUN chmod +x /home/$USER/.bash_profile

ADD scripts/setup.sh /home/$USER/setup.sh
RUN chown $USER:users /home/$USER/setup.sh
RUN chmod +x /home/$USER/setup.sh

# Volumes
VOLUME /code
VOLUME /home/$USER/.virtualenvs

ENV USER root
ADD scripts/supervisord.conf /etc/supervisord.conf
CMD ["/usr/local/bin/supervisord", "-c", "/etc/supervisord.conf"]
