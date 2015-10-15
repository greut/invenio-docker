# greut/invenio:latest

## Jump in

```shell
$ docker-compose start
$ ssh -p 2222 invenio@localhost  # password: invenio
```

# Setup

```shell
$ mkvirtualenv maint-2.0
or
$ workon maint-2.0

$ cdvirtualenv

# symbolic links
$ ln -s /code/invenio .
$ ln -s /code/invenio_demosite .  # or another overlay

$ cd invenio
$ pip install -e .

$ cd ../invenio_demosite
$ pip install -e .
```

