#!/usr/bin/env python
#
# pidproxy.py is Copyright (c) 2006-2013 Agendaless Consulting and Contributors.
# (http://www.agendaless.com), All Rights Reserved
#
#  This software is subject to the provisions of the license at
#  http://www.repoze.org/LICENSE.txt . A copy of this license should
#  accompany this distribution. THIS SOFTWARE IS PROVIDED "AS IS" AND
#  ANY AND ALL EXPRESS OR IMPLIED WARRANTIES ARE DISCLAIMED, INCLUDING,
#  BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF TITLE,
#  MERCHANTABILITY, AGAINST INFRINGEMENT, AND FITNESS FOR A PARTICULAR
#  PURPOSE.
#
# pidproxy.py is licensed under the following license:
#
#  A copyright notice accompanies this license document that identifies
#  the copyright holders.
#
#  Redistribution and use in source and binary forms, with or without
#  modification, are permitted provided that the following conditions are
#  met:
#
#  1. Redistributions in source code must retain the accompanying
#      copyright notice, this list of conditions, and the following
#      disclaimer.
#
#  2. Redistributions in binary form must reproduce the accompanying
#      copyright notice, this list of conditions, and the following
#      disclaimer in the documentation and/or other materials provided
#      with the distribution.
#
#  3. Names of the copyright holders must not be used to endorse or
#      promote products derived from this software without prior
#      written permission from the copyright holders.
#
#  4. If any files are modified, you must cause the modified files to
#      carry prominent notices stating that you changed the files and
#      the date of any change.
#
#  Disclaimer
#
#    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS ``AS IS'' AND
#    ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
#    TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
#    PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
#    HOLDERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
#    EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
#    TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
#    DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
#    ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
#    TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
#    THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
#    SUCH DAMAGE.

""" An executable which proxies for a subprocess; upon a signal, it sends that
signal to the process identified by a pidfile. """

import os
import sys
import signal
import time

class PidProxy:
    pid = None
    def __init__(self, args):
        self.setsignals()
        try:
            self.pidfile, cmdargs = args[1], args[2:]
            self.command = os.path.abspath(cmdargs[0])
            self.cmdargs = cmdargs
        except (ValueError, IndexError):
            self.usage()
            sys.exit(1)

    def go(self):
        self.pid = os.spawnv(os.P_NOWAIT, self.command, self.cmdargs)
        while 1:
            time.sleep(5)
            try:
                pid, sts = os.waitpid(-1, os.WNOHANG)
            except OSError:
                pid, sts = None, None
            if pid:
                break

    def usage(self):
        print("pidproxy.py <pidfile name> <command> [<cmdarg1> ...]")

    def setsignals(self):
        signal.signal(signal.SIGTERM, self.passtochild)
        signal.signal(signal.SIGHUP, self.passtochild)
        signal.signal(signal.SIGINT, self.passtochild)
        signal.signal(signal.SIGUSR1, self.passtochild)
        signal.signal(signal.SIGUSR2, self.passtochild)
        signal.signal(signal.SIGQUIT, self.passtochild)
        signal.signal(signal.SIGCHLD, self.reap)

    def reap(self, sig, frame):
        # do nothing, we reap our child synchronously
        pass

    def passtochild(self, sig, frame):
        try:
            pid = int(open(self.pidfile, 'r').read().strip())
        except:
            print("Can't read child pidfile %s!" % self.pidfile)
            return
        os.kill(pid, sig)
        if sig in [signal.SIGTERM, signal.SIGINT, signal.SIGQUIT]:
            sys.exit(0)

def main():
    pp = PidProxy(sys.argv)
    pp.go()

if __name__ == '__main__':
    main()
