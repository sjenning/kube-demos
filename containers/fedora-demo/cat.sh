#!/bin/bash

trap "exit 0" SIGTERM

while true; do
	echo $(date) $(cat $1)
	sleep 1
done
