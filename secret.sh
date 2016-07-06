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

DEMO_RUN_FAST=yes
DEMO_AUTO_RUN=yes

desc "The demo secret does not exist"
run "kubectl get secret demo"

desc "Create a secret"
run "kubectl create secret generic demo --from-literal='password=youllneverguess'"

desc "Thus was conjured a secret"
run "kubectl get secret demo"

desc "Create a demo pod that imports the secret as an environment variable"
run "cat $(relative resources/secret-env-pod.yaml)"
run "kubectl create -f $(relative resources/secret-env-pod.yaml)"

desc "The pod now has the secret in an environment variable"
run "kubectl exec -ti demo env"

desc "Delete the demo pod"
run "kubectl delete pod demo"

desc "Create a demo pod that imports the secret as a volume mount"
run "cat $(relative resources/secret-vol-pod.yaml)"
run "kubectl create -f $(relative resources/secret-vol-pod.yaml)"

desc "The pod now has the secret as a file in a volume mount"
run "kubectl exec -ti demo cat /mnt/password"

#desc "Change the secret"
#run "echo \"youllREALLYneverguess\" | tr -d '\n' | base64"
#PASSWORD=$(echo \"youllREALLYneverguess\" | tr -d '\n' | base64)
#run "kubectl patch secret demo -p '{\"data\":{\"password\": \"$PASSWORD\"}}'"

#desc "And it updates in the running pod"
#run "kubectl exec -ti demo cat /mnt/password"

desc "Delete the demo pod"
run "kubectl delete pod demo"

desc "Delete the demo secret"
run "kubectl delete secret demo"
