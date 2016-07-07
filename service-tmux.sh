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

desc "Wait for curl to start"
run ""

desc "We can scale up"
run "kubectl scale deployment/demo --replicas=4"

desc "We can scale down"
run "kubectl scale deployment/demo --replicas=1"

desc "We can scale way down"
run "kubectl scale deployment/demo --replicas=0"

desc "And back up"
run "kubectl scale deployment/demo --replicas=2"

desc "Delete the service"
run "kubectl delete svc demo" skip

desc "Delete the deployment"
run "kubectl delete deployment demo" skip

