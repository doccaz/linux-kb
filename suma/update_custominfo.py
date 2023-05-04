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
	hosts = client.system.getId(key, hostname)
	system_id = hosts[0].get('id')
	field_name = sys.argv[1]
 	field_value = sys.argv[2]

	print "updating field: " + field_name
	print "value: " + field_value

	try:
		client.system.set_CustomValues(key,system_id,{field_name: field_value})
	except:
		print "Key does not exist, creating..."
		client.system.custominfo.createKey(key, field_name, field_name)
		client.system.set_CustomValues(key,system_id,{field_name: field_value})
	
		
main()

client.auth.logout(key)
