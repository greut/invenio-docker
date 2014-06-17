# Invenio container

To use with pu/next or invenio 2.0 branch.

    $ mkdir -p venvs
    $ mkdir -p mysql
    $ docker run -v $PWD/mysql:/var/lib/mysql \
                 greut/invenio:latest \
                 /bin/bash -c "/root/setup-mysql.sh"

    $ docker run -d -p 2222:22 \
                 -p 4000:4000 \
                 -v $PWD/venvs:/home/invenio/.virtualenvs \
                 -v $PWD/mysql:/var/lib/mysql \
                 -v /path/to/invenio:/opt/invenio \
                 -v /path/to/demosite:/opt/demosite \
                 greut/invenio:latest

Then jump in:

    $ ssh -p 2222 invenio@localhost

And install the rest.

    $ ./setup.sh

Once everything is installed, you may run invenio.

    $ workon pu
    (pu) $ cdvirtualenv src/invenio
    (pu) $ inveniomanage runserver
