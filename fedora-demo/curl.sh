#!/bin/bash

while true; do
	curl --connect-timeout 1 -s $1
	if [ $? -ne 0 ]; then
		echo "failed to connect"
	fi
	sleep 0.5
done
