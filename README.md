# Invenio containers

Docker containers to play with invenio 2.0 branch.

## Building commands

    $ docker-compose build

## Running it

    $ docker-compose up -d
    $ docker-exec -it inveniodocker_web_1 /bin/bash
    # su invenio
    $ cd
    $ . .bash_profile
    $ workon venv

## Setting up invenio

And all the overlays you've got. Here: base-overlay and design-overlay.

    (venv)$ cdvirtualenv
    (venv)$ mkdir src
    (venv)$ ln -s /code/invenio src/
    (venv)$ ln -s /code/base-overlay src/
    (venv)$ ln -s /code/design-overlay src/
    (venv)$ cd src/invenio
    (venv)$ pip install -e .[development]
    (venv)$ pybabel compile -fd invenio/base/translations

    (venv)$ cd ../base-overlay
    (venv)$ pip install -e .

    (venv)$ cd ../design-overlay
    (venv)$ pip install -e .

### Configuration

    (venv)$ cdvirtualenv
    (venv)$ inveniomanage config create secret-key
    (venv)$ cd `dirname $(inveniomanage config locate)`
    (venv)$ inveniomanage config set CFG_EMAIL_BACKEND flask.ext.email.backends.console.Mail
    (venv)$ inveniomanage config set CFG_BIBSCHED_PROCESS_USER ${USER}
    (venv)$ inveniomanage config set CFG_DATABASE_NAME invenio
    (venv)$ inveniomanage config set CFG_DATABASE_USER invenio
    (venv)$ inveniomanage config set CFG_DATABASE_HOST db
    (venv)$ inveniomanage config set JINJA2_BCCACHE True
    (venv)$ inveniomanage config set CACHE_REDIS_HOST cache
    (venv)$ inveniomanage config set CELERY_RESULT_BACKEND redis://cache:6379/1
    (venv)$ inveniomanage config set CFG_SITE_URL http://0.0.0.0:${PORT}
    (venv)$ inveniomanage config set CFG_SITE_SECURE_URL http://0.0.0.0:${PORT}

#### For the lulz

    (venv)$ inveniomanage config set DEBUG True
    (venv)$ inveniomanage config set ASSETS_DEBUG True
    (venv)$ inveniomanage config set DEBUG_TB = True
    (venv)$ inveniomanage config set DEBUG_TB_INTERCEPT_REDIRECTS = False
    (venv)$ inveniomanage config set DEBUG_TB_PROFILER_ENABLED = False

### Collecting the assets (javascript, css, images, etc.)

    (venv)$ inveniomanage bower > bower.json
    (venv)$ echo '{"directory":"static/vendors"}' > .bowerrc
    (venv)$ bower install
    (venv)$ inveniomanage collect

### Building the assets

To see if everything is working fine.

    (venv)$ inveniomanage assets build

### Building the database

    (venv)$ inveniomanage database --init --yes-i-know --user=root --password=root
    (venv)$ inveniomanage database create
    (venv)$ inveniomanage runserver &
    (venv)$ INVENIO_PID=$!
    (venv)$ inveniomanage demosite populate --yes-i-know --package=tind_base.base
    (venv)$ pkill -TERM -P $INVENIO_PID

### Run it.
