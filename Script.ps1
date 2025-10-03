$Namespace = "monitoring"

Write-Host "Scegli un'opzione:"
Write-Host "1) Installare tutti i manifest"
Write-Host "2) Cancellare tutto ciò che è stato applicato"
$Option = Read-Host "Opzione (1/2)"

if ($Option -eq "1") {

    Write-Host "Creazione namespace..."
    kubectl create namespace $Namespace -ErrorAction SilentlyContinue

    Write-Host "Deploy Prometheus..."
    kubectl apply -f Prometheus/configMap.yml -n $Namespace
    kubectl apply -f Prometheus/deployment.yml -n $Namespace
    kubectl apply -f Prometheus/service.yml -n $Namespace

    Write-Host "Deploy Loki..."
    kubectl apply -f Loki/configMap.yml -n $Namespace
    kubectl apply -f Loki/deployment.yml -n $Namespace
    kubectl apply -f Loki/service.yml -n $Namespace

    Write-Host "Deploy Tempo..."
    kubectl apply -f Tempo/configMap.yml -n $Namespace
    kubectl apply -f Tempo/deployment.yml -n $Namespace
    kubectl apply -f Tempo/service.yml -n $Namespace

    Write-Host "Deploy Grafana..."
    kubectl apply -f Grafana/configMap.yml -n $Namespace
    kubectl apply -f Grafana/deployment.yml -n $Namespace
    kubectl apply -f Grafana/service.yml -n $Namespace
    kubectl apply -f Grafana/ingress.yml -n $Namespace

    Write-Host "Tutti i manifest sono stati applicati!"
    kubectl get all -n $Namespace

} elseif ($Option -eq "2") {

    Write-Host "Cancellazione di tutti i manifest..."
    kubectl delete -f Grafana/ingress.yml -n $Namespace -ErrorAction SilentlyContinue
    kubectl delete -f Grafana/service.yml -n $Namespace -ErrorAction SilentlyContinue
    kubectl delete -f Grafana/deployment.yml -n $Namespace -ErrorAction SilentlyContinue
    kubectl delete -f Grafana/configMap.yml -n $Namespace -ErrorAction SilentlyContinue

    kubectl delete -f Tempo/service.yml -n $Namespace -ErrorAction SilentlyContinue
    kubectl delete -f Tempo/deployment.yml -n $Namespace -ErrorAction SilentlyContinue
    kubectl delete -f Tempo/configMap.yml -n $Namespace -ErrorAction SilentlyContinue

    kubectl delete -f Loki/service.yml -n $Namespace -ErrorAction SilentlyContinue
    kubectl delete -f Loki/deployment.yml -n $Namespace -ErrorAction SilentlyContinue
    kubectl delete -f Loki/configMap.yml -n $Namespace -ErrorAction SilentlyContinue

    kubectl delete -f Prometheus/service.yml -n $Namespace -ErrorAction SilentlyContinue
    kubectl delete -f Prometheus/deployment.yml -n $Namespace -ErrorAction SilentlyContinue
    kubectl delete -f Prometheus/configMap.yml -n $Namespace -ErrorAction SilentlyContinue

    Write-Host "Namespace $Namespace rimosso (opzionale)"
    kubectl delete namespace $Namespace -ErrorAction SilentlyContinue

} else {
    Write-Host "Opzione non valida, esci."
    exit 1
}
