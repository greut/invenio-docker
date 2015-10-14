# Invenio containers

Docker containers to play with invenio 2.0 branch.

## Next

The container for developing on the next/pu branch

## Test

The container to test your next/pu branch just like it would be done on Travis.

## Building commands

    $ docker build -t greut/invenio -f next/Dockerfile .

    $ docker build -t greut/invenio:test -f test/Dockerfile .
