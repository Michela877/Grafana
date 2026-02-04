# 🚀 FluxCD GitOps Setup (Kubernetes Local)

Questa guida descrive come installare ***Grafana** dentro **FluxCD** su un cluster Kubernetes e applicare la configurazione GitOps partendo da **GitRepository** e **Kustomization**, senza bootstrap automatico su GitHub.

> ✅ Approccio semplice  
> ✅ Compatibile con Flux v2

### 📁 Struttura GitOps (esempio)
.
├── gitrepository.yaml
├── root-kustomization.yaml
├── fluxcd-apps/
|    ├── grafana-app.yaml
|    └── prometheus-app.yaml
└── apps/
    ├── prometheus/
    |    └── kustomization.yaml
    └── Grafana/
        └── kustomization.yaml

---

## 📦 Prerequisiti

Assicurati di avere:

- Linux
- Kubernetes funzionante (`kubectl`)
- Accesso admin al cluster
- `curl` installato

Verifica:
```bash
kubectl get nodes
```
```bash
curl -s https://fluxcd.io/install.sh | sudo bash
```
```bash
flux --version
```
```bash
flux install
```
```bash
kubectl apply -f gitrepository.yaml -n flux-system
```
```bash
kubectl apply -f root-kustomization.yaml -n flux-system
```
```bash
flux get kustomizations
```
```bash
flux get sources git
```

## 📦 Secret da applicare

```bash
#!/bin/bash

set -e

NAMESPACE="monitoring"
SECRET_NAME="grafana-smtp-secret"

GF_SECURITY_ADMIN_USER="admin"
GF_SECURITY_ADMIN_PASSWORD="admin"

GF_SMTP_ENABLED="true"
GF_SMTP_HOST="smtp.gmail.com:587"
GF_SMTP_USER="tuoindirizzo@gmail.com"
GF_SMTP_PASSWORD="APP_PASSWORD_GMAIL"
GF_SMTP_FROM_ADDRESS="tuoindirizzo@gmail.com"
GF_SMTP_FROM_NAME="Alerting Grafana"
GF_SMTP_SKIP_VERIFY="true"
GF_SMTP_STARTTLS_POLICY="Opportunistic"

echo "🧹 Deleting old secret (if exists)..."
kubectl delete secret $SECRET_NAME -n $NAMESPACE --ignore-not-found

echo "🔐 Creating Grafana SMTP secret..."
kubectl create secret generic $SECRET_NAME -n $NAMESPACE \
  --from-literal=GF_SECURITY_ADMIN_USER="$GF_SECURITY_ADMIN_USER" \
  --from-literal=GF_SECURITY_ADMIN_PASSWORD="$GF_SECURITY_ADMIN_PASSWORD" \
  --from-literal=GF_SMTP_ENABLED="$GF_SMTP_ENABLED" \
  --from-literal=GF_SMTP_HOST="$GF_SMTP_HOST" \
  --from-literal=GF_SMTP_USER="$GF_SMTP_USER" \
  --from-literal=GF_SMTP_PASSWORD="$GF_SMTP_PASSWORD" \
  --from-literal=GF_SMTP_FROM_ADDRESS="$GF_SMTP_FROM_ADDRESS" \
  --from-literal=GF_SMTP_FROM_NAME="$GF_SMTP_FROM_NAME" \
  --from-literal=GF_SMTP_SKIP_VERIFY="$GF_SMTP_SKIP_VERIFY" \
  --from-literal=GF_SMTP_STARTTLS_POLICY="$GF_SMTP_STARTTLS_POLICY"

echo "✅ Secret creato con successo"
```