. $(dirname ${BASH_SOURCE})/util.sh
desc "Wait for cat"
run ""

desc "Change the configmap"
run "kubectl patch configmap demo -p '{\"data\":{\"database-uri\":\"http://somewhereelse.com\"}}'"

desc "And it updates in the running pod"
run ""

desc "Delete the demo pod"
run "kubectl delete pod demo" skip

desc "Delete the demo configmap"
run "kubectl delete configmap demo" skip
