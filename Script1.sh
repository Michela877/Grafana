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

    echo "deploy monitoring state metrics"
    kubectl apply -f Metrics/kube-state-metrics.yaml -n $NAMESPACE
    kubectl apply -f Metrics/node-exporter.yml -n $NAMESPACE

    echo "deploy promtail"
    kubectl apply -f Promtail/promtail.yml -n $NAMESPACE

    echo "Deploy Prometheus..."
    kubectl apply -f Prometheus/serviceaccount.yml -n $NAMESPACE
    kubectl apply -f Prometheus/prometheus-pvc.yml -n $NAMESPACE
    kubectl apply -f Prometheus/configMap.yml -n $NAMESPACE
    kubectl apply -f Prometheus/deployment.yml -n $NAMESPACE
    kubectl apply -f Prometheus/services.yml -n $NAMESPACE

    echo "Deploy Loki..."
    kubectl apply -f Loki/loki-pvc.yml -n $NAMESPACE
    kubectl apply -f Loki/configMap.yml -n $NAMESPACE
    kubectl apply -f Loki/deployment.yml -n $NAMESPACE
    kubectl apply -f Loki/services.yml -n $NAMESPACE

    echo "Deploy Tempo..."
    kubectl apply -f Tempo/tempo-pvc.yml -n $NAMESPACE
    kubectl apply -f Tempo/configMap.yml -n $NAMESPACE
    kubectl apply -f Tempo/deployment.yml -n $NAMESPACE
    kubectl apply -f Tempo/services.yml -n $NAMESPACE

    echo "Deploy Grafana..."
    kubectl apply -f Grafana/configMap-all.yml -n $NAMESPACE
    kubectl apply -f Grafana/grafana-pvc.yml -n $NAMESPACE
    kubectl apply -f Grafana/deployment.yml -n $NAMESPACE
    kubectl apply -f Grafana/services.yml -n $NAMESPACE
    kubectl apply -f Grafana/ingress.yml -n $NAMESPACE
    echo "Deploy Grafana..."
    kubectl apply -f testapp/test-app.yml
    kubectl apply -f testapp/test-app2.yml
    kubectl apply -f testapp/traffic.yml

    echo "Tutti i manifest sono stati applicati!"
    kubectl get all -n $NAMESPACE

elif [ "$OPTION" == "2" ]; then
    echo "Cancellazione di tutti i manifest..."
    kubectl delete -f Grafana/ingress.yml -n $NAMESPACE || true
    kubectl delete -f Grafana/services.yml -n $NAMESPACE || true
    kubectl delete -f Grafana/deployment.yml -n $NAMESPACE || true
    kubectl delete -f Grafana/configMap-all.yml -n $NAMESPACE || true
    kubectl delete -f Grafana/grafana-pvc.yml -n $NAMESPACE || true

    kubectl delete -f Tempo/services.yml -n $NAMESPACE || true
    kubectl delete -f Tempo/deployment.yml -n $NAMESPACE || true
    kubectl delete -f Tempo/configMap.yml -n $NAMESPACE || true
    kubectl delete -f Tempo/tempo-pvc.yml -n $NAMESPACE || true

    kubectl delete -f Loki/services.yml -n $NAMESPACE || true
    kubectl delete -f Loki/deployment.yml -n $NAMESPACE || true
    kubectl delete -f Loki/configMap.yml -n $NAMESPACE || true
    kubectl delete -f Loki/loki-pvc.yml -n $NAMESPACE || true

    kubectl delete -f Prometheus/services.yml -n $NAMESPACE || true
    kubectl delete -f Prometheus/deployment.yml -n $NAMESPACE || true
    kubectl delete -f Prometheus/configMap.yml -n $NAMESPACE || true
    kubectl delete -f Prometheus/prometheus-pvc.yml -n $NAMESPACE || true

    kubectl delete -f Metrics/kube-state-metrics.yaml -n $NAMESPACE || true
    kubectl delete -f Metrics/node-exporter.yml -n $NAMESPACE || true

    kubectl delete -f Promtail/promtail.yml -n $NAMESPACE || true
    kubectl delete -f testapp/test-app.yml -n default || true
    kubectl delete -f testapp/test-app2.yml -n default || true
    kubectl delete -f testapp/traffic.yml -n default || true


    echo "Namespace $NAMESPACE rimosso (opzionale)"
    kubectl delete -f namespace -n $NAMESPACE || true

else
    echo "Opzione non valida, esci."
    exit 1
fi
