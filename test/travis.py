#!/usr/bin/env python2
# -*- coding: utf-8 -*-

from __future__ import unicode_literals, print_function

import os
import sys
import yaml
import subprocess


def main(argv):
    action = argv[1]
    filename = ".travis.yml"
    if len(argv) > 2:
        filename = argv[2]

    with open(filename, "r") as f:
        travis = yaml.load(f)

    for cmd in travis.get(action, []):
        print("{0}> {1}".format(action, cmd), file=sys.stderr)
        vcmd = ". {0}/bin/activate && {1}".format(os.environ['HOME'], cmd)
        status = subprocess.call(vcmd, shell=True)
        if status:
            return status


if __name__ == "__main__":
    try:
        sys.exit(main(sys.argv))
    except Exception:
        import traceback
        traceback.print_exc(file=sys.stderr)
        sys.exit(1)
