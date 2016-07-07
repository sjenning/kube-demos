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

desc "Deploy an app the just serves the hostname"
run "kubectl run demo --image=master.turbot:5000/serve-hostname:latest --replicas=2"

desc "Create a service for the app"
run "cat $(relative resources/svc.yaml)" skip
run "kubectl create -f $(relative resources/svc.yaml)"

desc "Thus was conjured a service!"
run "kubectl get service demo"

desc "Get detailed information about the service"
run "kubectl describe service demo"

tmux new -d -s my-session \
    "$(dirname ${BASH_SOURCE})/service-tmux.sh" \; \
    split-window -v -d "$(dirname $BASH_SOURCE)/service-curl.sh demo.default.svc.kube.turbot" \; \
    attach \;
