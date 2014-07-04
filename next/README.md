# greut/invenio:latest

## Setting up MySQL

The first time, we need to create the MySQL folder, which lives outside the
container for persistence purposes. Without it, MySQL won’t start properly.

    $ docker run -rm -t -i \
        -v $PWD/mysql:/var/lib/mysql \
        greut/invenio:latest /root/setup-mysql.sh

## Playing around

The next command will mount 4 folders (virtual envs, mysql, invenio and the
demosite) and give you a root shell.

    $ mkdir venvs
    $ docker run --rm -t -i \
        -p 4000:4000 \
        -v $PWD/venvs:/home/invenio/.virtualenvs \
        -v $PWD/mysql:/var/lib/mysql \
        -v /path/to/invenio:/opt/invenio \
        -v /path/to/demosite:/opt/demosite \
        greut/invenio:latest \
        /sbin/my_init -- /bin/bash -l

Install the rest. By default, it’s configured to install `demosite`, adapt it
to your usage beforehand.

    $ ./setup.sh

Once everything is installed, you may run invenio.

    $ workon pu
    (pu) $ cdvirtualenv src/invenio
    (pu) $ inveniomanage runserver

## Advanced features

If you want to use screen, you’ll have to replace the `bash` command by the
[following horror](https://github.com/dotcloud/docker/issues/728#issuecomment-30077403):

    sh -c "exec >/dev/tty 2>/dev/tty </dev/tty && /usr/bin/screen -s /bin/bash"
