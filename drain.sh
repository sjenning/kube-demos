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

trap "echo 'cleaning up'; kubectl delete deployment demo; echo 'done'; exit 0" SIGINT

desc "Deploy an app"
run "kubectl run demo --image=master.turbot:5000/serve-hostname:latest --replicas=2"

desc "Pod are spread on different nodes"
run "kubectl get pods -o yaml | grep nodeName:"

desc "Drain node1"
run "kubectl drain node1.turbot"

desc "Pods are all on node2"
run "kubectl get pods -o yaml | grep nodeName:"

desc "Uncordon node1"
run "kubectl uncordon node1.turbot"

desc "Scale down, then back up"
run "kubectl scale deployments/demo --replicas=0"
run "kubectl scale deployments/demo --replicas=2"

desc "Pods are spread on different nodes"
run "kubectl get pods -o yaml | grep nodeName:"

desc "Delete deployment"
run "kubectl delete deployment demo"

