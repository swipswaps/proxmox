#!/usr/bin/python

import sys
sys.path.append('/home/phil/repos/pyproxmox')
from pyproxmox import *

# Create an instance of the prox_auth class by passing in the url or ip of a server in the cluster, username and password
a = prox_auth('10.13.37.202','apiuser@pve','foobar')

# Create and instance of the pyproxmox class using the auth object as a parameter
b = pyproxmox(a)

print b.getClusterStatus()

print b.getClusterBackupSchedule()

print b.getClusterVmNextId()
