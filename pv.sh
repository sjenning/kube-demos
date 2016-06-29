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

desc "The demo persistent volume does not exist"
run "kubectl get pv demo"

desc "Create a demo persistent volume"
run "cat $(relative resources/pv.yaml)"
run "kubectl create -f $(relative resources/pv.yaml)"

desc "Thus was conjured a persistent volume!"
run "kubectl get pv demo"

desc "The demo persistent volume claim does not exist"
run "kubectl get pvc demo"

desc "Create a demo persistent volume claim"
run "cat $(relative resources/pvc.yaml)"
run "kubectl create -f $(relative resources/pvc.yaml)"

desc "Thus was conjured a persistent volume claim!"
run "kubectl get pvc demo"

desc "Start a pod that mounts the volume"
run "cat $(relative resources/pvpod.yaml)"
run "kubectl create -f $(relative resources/pvpod.yaml)"

desc "Write data to the (alleged) persistent volume"
run "kubectl exec -ti demo -- /bin/sh -c \"echo 'i hope this is persistent' > /mnt/mydata\""

desc "Check data"
run "kubectl exec -ti demo -- cat /mnt/mydata"

desc "Delete the pod"
run "kubectl delete pod demo"

desc "Pod is no more"
run "kubectl get pod demo"

desc "Start a pod that mounts the volume"
run "kubectl create -f $(relative resources/pvpod.yaml)"

desc "Check data"
run "kubectl exec -ti demo -- cat /mnt/mydata"

desc "Delete the pod"
run "kubectl delete pod demo"

desc "Delete the persistent volume claim"
run "kubectl delete pvc demo"

desc "Delete the persistent volume"
run "kubectl delete pv demo"
