#!/bin/bash

# Script for running utility

# Setup the paths
this_path=$(abspath "$0")       ## Path of this file including filenamel
myname=$(basename "${this_path}")     ## file name of this script.

export PATH=/bin:/sbin:/usr/bin:/usr/local/bin:/usr/sbin/

# Check for required program(s)
req_progs='awk docker grep netstat stat'
for p in $req_progs; do
  command -v "$p" >/dev/null 2>&1 || { printf "%s command not found.\n" "$p"; exit 1; }
done

# Ensure we can connect to docker daemon
docker ps -q >/dev/null 2>&1
if [ $? -ne 0 ]; then
  printf "Error connecting to docker daemon (does docker ps work?)\n"
  exit 1
fi

# Warn if not root
ID=$(id -u)
if [ "x$ID" != "x0" ]; then
    warn "Some tests might require root to run"
    sleep 3
fi

# Load all the tests from tests/ and run them
main () {

  for test in tests/*.sh
  do
     . ./"$test"
  done
}

main "$@"
