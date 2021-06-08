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

    # minikube start --driver=hyperkit
    # If "$OSTYPE"* is darwin,
    # minikube will automatically select hyperkit as a driver.
fi

minikube addons enable ingress
