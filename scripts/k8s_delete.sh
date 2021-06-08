#!/bin/sh

set -eu

print_info_tag="k8s_delete.sh"
project_namespace=$1
existing_namespaces=`kubectl get namespaces | tail -n +2 | awk '{print $1;}'`
existing_namespaces_arr=($existing_namespaces)
namespace_already_exists=false

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
for ns in "${existing_namespaces_arr[@]}"; do
    if [ "$ns" == "$project_namespace" ]; then
        namespace_already_exists=true
        print_info "$ns is already existing"
        break
    fi
done
if [ "$namespace_already_exists" == true ]; then
    print_info "Deleting namespace. This will take a lot of time."
    kubectl delete namespace $project_namespace
    print_info "Deleted <$ns> namespace!!"
fi
