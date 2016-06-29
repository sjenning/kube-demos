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

desc "The demo replicaset does not exist"
run "kubectl get replicaset demo"

desc "Create a demo replicaset"
run "cat $(relative resources/replicaset.yaml)"
run "kubectl create -f $(relative resources/replicaset.yaml)"

desc "Thus was conjured a replicaset!"
run "kubectl get replicaset demo"

desc "And the pods it started"
run "kubectl get pods"

desc "We can scale up"
run "kubectl scale --replicas=4 replicaset/demo"

desc "And scale back down"
run "kubectl scale --replicas=2 replicaset/demo"

desc "We can delete a pod"
POD=$(kubectl get pods --no-headers | cut -f1 -d' ' | head -n 1)
run "kubectl delete pod $POD"

desc "And the replicaset replaces it"
run "kubectl get pods"

desc "Delete the replicaset"
run "kubectl delete replicaset demo"

desc "Conjured replicaset is no more"
run "kubectl get replicaset demo"

desc "Associate pods are also deleted"
run "kubectl get pods"

