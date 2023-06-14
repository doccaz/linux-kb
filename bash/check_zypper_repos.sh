#!/bin/bash
# checks every zypper repository for errors, and disable the faulty ones

ENABLEDREPOS=$(zypper lr -P -E  | grep -v '^#\|^-' | awk '{print $1}')

for f in $ENABLEDREPOS; do
	zypper ref -f -r $f || zypper mr -d $f
done

