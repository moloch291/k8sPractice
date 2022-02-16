#!/bin/bash

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
    echo -n "##### END TASK #####\n"
}

main