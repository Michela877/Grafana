#!/bin/bash
set -e

NAMESPACE="monitoring"

echo "Scegli un'opzione:"
echo "1) Installare tutti i manifest"
echo "2) Cancellare tutto ciò che è stato applicato"
read -p "Opzione (1/2): " OPTION

if [ "$OPTION" == "1" ]; then
    echo "Creazione namespace..."
    kubectl create namespace $NAMESPACE || echo "Namespace $NAMESPACE già esistente"

    echo "Deploy Prometheus..."
    kubectl apply -f prometheus/configmap.yaml -n $NAMESPACE
    kubectl apply -f prometheus/deployment.yaml -n $NAMESPACE
    kubectl apply -f prometheus/service.yaml -n $NAMESPACE

    echo "Deploy Loki..."
    kubectl apply -f loki/configmap.yaml -n $NAMESPACE
    kubectl apply -f loki/deployment.yaml -n $NAMESPACE
    kubectl apply -f loki/service.yaml -n $NAMESPACE

    echo "Deploy Tempo..."
    kubectl apply -f tempo/configmap.yaml -n $NAMESPACE
    kubectl apply -f tempo/deployment.yaml -n $NAMESPACE
    kubectl apply -f tempo/service.yaml -n $NAMESPACE

    echo "Deploy Grafana..."
    kubectl apply -f grafana/configmap.yaml -n $NAMESPACE
    kubectl apply -f grafana/deployment.yaml -n $NAMESPACE
    kubectl apply -f grafana/service.yaml -n $NAMESPACE
    kubectl apply -f grafana/ingress.yaml -n $NAMESPACE

    echo "Tutti i manifest sono stati applicati!"
    kubectl get all -n $NAMESPACE

elif [ "$OPTION" == "2" ]; then
    echo "Cancellazione di tutti i manifest..."
    kubectl delete -f grafana/ingress.yaml -n $NAMESPACE || true
    kubectl delete -f grafana/service.yaml -n $NAMESPACE || true
    kubectl delete -f grafana/deployment.yaml -n $NAMESPACE || true
    kubectl delete -f grafana/configmap.yaml -n $NAMESPACE || true

    kubectl delete -f tempo/service.yaml -n $NAMESPACE || true
    kubectl delete -f tempo/deployment.yaml -n $NAMESPACE || true
    kubectl delete -f tempo/configmap.yaml -n $NAMESPACE || true

    kubectl delete -f loki/service.yaml -n $NAMESPACE || true
    kubectl delete -f loki/deployment.yaml -n $NAMESPACE || true
    kubectl delete -f loki/configmap.yaml -n $NAMESPACE || true

    kubectl delete -f prometheus/service.yaml -n $NAMESPACE || true
    kubectl delete -f prometheus/deployment.yaml -n $NAMESPACE || true
    kubectl delete -f prometheus/configmap.yaml -n $NAMESPACE || true

    echo "Namespace $NAMESPACE rimosso (opzionale)"
    kubectl delete namespace $NAMESPACE || true

else
    echo "Opzione non valida, esci."
    exit 1
fi
