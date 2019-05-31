# -*- coding:utf-8 -*-
#!/usr/bin/env python

import os
import sys
import re

def hatakeover():
    cmd = "vtysh -c 'show ha state'"
    outstr = os.popen(cmd).read()
    print outstr
    matchstr = re.search("^running state : (.+)*$",outstr,re.M)
    state = matchstr.group(1)
    if state == "ACT":
        cmd = "vtysh -c 'configure terminal' -c 'ha' -c 'takeover'"
        vtyret = os.popen(cmd).read()
        if (vtyret is None or vtyret.find('success')<0):
            print 'ha takeover failed'
        else:
            print 'ha takeover ok'
    else:
        print 'Current STB.'

if __name__ == "__main__":
    hatakeover()