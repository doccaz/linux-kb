#!/bin/bash

ldbsearch -a -H tdb:///var/lib/sss/db/cache_LDAP.ldb -b cn=sudorules,cn=custom,cn=LDAP,cn=sysdb


# to erase only the sudoers cache: sss_cache -R
# to erase the complete cache: sss_cache -E

