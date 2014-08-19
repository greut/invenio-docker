#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import unicode_literals, print_function

import os
import sys
import yaml
import subprocess

# Mapping the service name with the daemon name
SERVICES = {
    "redis": "redis-server"
}

def main(argv):
    action = argv[1]
    filename = ".travis.yml"
    if len(argv) > 2:
        filename = argv[2]

    with open(filename, "r") as f:
        travis = yaml.load(f)

    if action == "services":
        for service in travis.get(action, []):
            cmd = "sudo service {0} start".format(SERVICES.get(service,
                                                               service))
            print("{0}> {1}".format(action, cmd))
            status = subprocess.call(cmd, shell=True)
            if status:
                print("{0}> {1} failed".format(action, service))
    else:
        status = 0
        for cmd in travis.get(action, []):
            print("{0}> {1}".format(action, cmd), file=sys.stderr)
            status |= subprocess.call(cmd, shell=True)
        return status

if __name__ == "__main__":
    try:
        sys.exit(main(sys.argv))
    except Exception:
        import traceback
        traceback.print_exc(file=sys.stderr)
        sys.exit(1)
