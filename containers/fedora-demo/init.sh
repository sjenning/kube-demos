#!/bin/bash

trap "exit 0" SIGTERM

while true; do
	echo ${VERSION} $(date) $(hostname)
	sleep 1
done
