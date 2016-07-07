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

desc "Create a configmap"
run "kubectl create configmap demo --from-literal='database-uri=http://somewhere.com'"

desc "Thus was conjured a config map"
run "kubectl get configmap demo"

desc "Create a demo pod that imports the config map as a volume mount"
run "cat $(relative resources/configmap-vol-pod.yaml)" skip
run "kubectl create -f $(relative resources/configmap-vol-pod.yaml)"

tmux new -d -s my-session \
    "$(dirname ${BASH_SOURCE})/configmap-tmux.sh" \; \
    split-window -v -d "$(dirname $BASH_SOURCE)/configmap-cat.sh /mnt/database-uri" \; \
    attach \;
