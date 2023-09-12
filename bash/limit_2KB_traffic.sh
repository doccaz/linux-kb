#!/bin/bash

tc qdisc del root dev eth0
tc qdisc add dev eth0 root tbf rate 24kbit latency 50ms burst 16kbit
tc qdisc show root

