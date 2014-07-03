# greut/invenio:latest

## Setting up MySQL

    $ docker run -rm -t -i \
        -v $PWD/mysql:/var/lib/mysql \
        greut/invenio:latest /root/setup-mysql.sh

## Playing around

    $ mkdir venvs
    $ docker run --rm -t -i \
        -p 4000:4000 \
        -v $PWD/venvs:/home/invenio/.virtualenvs \
        -v $PWD/mysql:/var/lib/mysql \
        -v /path/to/invenio:/opt/invenio \
        -v /path/to/demosite:/opt/demosite \
        greut/invenio:latest /sbin/my_init -- /bin/bash -l


Install the rest. By default, it’s configured to install `demosite`, adapt it
to your usage beforehand.

    $ ./setup.sh

Once everything is installed, you may run invenio.

    $ workon pu
    (pu) $ cdvirtualenv src/invenio
    (pu) $ inveniomanage runserver
