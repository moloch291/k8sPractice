#!/bin/bash

main() {
    echo "Create the cluster:"
    minikube config set driver docker
    minikube start
    echo -n "##### STARTED #####\n"
    echo "Minikube status:"
    minikube status
    echo -n "##### END #####\n"
    echo "Get all:"
    kubectl get all
    echo -n "##### END TASK #####\n"
}

main