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

hostname = getfqdn()

def main():
	akeys = client.activationkey.listActivationKeys(key)

	search=sys.argv[1]

	for k in akeys:
		if k['key'] == search:
			print "key found: " + search
			return 0
	print "key NOT found: " + search
	return 1
main()

client.auth.logout(key)
