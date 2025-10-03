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
    kubectl apply -f Prometheus/configMap.yml -n $NAMESPACE
    kubectl apply -f Prometheus/deployment.yml -n $NAMESPACE
    kubectl apply -f Prometheus/services.yml -n $NAMESPACE

    echo "Deploy Loki..."
    kubectl apply -f Loki/configMap.yml -n $NAMESPACE
    kubectl apply -f Loki/deployment.yml -n $NAMESPACE
    kubectl apply -f Loki/services.yml -n $NAMESPACE

    echo "Deploy Tempo..."
    kubectl apply -f Tempo/configMap.yml -n $NAMESPACE
    kubectl apply -f Tempo/deployment.yml -n $NAMESPACE
    kubectl apply -f Tempo/services.yml -n $NAMESPACE

    echo "Deploy Grafana..."
    kubectl apply -f Grafana/configMap.yml -n $NAMESPACE
    kubectl apply -f Grafana/deployment.yml -n $NAMESPACE
    kubectl apply -f Grafana/services.yml -n $NAMESPACE
    kubectl apply -f Grafana/ingress.yml -n $NAMESPACE

    echo "Tutti i manifest sono stati applicati!"
    kubectl get all -n $NAMESPACE

elif [ "$OPTION" == "2" ]; then
    echo "Cancellazione di tutti i manifest..."
    kubectl delete -f Grafana/ingress.yml -n $NAMESPACE || true
    kubectl delete -f Grafana/services.yml -n $NAMESPACE || true
    kubectl delete -f Grafana/deployment.yml -n $NAMESPACE || true
    kubectl delete -f Grafana/configMap.yml -n $NAMESPACE || true

    kubectl delete -f Tempo/services.yml -n $NAMESPACE || true
    kubectl delete -f Tempo/deployment.yml -n $NAMESPACE || true
    kubectl delete -f Tempo/configMap.yml -n $NAMESPACE || true

    kubectl delete -f Loki/services.yml -n $NAMESPACE || true
    kubectl delete -f Loki/deployment.yml -n $NAMESPACE || true
    kubectl delete -f Loki/configMap.yml -n $NAMESPACE || true

    kubectl delete -f Prometheus/services.yml -n $NAMESPACE || true
    kubectl delete -f Prometheus/deployment.yml -n $NAMESPACE || true
    kubectl delete -f Prometheus/configMap.yml -n $NAMESPACE || true

    echo "Namespace $NAMESPACE rimosso (opzionale)"
    kubectl delete namespace $NAMESPACE || true

else
    echo "Opzione non valida, esci."
    exit 1
fi
