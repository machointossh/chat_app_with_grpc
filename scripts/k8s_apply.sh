#!/bin/sh

set -eu

print_info_tag="k8s_apply.sh"
target_namespace=$1

function print_info {
    echo "[$print_info_tag] $1"
}

# Create namespace if not exists
grepeed_target_namespace=`kubectl get namespaces | grep $target_namespace | awk '{print $1;}'`
if [ "$target_namespace" == "$grepeed_target_namespace" ]; then
    print_info "<$target_namespace> namespace already exists."
else
    kubectl create namespace $target_namespace
    print_info "Created <$target_namespace> namespace!!"
fi

# K8s apply
print_info "Starting kubectl apply"
kubectl apply -f k8s/
print_info "Finished kubectl apply"

# Change current namespace 
current_namespace=`kubectl config get-contexts | tail -n +2 | awk '{print $5;}'`
if [ "$target_namespace" != "$current_namespace" ]; then
    kubectl config set-context --current --namespace=$target_namespace
    print_info "Changed namespace to $current_namespace to $target_namespace"
fi
