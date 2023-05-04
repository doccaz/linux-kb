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
	client.systemgroup.listAllGroups(key)
main()

client.auth.logout(key)
