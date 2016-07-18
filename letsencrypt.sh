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


cleanup () {
	kubectl delete deployment -l app=wordpress
	kubectl delete deployment nginx
	kubectl delete svc -l app=wordpress
	kubectl delete svc nginx 
	kubectl delete secret nginx
	kubectl delete secret mysql-pass
	kubectl delete ingress nginx
        kubectl delete job letsencrypt
	ssh fedora@kubetutor.com sudo /root/cleanup.sh
}

cleanup

clear

desc "System ready"
run ""

desc "Create a secret for mysql root password"
run "kubectl create secret generic mysql-pass --from-literal='password=youllneverguess'"

desc "Create a mysql deployment"
run "cat $(relative resources/mysql/deployment.yaml)" skip
run "kubectl create -f $(relative resources/mysql/deployment.yaml)"

desc "Create a mysql service"
run "cat $(relative resources/mysql/svc.yaml)" skip
run "kubectl create -f $(relative resources/mysql/svc.yaml)"

desc "Create a wordpress deployment"
run "cat $(relative resources/wordpress/deployment.yaml)" skip
run "kubectl create -f $(relative resources/wordpress/deployment.yaml)"

desc "Create a wordpress service"
run "cat $(relative resources/wordpress/svc.yaml)" skip
run "kubectl create -f $(relative resources/wordpress/svc.yaml)"

desc "Create a self-signed TLS secret"
run "kubectl create secret generic nginx --from-file=\"$(relative resources/nginx/tls.crt),$(relative resources/nginx/tls.key)\""

desc "Create a ingress"
run "cat $(relative resources/nginx/ingress.yaml)" skip
run "kubectl create -f $(relative resources/nginx/ingress.yaml)"

desc "Create an nginx ingress deployment"
run "cat $(relative resources/nginx/deployment.yaml)" skip
run "kubectl create -f $(relative resources/nginx/deployment.yaml)"

desc "Create an nginx ingress service"
run "cat $(relative resources/nginx/svc.yaml)" skip
run "kubectl create -f $(relative resources/nginx/svc.yaml)"

desc "Go to wordpress site"
run ""

desc "Create a letsencrypt service"
run "cat $(relative resources/letsencrypt/svc.yaml)" skip
run "kubectl create -f $(relative resources/letsencrypt/svc.yaml)"

desc "Create a letsencrypt job"
run "cat $(relative resources/letsencrypt/job.yaml)" skip
run "kubectl create -f $(relative resources/letsencrypt/job.yaml)"

desc "Refresh wordpress site"
run ""

desc "All done!"
desc "Clean up"
cleanup
