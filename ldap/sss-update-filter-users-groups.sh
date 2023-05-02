#!/bin/sh -e
#
#    sss-update-filter-users-groups
#


# Location of SSS configuration
CONF=/etc/sssd/sssd.conf
if [ ! -s $CONF ]; then
	exit 0
fi

# Location of logged $CONF changes
LOGDIR="/var/lib/libsss-ldap"

# Load threshold for ignoring uid's from $CONF
MIN=`grep "^min_id " $CONF | tail -n 1 | awk '{print $3}'`

# If unspecified, set to 1000 (ignore local system id's) to prevent boot hang
if [ -z $MIN ]; then
	MIN=10000
fi

# Load existing list of ignored users and groups from sssd.conf
LOADED_USERS=`grep "^filter_users " $CONF | tail -n 1 | awk '{print $3}'`
LOADED_GROUPS=`grep "^filter_groups " $CONF | tail -n 1 | awk '{print $3}'`

# Build list of users and groups to ignore based on specified minimum UID
users=`cat /etc/passwd | awk -F":" '{if ($3 <'$MIN') print $1 ","}' | xargs -i echo -n {}`
groups=`cat /etc/group | awk -F":" '{if ($3 <'$MIN') print $1 ","}' | xargs -i echo -n {}`

# Merge the two lists, remove whitespace, sort alphabetically, prune duplicates
users=`echo "$LOADED_USERS,$users" | sed "s/ //g" | sed "s/,/\n/g" | sort | uniq | xargs -i echo -n {},`
groups=`echo "$LOADED_GROUPS,$groups" | sed "s/ //g" | sed "s/,/\n/g" | sort | uniq | xargs -i echo -n {},`

# Removing any leading or trailing commas
users=`echo "$users" | sed "s/^,//" | sed "s/,$//"`
groups=`echo "$groups" | sed "s/^,//" | sed "s/,$//"`
confline_USERS="filter_users = $users"
confline_GROUPS="filter_groups = $groups"

# Build new conf file
tmpfile=`mktemp`
cat $CONF > $tmpfile
if grep "^filter_users " $CONF >/dev/null; then
	sed -i "s/^filter_users .*$/$confline_USERS/g" $CONF
fi
if grep "^filter_groups " $CONF >/dev/null; then
        sed -i "s/^filter_groups .*$/$confline_GROUPS/g" $CONF
fi

# If changes have occured, log the difference
if ! diff -up $tmpfile $CONF >/dev/null; then
	timestamp=`date +%Y%m%d%H%M%S`
	mkdir -p $LOGDIR 2>/dev/null || true
	diff -up $tmpfile $CONF > $LOGDIR/sssd.conf.$timestamp.diff || true
	logger -p syslog.info -t libsss-ldap "Modified $CONF, see changes in $LOGDIR/sssd.conf.$timestamp.diff"
fi
rm -f $tmpfile

exit 0
