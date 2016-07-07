#!/bin/bash

trap "kubectl delete pod demo; exit 0" SIGINT

echo "Create demo pod"
kubectl create -f resources/pod.yaml
sleep 5

echo "Resolving $1"
kubectl exec -ti demo nslookup $1

echo "curl http://$1"
kubectl exec -ti demo /curl.sh http://$1 2>/dev/null

echo "Delete demo pod"
kubectl delete pod demo
