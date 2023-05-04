#!/usr/bin/python
#
#  getresults_sm.py - fetches results for remote execution commands for a batch of machines
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

def dequote(s):
	s=s.strip()
	if s.startswith( ("'", '"') ) and s.endswith( ("'",'"') ) and (s[0] == s[-1]):
		s = s[1:-1]
	return s

def usage():
	print "Usage: " + sys.argv[0] + " \
		\n\n \
		\t-h|--help\t\t\tShows this help text\n \
		\t-u|--user=<user>\t\t\tSpecified the API user\n \
		\t-p|--password=<password>\t\t\tSpecifies the API user password\n \
		\t-W\t\t\tAsks for the API user password\n \
		\t-R|--resultsfile=<job list>\t\t\tFile containing hostnames and jobs, one per line\n \
		\t-L|--url=<XMLRPC url>\t\t\tXMLRPC connection URL\n \
		\t-d|--debug\t\t\tenable debugging info\n\n"

def main(argv):

	## defaults
	#serverurl = "http://mysumaserver/rpc/api"
	serverurl = "http://192.168.56.101/rpc/api"
	user = ""
	password = ""
	debug = 0
	resultsfile = "jobs.csv"
	outputfile = "results.csv"
    	try:                                
        	opts, args = getopt.getopt(argv, "hu:p:R:L:s:ro:dW", ["help", "user=", "password=", "resultsfile=", "url=", "outputfile=", "debug"])
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
           	 	password = getpass.getpass("Password for user \"" + user + "\":")               
        	elif opt in ("-R", "--resultsfile"): 
           	 	resultsfile = arg
        	elif opt in ("-o", "--outputfile"): 
           	 	outputfile = arg
        	elif opt in ("-L", "--url"): 
           	 	serverurl = arg
        	elif opt in ("-d", "--debug"): 
           	 	debug=1

    	source = "".join(args) 

	if debug==1:
		print "user=" + user + "\nresultsfile=" + resultsfile + "\nurl=" + serverurl + "\noutputfile=" + outputfile

	if resultsfile=="" or user=="" or password=="":
		print "Inform at least one user, password and results file name."
		usage()
		sys.exit(1)

	## rotina principal
	idlist=[line.rstrip('\n').split(',') for line in open (resultsfile)]

	print "*** Total of ", len(idlist), " events to process."

	# executa os comandos
	client = xmlrpclib.Server(serverurl, verbose=debug)
	key = client.auth.login(user, password)

	foutput = open(outputfile,"w+")
	for k in idlist:
		print "Searching for results for job number: [", k[0], "], command: [", k[1], " executed on ",k[2], " hosts."
		ret = client.system.getScriptResults(key, int(k[0]))
		if len(ret) > 0:
			for x in ret:
				print "---> Return code: ", x.get('returnCode')
				strout=dequote(k[1]),x.get('serverId'),x.get('returnCode'),x.get('startDate'),x.get('stopDate'),x.get('output')
				foutput.write(str(strout).strip('() '))
				foutput.write('\n')
		else:
			print "... action not finished"
			strout=k[1],k[0],-1,"",""
			foutput.write(str(strout).strip('() '))
			foutput.write('\n')

	client.auth.logout(key)
	foutput.close()

	print "*** Finished successfully. Results written to ", outputfile
if __name__ == "__main__":
	main(sys.argv[1:])


