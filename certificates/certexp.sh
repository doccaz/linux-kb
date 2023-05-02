#!/bin/bash
CERTFILE=$1

if [ -z $1 ]; then
	echo "Usage: $0 <certificate file>"
	exit 1
fi

if [ ! -f $CERTFILE ]; then
    echo "Certificate file $CERTFILE not found."
    exit 1
fi 

# verifica se e um certificado
openssl x509 -in "$CERTFILE" -fingerprint -noout 2>&1 > /dev/null
if [ $? != 0 ]; then
	echo "The file $CERTFILE is not a valid certificate".
	exit 1
fi
	
CERT_DATE=$(openssl x509 -in "$CERTFILE"  -text | grep "Not After" | cut -d\: -f2-)
#CERT_DATE=" May  4 02:59:59 2021 GMT"
let DIFF=($(date --date="$CERT_DATE" +%s) - $(date +%s))
let DAYS=($DIFF / 86400)
if [ ${DIFF} -gt 0 ]; then
    echo "Certificate is still valid."
    echo "Expires on $(date --date="$CERT_DATE" +%D) ($DAYS to go)."
else
    echo "Expired certificate!"
    echo "Expired on $(date --date="$CERT_DATE" +%D) ($DAYS days ago)."
    exit 1
fi

