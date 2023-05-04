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
	field_name = sys.argv[1]

	print "Looking for group: " + field_name

	try:
		client.systemgroup.getDetails(key, field_name)
	except:
		print "Group does not exist, creating..."
		client.systemgroup.create(key, field_name, "Group automatically created by " + MANAGER_LOGIN)
		
main()

client.auth.logout(key)
