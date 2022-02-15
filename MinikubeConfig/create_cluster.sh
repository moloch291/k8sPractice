#!/bin/bash

create_cluster() {
    minikube config set driver docker
    minikube start
    echo "Minikube status:"
    minikube status
    echo -n "##### END #####\n"
    echo "Get all:"
    kubectl get all
    echo -n "##### END #####\n"
}

install_docker() {
    sudo apt update
    sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs)  stable"
    sudo apt update
    sudo apt-get install docker-ce
    docker --version
    sudo systemctl start docker
    sudo systemctl enable docker
}

is_docker_installed() {
    docker --version
    EXIT_CODE=$(echo $?)
    if [ $EXIT_CODE != 0 ]; then
        install_docker
    else
        echo "kubectl is already installed!"
    fi
}

install_kubectl() {
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    chmod +x kubectl
    mkdir -p ~/.local/bin/kubectl
    mv ./kubectl ~/.local/bin/kubectl
    kubectl version --client
}

is_kubectl_installed() {
    kubectl version --client
    EXIT_CODE=$(echo $?)
    if [ $EXIT_CODE != 0 ]; then
        install_kubectl
    else
        echo "kubectl is already installed!"
    fi
}

install_minikube() {
    sudo apt update -y
    sudo apt install -y curl wget apt-transport-https
    wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo cp minikube-linux-amd64 /usr/local/bin/minikube
    sudo chmod +x /usr/local/bin/minikube
    minikube version
}

is_minikube_installed() {
    minikube version
    EXIT_CODE=$(echo $?)
    if [ $EXIT_CODE != 0 ]; then
        install_minikube
    else
        echo "Minikube is already installed!"
    fi
}

main() {
    is_minikube_installed
    echo -n "##### END TASK #####\n"
    is_kubectl_installed
    echo -n "##### END TASK #####\n"
    is_docker_installed
    echo -n "##### END TASK #####\n"
    create_cluster
    echo -n "##### END TASK #####\n"
}

main