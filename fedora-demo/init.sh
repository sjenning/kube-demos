#!/bin/bash

trap "exit 0" SIGTERM

while true; do
	echo ${VERSION} $(hostname) $(date)
	sleep 1
done
