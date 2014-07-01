# Invenio containers

Docker containers to play with invenio next/pu branches.

## Next

The container for developing on the next/pu branch

## Test

The container to test your next/pu branch just like it would be done on Travis.

## Building commands

    $ cd next
    $ docker build -t greut/invenio .

    $ cd test
    $ docker build -t greut/invenio:test .
