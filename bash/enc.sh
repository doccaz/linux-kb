#!/bin/bash
# Erico Mendonca <erico.mendonca@suse.com>
#
# creates a "pastable" base64 script from any file
# just run the script and you get the original file back.
#
# Mar 2020
SCRIPT=$1

if [ -z $1 ]; then
	echo "Usage: $0 <script name to convert>"
	exit 1
fi

if [ ! -f $1 ]; then
	echo "File $1 does not exist."
	exit 1
fi

STRING=$(bzip2 -v9c $1 | base64)

echo "------------[ cut here ]------------"
echo "base64 -d <<< '
${STRING}
' | bzip2 -dc > $1"
[[ "$1" =~ [a-z0-0]+(\.sh|\.py|\.bin) ]] && echo "chmod +x $1"
echo
echo "------------[ cut here ]------------"


