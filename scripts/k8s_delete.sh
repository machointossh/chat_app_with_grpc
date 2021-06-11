#!/bin/sh

set -eu

print_info_tag="k8s_delete.sh"
project_namespace=$1

function print_info {
    echo "[$print_info_tag] $1"
}

# K8s delete 
print_info "Starting kubectl apply"
kubectl delete -f k8s/
print_info "Finished kubectl apply"

# Change current namespace back to default
current_namespace=`kubectl config get-contexts | tail -n +2 | awk '{print $5;}'`
if [ "$project_namespace" == "$current_namespace" ]; then
    kubectl config set-context --current --namespace=default
    print_info "Changed namespace to $project_namespace to default"
fi

# Delete namespace if exists
grepped_project_namespace=`kubectl get namespaces | grep $project_namespace | awk '{print $1;}'`
if [ "$project_namespace" == "$grepped_project_namespace" ]; then
    print_info "Deleting <$project_namespace> namespace. This will take a lot of time."
    kubectl delete namespace $project_namespace
    print_info "Deleted <$project_namespace> namespace!!"
else
    print_info "Hmm... <$project_namespace> namespace already disappeared."
fi
