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

desc "The demo pod does not exist"
run "kubectl get pod demo"

desc "Create a busybox demo pod"
run "cat $(relative resources/pod.yaml)"
run "kubectl create -f $(relative resources/pod.yaml)"

desc "Thus was conjured a pod!"
run "kubectl get pod demo"

desc "And it is running"
run "kubectl logs demo"

desc "Delete the pod"
run "kubectl delete pod demo"

desc "Conjured pod is no more"
run "kubectl get pod demo"

