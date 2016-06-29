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

desc "Create a persistent volume for mysql data"
run "kubectl create -f $(relative resources/wordpress-pvs.yaml)"

desc "Create a secret for mysql root password"
run "kubectl create secret generic mysql-pass --from-literal='password=youllneverguess'"

desc "Create mysql resources"
run "cat $(relative resources/mysql.yaml) | less"
run "kubectl create -f $(relative resources/mysql.yaml)"

desc "Create wordpress resources"
run "cat $(relative resources/wordpress.yaml) | less"
run "kubectl create -f $(relative resources/wordpress.yaml)"

desc "Thus was conjured a wordpress site"
run ""

desc "Delete resources"
run "kubectl delete -f $(relative resources/wordpress.yaml)"
run "kubectl delete -f $(relative resources/mysql.yaml)"
run "kubectl delete secret mysql-pass"
run "kubectl delete pv --all"

