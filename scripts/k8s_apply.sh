#!/bin/sh

set -eu

print_info_tag="k8s_apply.sh"
target_namespace=$1
existing_namespaces=`kubectl get namespaces | tail -n +2 | awk '{print $1;}'`
existing_namespaces_arr=($existing_namespaces)
namespace_already_created=false

function print_info {
    echo "[$print_info_tag] $1"
}

# Create namespace if not exists
for ns in "${existing_namespaces_arr[@]}"; do
    if [ "$ns" == "$target_namespace" ]; then
        namespace_already_created=true
        print_info "$ns is already existing"
        break
    fi
done
if [ "$namespace_already_created" == false ]; then
    kubectl create namespace $target_namespace
    print_info "Created <$ns> namespace!!"
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
