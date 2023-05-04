#!/usr/bin/python
#
#  runscript_sm.py - executes remote commands on a list of machines
#
#  Autor: Erico Mendonca (emendonca@suse.com)
#  Jan/2014
#  Versao: 1.2
#  

import xmlrpclib
import sys
import getopt
import string
import getpass
from datetime import datetime

def usage():
	print "Usage: " + sys.argv[0] + " \
		\n\n \
		\t-h|--help\t\t\tShows this help text\n \
		\t-u|--user=<usuario>\t\t\tSpecifies the API user\n \
		\t-p|--password\t\t\tSpecifies the API password\n \
		\t-W\t\t\tAsks for the API user password\n \
		\t-f|--hostfile=<host list>\t\t\tFile containing the machine hostnames, one per line\n \
		\t-L|--url=<XMLRPC url>\t\t\tConnection URL for XMLRPC\n \
		\t-o|--outputfile=<output file>\t\t\tOutput file containing job IDs. Default: jobs.csv\n \
		\t-s|--script=<bash script>\t\t\tScript to be executed on the machines\n \
		\t-r|--reboot\t\t\tExecute a reboot on the machines\n \
		\t-d|--debug\t\t\tEnable debugging info\n\n"

def main(argv):

	## defaults
	serverurl = "http://192.168.56.101/rpc/api"
	user = ""
	password = ""
	hostfile = ""
	scriptfile = ""
	reboot = 0
	debug = 0
	outputfile = "jobs.csv"
    	try:                                
        	opts, args = getopt.getopt(argv, "hu:p:f:L:o:s:rdW", ["help", "user=", "password=", "hostfile=", "url=", "outputfile=", "script=","reboot", "debug"])
    	except getopt.GetoptError:           
        	usage()                          
        	sys.exit(2)

	for opt, arg in opts:             
        	if opt in ("-h", "--help"): 
            		usage()                     
            		sys.exit()                  
        	elif opt in ("-u", "--user"): 
           	 	user = arg               
        	elif opt in ("-p", "--password"): 
           	 	password = arg               
        	elif opt in ("-W"): 
           	 	password = getpass.getpass("User password for \"" + user + "\":")               
        	elif opt in ("-f", "--hostfile"): 
           	 	hostfile = arg
        	elif opt in ("-L", "--url"): 
           	 	serverurl = arg
        	elif opt in ("-s", "--script"): 
           	 	scriptfile = arg
        	elif opt in ("-o", "--outputfile"): 
           	 	outputfile = arg
        	elif opt in ("-r", "--reboot"): 
           	 	reboot=1
        	elif opt in ("-d", "--debug"): 
           	 	debug=1

    	source = "".join(args) 

	if debug==1:
		print "user=" + user + "\nhostfile=" + hostfile + "\nurl=" + serverurl + "\nscript=" + scriptfile

	if hostfile=="" or user=="" or password=="":
		print "Inform at least the user, password, script name and an action."
		usage()
		sys.exit(1)

	## main routine

	hosts=[]
	f = open(hostfile)
	for line in f.readlines():
		if line.rstrip('\n') != "": 
			hosts.append(line.rstrip('\n')) 
	f.close()

	# executa os comandos
	print "---> Using server: " + serverurl

	client = xmlrpclib.Server(serverurl, verbose=debug)
	key = client.auth.login(user, password)

	# busca de IDs
	idlist=[]
	runhosts=[]
	foutput = open(outputfile, "w+")
	for k in hosts:
		print "Searching for ID: [", k, "]"
		ret = client.system.searchByName(key, k)
		if len(ret) > 0:
			print "---> ID found: ", ret[0].get('id')
			idlist.append(ret[0].get('id'))
			runhosts.append(k)
		else:
			print "---> could not find ID for the host ",k
			
	
	print "*** Total of ",len(idlist), " IDs found from a total of ", len(hosts), "."
	
	if len(idlist) < len(hosts):	
		r=raw_input("Some IDs were not found. Continue (Y/N)?")
		if r == 'Y' or r == 'y':
			print("Continuing...")
		else:
			print ("*** operation aborted.")
			client.auth.logout(key)
			foutput.close()
			sys.exit(1)
	# executa reboot
	if reboot == 1:
		for x in idlist:
			print "Doing reboot on ID ", x
			today = datetime.today()
			earliest_occurrence = xmlrpclib.DateTime(today)
			client.system.scheduleReboot(key, x, earliest_occurrence)

	# executa comando
	if scriptfile != "":
		print "*** Executing script ", scriptfile, " on IDs ", idlist
		today = datetime.today()
		earliest_occurrence = xmlrpclib.DateTime(today)
		f = open(scriptfile)
		scripttext=f.read()
		f.close()
		try:
			jobid=client.system.scheduleScriptRun(key, idlist, 'root', 'root', 600, scripttext, earliest_occurrence)
		except:
			print "---> ERROR scheduling script execution for hosts"
		
		if jobid > 0:
			print "---> Job ID: ", jobid
			strout=jobid,scriptfile,len(idlist),runhosts
			foutput.write(str(strout).strip('() '))
			foutput.write('\n')
			print "*** Completed successfully. Job list is available in ", outputfile
			print "*** Use the script getresults_sm.py to check on the job execution status and to obtain the command outputs."

	client.auth.logout(key)
	foutput.close()


if __name__ == "__main__":
	main(sys.argv[1:])


