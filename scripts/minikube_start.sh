#!/bin/sh

set -eu

minikube_host_status=`minikube status | grep host | awk '{print $2;}'`
# [output]
# minikube
# type: Control Plane
# host: Stopped
# kubelet: Stopped
# apiserver: Stopped
# kubeconfig: Stopped

# Start minikube if not running
if [ "$minikube_host_status" != "Running" ]; then
    # You'll see the kubeadm config error without "--vm=ture"
    minikube start --vm=true

    # Instead, you can run the following.
    # $ minikube start --driver=hyperkit
    # macOS:   hyperkit
    # windows: hyperv
fi

minikube addons enable ingress
