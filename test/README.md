# greut/invenio:test

A machine to execute the `.travis.yml` file from a github repository. NB that
many invenio prerequisites are already presents here (to speed things up a
bit).

    # Python 2.6
    $ docker run --rm greut/invenio:test /bin/bash -c \
                    "runtests py2.6 git://github.com/inveniosoftware/invenio.git#pu"

    # Python 2.7
    $ docker run --rm greut/invenio:test /bin/bash -c \
                    "runtests py2.7 git://github.com/inveniosoftware/invenio.git#pu"

Et voilà.
