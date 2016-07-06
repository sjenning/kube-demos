#!/bin/bash

sleep 3
echo "cat $1 in a loop"
kubectl logs demo -f
