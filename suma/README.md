#  SUSE Manager scripts

These are automation scripts I wrote for SUSE Manager/spacewalk a long time ago.

These are used to create/get groups and activation keys "en masse" on a SUMA server using XMLRPC.

There's also a script to run scripts (or even reboot) in multiple machines in parallel by submitting execution jobs to SUMA via XMLRPC. Just supply a script and a host list. The submitted jobs are written to a CSV file.

Later, another script can be used to grab the status *and the command execution results* for all jobs into a handy CSV file.

