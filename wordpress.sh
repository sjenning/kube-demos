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

desc "Create a persistent volumes for wordpress and mysql data"
run "kubectl create -f $(relative resources/wordpress-pvs.yaml)"

desc "Create a secret for mysql root password"
run "kubectl create secret generic mysql-pass --from-literal='password=youllneverguess'"

desc "Create mysql persistent volume claims"
run "cat $(relative resources/mysql/pvc.yaml)"
run "kubectl create -f $(relative resources/mysql/pvc.yaml)"

desc "Create mysql deployment"
run "cat $(relative resources/mysql/deployment.yaml)"
run "kubectl create -f $(relative resources/mysql/deployment.yaml)"

desc "Create mysql service"
run "cat $(relative resources/mysql/svc.yaml)"
run "kubectl create -f $(relative resources/mysql/svc.yaml)"

desc "Create wordpress persistent volume claim"
run "cat $(relative resources/wordpress/pvc.yaml)"
run "kubectl create -f $(relative resources/wordpress/pvc.yaml)"

desc "Create wordpress deployment"
run "cat $(relative resources/wordpress/deployment.yaml)"
run "kubectl create -f $(relative resources/wordpress/deployment.yaml)"

desc "Create wordpress service w/ NodePort"
run "cat $(relative resources/wordpress/svc.yaml)"
run "kubectl create -f $(relative resources/wordpress/svc.yaml)"

unset DEMO_AUTO_RUN

desc "Thus was conjured a wordpress site"
xdg-open http://node1.turbot:8080 &>/dev/null
run "xdg-open http://node1.turbot:8080"

desc "Let's wreck some havok"

desc "Delete the wordpress pod"
POD=$(kubectl get pods -l tier=frontend -o name)
run "kubectl delete $POD"

desc "Pod is recreated and persistent volume is remounted"
run "kubectl get pods"

desc "Delete the mysql pod"
POD=$(kubectl get pods -l tier=mysql -o name)
run "kubectl delete $POD"

desc "Pod is recreated and persistent volume is remounted"
run "kubectl get pods"

desc "Kill all the things!"
run "kubectl delete deployment --all"

desc "Nevermind"
DEMO_AUTO_RUN=yes
run "kubectl create -f $(relative resources/mysql/deployment.yaml)"
unset DEMO_AUTO_RUN
run "kubectl create -f $(relative resources/wordpress/deployment.yaml)"

desc "Continue to cleanup the demo"
run ""

desc "Delete resources"
DEMO_AUTO_RUN=yes
run "kubectl delete svc wordpress wordpress-mysql"
run "kubectl delete deployment --all"
run "kubectl delete secret mysql-pass"
run "kubectl delete pvc --all"
unset DEMO_AUTO_RUN
desc "Wait for recyclers to finish before proceeding"
run ""
DEMO_AUTO_RUN=yes
desc "For completeness force removal of completed recyclers (if not already removed)"
run "kubectl delete pods recycler-for-pv01 recycler-for-pv02"
run "kubectl delete pv --all"

