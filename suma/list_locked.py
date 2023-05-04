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
	systemlist=[]
	systemlist = client.system.listActiveSystems(key)
	
	for k in systemlist:
		sysdetails=[]
		sysdetails = client.system.getDetails(key, k.get('id'))
		if sysdetails['lock_status'] == 1:
			print sysdetails['hostname']
main()

client.auth.logout(key)
