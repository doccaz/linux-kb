#!/usr/bin/python3
# generates a crypt() hash password. Useful for creating password files for Apache/NGINX.
#
import crypt, getpass
print(crypt.crypt(getpass.getpass()))

