# prima di applicare il deployment creare un account gmail per gli alert e una password per le app su sicurezza
qui sotto è uno script per creare il secret per far funzionare la configurazione della email versione gmail

```bash
# Definire le variabili

$GF_SECURITY_ADMIN_USER="admin"
$GF_SECURITY_ADMIN_PASSWORD="admin"
$GF_SMTP_ENABLED="true"
$GF_SMTP_HOST="smtp.gmail.com:587"
$GF_SMTP_USER="tua-email@gmail.com"
$GF_SMTP_PASSWORD="password-applicativa-gmail"
$GF_SMTP_FROM_ADDRESS="tua-email@gmail.com"
$GF_SMTP_FROM_NAME="Alerting Grafana"
$GF_SMTP_SKIP_VERIFY="false"
$GF_SMTP_STARTTLS_POLICY="Opportunistic"

#inserire le nuove varibili password applicativi email alerting grafana da cambiare tutto e mettere qui nel secret qui sotto un esempio di come è stato creato


kubectl delete secret grafana-smtp-secret -n monitoring
# Creare il Secret usando queste variabili
kubectl create secret generic grafana-smtp-secret -n monitoring --from-literal=GF_SECURITY_ADMIN_USER=$GF_SECURITY_ADMIN_USER --from-literal=GF_SECURITY_ADMIN_PASSWORD=$GF_SECURITY_ADMIN_PASSWORD --from-literal=GF_SMTP_ENABLED=$GF_SMTP_ENABLED --from-literal=GF_SMTP_HOST=$GF_SMTP_HOST --from-literal=GF_SMTP_USER=$GF_SMTP_USER --from-literal=GF_SMTP_PASSWORD=$GF_SMTP_PASSWORD --from-literal=GF_SMTP_FROM_ADDRESS=$GF_SMTP_FROM_ADDRESS --from-literal=GGF_SMTP_SKIP_VERIFY=$GF_SMTP_SKIP_VERIFY --from-literal=GF_SMTP_STARTTLS_POLICY=$GF_SMTP_STARTTLS_POLICY --from-literal=GF_SMTP_FROM_NAME=$GF_SMTP_FROM_NAME
```

# creazione del secret password delle app su gmail
Vai su Sicurezza → Password per le app
Ti verrà mostrata una password di 16 caratteri (es: abcd efgh ijkl mnop) che dovra essere inserita nel secret

```bash
apiVersion: v1
kind: Secret
metadata:
  name: smtp-secret
  namespace: monitoring
type: Opaque
stringData:
  password: "tua password app creata su gmail nella sezione sicurezza password per le app"

```

## 2️⃣ versione outlook azure

# prima di applicare il deployment creare un account outlook per gli alert e una password per le app su sicurezza
qui sotto è uno script per creare il secret per far funzionare la configurazione della email versione azure outlook per versione semplice creare password applicativa outlook e usare email su username e password applicativa su password come per la impostazione gmail

```bash
# Definire le variabili

$GF_SECURITY_ADMIN_USER="admin"
$GF_SECURITY_ADMIN_PASSWORD="admin"
$GF_SMTP_ENABLED="true"
$GF_SMTP_HOST="smtp.azurecomm.net:587"
$GF_SMTP_USER="<communicationServiceName>.<applicationId>.<tenantId>"
$GF_SMTP_PASSWORD="<valueId>"
$GF_SMTP_FROM_ADDRESS="no-reply.alert@tuodominioallegatoapplicationID.it"
$GF_SMTP_FROM_NAME="Alerting Grafana"
$GF_SMTP_SKIP_VERIFY="false"
$GF_SMTP_STARTTLS_POLICY="MandatoryStartTLS"

#inserire le nuove varibili password applicativi email alerting grafana da cambiare tutto e mettere qui nel secret qui sotto un esempio di come è stato creato


kubectl delete secret grafana-smtp-secret -n monitoring
# Creare il Secret usando queste variabili
kubectl create secret generic grafana-smtp-secret -n monitoring --from-literal=GF_SECURITY_ADMIN_USER=$GF_SECURITY_ADMIN_USER --from-literal=GF_SECURITY_ADMIN_PASSWORD=$GF_SECURITY_ADMIN_PASSWORD --from-literal=GF_SMTP_ENABLED=$GF_SMTP_ENABLED --from-literal=GF_SMTP_HOST=$GF_SMTP_HOST --from-literal=GF_SMTP_USER=$GF_SMTP_USER --from-literal=GF_SMTP_PASSWORD=$GF_SMTP_PASSWORD --from-literal=GF_SMTP_FROM_ADDRESS=$GF_SMTP_FROM_ADDRESS --from-literal=GGF_SMTP_SKIP_VERIFY=$GF_SMTP_SKIP_VERIFY --from-literal=GF_SMTP_STARTTLS_POLICY=$GF_SMTP_STARTTLS_POLICY --from-literal=GF_SMTP_FROM_NAME=$GF_SMTP_FROM_NAME

```

# creazione del secret password delle app su gmail
Vai su Sicurezza → Password per le app
Ti verrà mostrata una password di 16 caratteri (es: abcd efgh ijkl mnop) che dovra essere inserita nel secret

```bash
apiVersion: v1
kind: Secret
metadata:
  name: smtp-secret
  namespace: monitoring
type: Opaque
stringData:
  password: "tua password app creata su gmail nella sezione sicurezza password per le app"

```


# creazione alert alerting su rules per tutti i pod namespaces
una volta creato il tutto bisognera creare le regole di alert questa qui sotto bisognera mettere prometheus tramite code successivamente su options dichiarare le variabili
questa regola sotto manda gli alert per ogni errore che fa il pod quindi crashloop imagepullerro ecc anche i container creating gestisce tutto cio che succede

2. Define query and alert condition
prometheus Options 5 minutes, MD = 43200, Min. Interval = 1 questa lunga e la !!DEFINITIVA!!
```bash
sum by(pod, namespace, reason) (kube_pod_container_status_waiting_reason{namespace=~"asv-apps|envoy-gateway-system|monitoring|flux-system|gatekeeper-system|kube-node-lease|kube-public|kube-system|default"})
```
Options Legend: {{pod}} - {{reason}} - {{namespace}} Format: Time series Step: Type: Instant
```bash
sum by(pod, reason) (kube_pod_container_status_waiting_reason{namespace="asv-apps"})
```
---
Options Legend: {{pod}} - {{reason}} Format: Time series Step: Type: Instant
```bash
{{pod}} - {{reason}}
```
---
WHEN Last OF QUERY Is above 0
or
WHEN QUERY Is above 0


4. Set evaluation behavior
Pending period 1m
Keep firing for 1m
---
Configure no data and error handling
Alert state if no data or all values are null (normal)
Alert state if execution error or timeout (normal)
---
6. Configure notification message
```bash
Pod {{ $labels.pod }} nel namespace nomenamespaces è in stato {{ $labels.reason }}
```
6. Configure notification message
```bash
Pod {{ $labels.pod }} nel namespace {{ $labels.namespace }} è in stato {{ $labels.reason }}
```

# creazione alert alerting su rules per richieste http
una volta creato il tutto bisognera creare le regole di alert questa qui sotto bisognera mettere prometheus tramite code successivamente su options dichiarare le variabili
questa regola sotto manda gli alert per ogni errore di un sito web dai 200 ai 599

2. Define query and alert condition
prometheus Options 5 minutes, MD = 43200, Min. Interval = 1
```bash
probe_http_status_code
```
se da problemi mettere labelfilter instance senza nulla
---
Options Legend: auto Format: Time series Step: Type: Range

---
WHEN Last OF QUERY Is whithin range 400 to 599


4. Set evaluation behavior
Pending period 1m
Keep firing for 1m
---
Configure no data and error handling
Alert state if no data or all values are null (normal)
Alert state if execution error or timeout (normal)
---
6. Configure notification message
```bash
summary: "HTTP Error {{ $value }} on {{ $labels.instance }}"
description: "Il sito {{ $labels.instance }} restituisce errore HTTP {{ $value }}"
```



---
refuso solo per memo

```bash
sum by(pod, reason) (max_over_time(kube_pod_container_status_waiting_reason{namespace="asv-apps"}[2m]))
```