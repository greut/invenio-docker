# Invenio container

To use with pu/next or invenio 2.0 branch.

    $ mkdir venvs
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

And install the rest. By default, it’s configured to install `demosite`, adapt
it to your usage beforehand.

    $ ./setup.sh

Once everything is installed, you may run invenio.

    $ workon pu
    (pu) $ cdvirtualenv src/invenio
    (pu) $ inveniomanage runserver

To quit, I would recommend you to stop the processes from supervisord instead
of relying on docker. MySQL can be a bit slow to stop.

    $ sudo supevisorctl stop all
    $ exit
    $ docker stop <machine name>

**NB:** Celery is already defined in supervisord, simply uncomment the lines in
`/etc/supervisor/conf.d/supervisord.conf` and restart it.

    $ sudo supervisorctl reload
    $ sudo supervisorctl status
