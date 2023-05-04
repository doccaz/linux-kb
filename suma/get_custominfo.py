#!/usr/bin/python
# Erico Mendonca <erico.mendonca@suse.com>
# apr/2014

import xmlrpclib
import sys
from socket import getfqdn

MANAGER_URL = "http://mysumaserver/rpc/api"
MANAGER_LOGIN = "myreadonlyuser"
MANAGER_PASSWORD = "mypassword"
client = xmlrpclib.Server(MANAGER_URL, verbose=0)

key = client.auth.login(MANAGER_LOGIN, MANAGER_PASSWORD)

def main():
	hostname = sys.argv[1]
	hosts = client.system.getId(key, hostname)
	system_id = hosts[0].get('id')
	
	customvalues=[line.rstrip('\n').split(',') for line in client.system.getCustomValues(key,system_id) ]	

	print customvalues
	
main()

client.auth.logout(key)
