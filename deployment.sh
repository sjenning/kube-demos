#!/bin/bash
# Copyright 2016 The Kubernetes Authors All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

. $(dirname ${BASH_SOURCE})/util.sh

desc "Create a demo deployment"
run "cat $(relative resources/deployment.yaml)" skip
run "kubectl create -f $(relative resources/deployment.yaml)"

desc "Thus was conjured a deployment!"
run "kubectl get deployment demo"

desc "And the replicaset it created"
run "kubectl get replicasets"

desc "And the pods it created"
run "kubectl get pods"

desc "Pods are v1"
PODS=$(kubectl get pods --no-headers | cut -f1 -d' ')
for POD in $PODS; do
	run "kubectl logs --tail=3 $POD" skip
done
run ""

desc "Lets change the pod environment variable to v2"
desc "can also be done with 'kubectl edit' or 'kubectl apply -f'"
run "kubectl patch deployment demo -p '{\"spec\":{\"template\":{\"spec\":{\"containers\":[{\"name\": \"fedora\", \"env\":[{\"name\": \"VERSION\", \"value\": \"v2\"}]}]}}}}'"

desc "A new replicaset is created"
run "kubectl get replicasets"

desc "Pods are v2"
PODS=$(kubectl get pods --no-headers | cut -f1 -d' ')
for POD in $PODS; do
	run "kubectl logs --tail=3 $POD" skip
done
run ""

desc "Oh no v2 is horrible!"
run ""
run "kubectl rollout undo deployment/demo"

desc "Whew, pods are v1 again"
PODS=$(kubectl get pods --no-headers | cut -f1 -d' ')
for POD in $PODS; do
	run "kubectl logs --tail=3 $POD" skip
done
run ""

desc "Delete the deployment"
run "kubectl delete deployment demo" skip
