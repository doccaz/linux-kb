#!/bin/bash
PKCS12=$1
PASS=$2

if [ -z $1 ] || [ -z $2 ]; then
	echo "Usage: $0 <PKCS12 file> <password>"
	exit 1
fi

if [ ! -f $PKCS12 ]; then
    echo "Certificate file $PKCS12 not found."
    exit 1
fi 
	
CERT_DATE=$(openssl pkcs12 -in ${PKCS12} -clcerts -legacy -passin pass:${PASS} -passout pass:${PASS} | openssl x509 -noout -enddate | grep "notAfter=" | cut -d\= -f2-)
CERT_SUBJECT=$(openssl pkcs12 -in ${PKCS12} -clcerts -legacy -passin pass:${PASS} -passout pass:${PASS} | openssl x509 -noout -subject | grep "subject=" | cut -d\= -f2-)

echo "Certificate subject: ${CERT_SUBJECT}"

let DIFF=($(date --date="$CERT_DATE" +%s) - $(date +%s))
let DAYS=($DIFF / 86400)
if [ ${DIFF} -gt 0 ]; then
    echo "Certificate is still valid."
    echo "Expires on $(date --date="$CERT_DATE" +%D) ($DAYS days to go)."
else
    echo "Expired certificate!"
    echo "Expired on $(date --date="$CERT_DATE" +%D) ($DAYS days ago)."
    exit 1
fi




