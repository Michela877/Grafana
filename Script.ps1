$Namespace = "monitoring"

Write-Host "Scegli un'opzione:"
Write-Host "1) Installare tutti i manifest"
Write-Host "2) Cancellare tutto ciò che è stato applicato"
$Option = Read-Host "Opzione (1/2)"

if ($Option -eq "1") {

    Write-Host "Creazione namespace..."
    kubectl create namespace $Namespace -ErrorAction SilentlyContinue

    Write-Host "Deploy monitoring state metrics..."
    kubectl apply -f Metrics/kube-state-metrics.yaml -n $Namespace
    kubectl apply -f Metrics/node-exporter.yml -n $Namespace

    Write-Host "Deploy Promtail..."
    kubectl apply -f Promtail/promtail2.yml -n $Namespace

    Write-Host "Deploy Prometheus..."
    kubectl apply -f Prometheus/serviceaccount.yml -n $Namespace
    kubectl apply -f Prometheus/prometheus-pvc.yml -n $Namespace
    kubectl apply -f Prometheus/configMap.yml -n $Namespace
    kubectl apply -f Prometheus/deployment.yml -n $Namespace
    kubectl apply -f Prometheus/services.yml -n $Namespace

    Write-Host "Deploy Loki..."
    kubectl apply -f Loki/loki-pvc.yml -n $Namespace
    kubectl apply -f Loki/configMap.yml -n $Namespace
    kubectl apply -f Loki/deployment.yml -n $Namespace
    kubectl apply -f Loki/services.yml -n $Namespace

    Write-Host "Deploy Tempo..."
    kubectl apply -f Tempo/tempo-pvc.yml -n $Namespace
    kubectl apply -f Tempo/configMap.yml -n $Namespace
    kubectl apply -f Tempo/deployment.yml -n $Namespace
    kubectl apply -f Tempo/services.yml -n $Namespace

    Write-Host "Deploy Grafana..."
    kubectl apply -f Grafana/configMap-all.yml -n $Namespace
    kubectl apply -f Grafana/grafana-pvc.yml -n $Namespace
    kubectl apply -f Grafana/deployment.yml -n $Namespace
    kubectl apply -f Grafana/services.yml -n $Namespace
    kubectl apply -f Grafana/ingress.yml -n $Namespace

    Write-Host "Deploy test app..."
    # kubectl apply -f testapp/test-app.yml
    # kubectl apply -f testapp/test-app2.yml
    # kubectl apply -f testapp/traffic.yml

    Write-Host "Tutti i manifest sono stati applicati!"
    kubectl get all -n $Namespace

} elseif ($Option -eq "2") {

    Write-Host "Cancellazione di tutti i manifest..."
    
    # Delete monitoring state metrics
    kubectl delete -f Metrics/kube-state-metrics.yaml -n $Namespace -ErrorAction SilentlyContinue
    kubectl delete -f Metrics/node-exporter.yml -n $Namespace -ErrorAction SilentlyContinue

    # Delete Promtail
    kubectl delete -f Promtail/promtail2.yml -n $Namespace -ErrorAction SilentlyContinue

    # Delete Prometheus
    kubectl delete -f Prometheus/serviceaccount.yml -n $Namespace -ErrorAction SilentlyContinue
    kubectl delete -f Prometheus/prometheus-pvc.yml -n $Namespace -ErrorAction SilentlyContinue
    kubectl delete -f Prometheus/configMap.yml -n $Namespace -ErrorAction SilentlyContinue
    kubectl delete -f Prometheus/deployment.yml -n $Namespace -ErrorAction SilentlyContinue
    kubectl delete -f Prometheus/services.yml -n $Namespace -ErrorAction SilentlyContinue

    # Delete Loki
    kubectl delete -f Loki/loki-pvc.yml -n $Namespace -ErrorAction SilentlyContinue
    kubectl delete -f Loki/configMap.yml -n $Namespace -ErrorAction SilentlyContinue
    kubectl delete -f Loki/deployment.yml -n $Namespace -ErrorAction SilentlyContinue
    kubectl delete -f Loki/services.yml -n $Namespace -ErrorAction SilentlyContinue

    # Delete Tempo
    kubectl delete -f Tempo/tempo-pvc.yml -n $Namespace -ErrorAction SilentlyContinue
    kubectl delete -f Tempo/configMap.yml -n $Namespace -ErrorAction SilentlyContinue
    kubectl delete -f Tempo/deployment.yml -n $Namespace -ErrorAction SilentlyContinue
    kubectl delete -f Tempo/services.yml -n $Namespace -ErrorAction SilentlyContinue

    # Delete Grafana
    kubectl delete -f Grafana/configMap-all.yml -n $Namespace -ErrorAction SilentlyContinue
    kubectl delete -f Grafana/grafana-pvc.yml -n $Namespace -ErrorAction SilentlyContinue
    kubectl delete -f Grafana/deployment.yml -n $Namespace -ErrorAction SilentlyContinue
    kubectl delete -f Grafana/services.yml -n $Namespace -ErrorAction SilentlyContinue
    kubectl delete -f Grafana/ingress.yml -n $Namespace -ErrorAction SilentlyContinue

    Write-Host "Rimozione namespace $Namespace..."
    kubectl delete namespace $Namespace -ErrorAction SilentlyContinue

} else {
    Write-Host "Opzione non valida, esci."
    exit 1
}