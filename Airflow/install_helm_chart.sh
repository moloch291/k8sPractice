#!/bin/bash

prepare_airflow() {
    echo "Creating values.yaml..."
    helm show values apache-airflow/airflow > values.yaml
    EXIT_CODE=$(echo $?)
    if [ $EXIT_CODE != 0 ]; then
        echo "An error occured, pls try manually!"
    else
        echo "Airflow's values.yaml is ready!"
        echo -n "##### END #####\n"
    fi
    echo "Port forwarding (localhost:8080):"
    kubectl port-forward svc/airflow-webserver 8080:8080 -n airflow
}

install_chart() {
    helm upgrade --install airflow apache-airflow/airflow --namespace airflow --create-namespace
    EXIT_CODE=$(echo $?)
    if [ $EXIT_CODE != 0 ]; then
        echo "Installation failed..."
    else
        echo "Chart installed:"
        kubectl get pods --namespace airflow
    fi

}

add_helm_repo() {
    helm repo add apache-airflow https://airflow.apache.org
    EXIT_CODE=$(echo $?)
    if [ $EXIT_CODE != 0 ]; then
        echo "Addition of Airflow repository failed or it already exists..."
    else
        echo "Repo added:"
        helm repo ls
    fi
}

main() {
    echo "Adding the Helm repo:"
    add_helm_repo
    echo -n "##### END #####\n"
    echo "Installing chart:"
    install_chart
    echo -n "##### END #####\n"
    prepare_airflow
}

main