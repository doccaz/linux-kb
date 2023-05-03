import gnomekeyring
import os

# define a new password for the GNOME Keyring from a hidden file

keyring = get_default_keyring_sync()
try:
	gnomekeyring.unlock_sync()
	f = open("/home/" + os.getenv('USER') + ".config/.null", "r")
	passwd = f.read()

	gnomekeyring.change_password_sync('login', passwd, '')
except Exception as e:
	print("erro: " + e)


