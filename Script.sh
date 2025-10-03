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
    kubectl apply -f Prometheus/configMap.yaml -n $NAMESPACE
    kubectl apply -f Prometheus/deployment.yaml -n $NAMESPACE
    kubectl apply -f Prometheus/service.yaml -n $NAMESPACE

    echo "Deploy Loki..."
    kubectl apply -f Loki/configMap.yaml -n $NAMESPACE
    kubectl apply -f Loki/deployment.yaml -n $NAMESPACE
    kubectl apply -f Loki/service.yaml -n $NAMESPACE

    echo "Deploy Tempo..."
    kubectl apply -f Tempo/configMap.yaml -n $NAMESPACE
    kubectl apply -f Tempo/deployment.yaml -n $NAMESPACE
    kubectl apply -f Tempo/service.yaml -n $NAMESPACE

    echo "Deploy Grafana..."
    kubectl apply -f Grafana/configMap.yaml -n $NAMESPACE
    kubectl apply -f Grafana/deployment.yaml -n $NAMESPACE
    kubectl apply -f Grafana/service.yaml -n $NAMESPACE
    kubectl apply -f Grafana/ingress.yaml -n $NAMESPACE

    echo "Tutti i manifest sono stati applicati!"
    kubectl get all -n $NAMESPACE

elif [ "$OPTION" == "2" ]; then
    echo "Cancellazione di tutti i manifest..."
    kubectl delete -f Grafana/ingress.yaml -n $NAMESPACE || true
    kubectl delete -f Grafana/service.yaml -n $NAMESPACE || true
    kubectl delete -f Grafana/deployment.yaml -n $NAMESPACE || true
    kubectl delete -f Grafana/configMap.yaml -n $NAMESPACE || true

    kubectl delete -f Tempo/service.yaml -n $NAMESPACE || true
    kubectl delete -f Tempo/deployment.yaml -n $NAMESPACE || true
    kubectl delete -f Tempo/configMap.yaml -n $NAMESPACE || true

    kubectl delete -f Loki/service.yaml -n $NAMESPACE || true
    kubectl delete -f Loki/deployment.yaml -n $NAMESPACE || true
    kubectl delete -f Loki/configMap.yaml -n $NAMESPACE || true

    kubectl delete -f Prometheus/service.yaml -n $NAMESPACE || true
    kubectl delete -f Prometheus/deployment.yaml -n $NAMESPACE || true
    kubectl delete -f Prometheus/configMap.yaml -n $NAMESPACE || true

    echo "Namespace $NAMESPACE rimosso (opzionale)"
    kubectl delete namespace $NAMESPACE || true

else
    echo "Opzione non valida, esci."
    exit 1
fi
