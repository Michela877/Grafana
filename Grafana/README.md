# prima di applicare il deployment creare un account gmail per gli alert e una password per le app su sicurezza
qui sotto dove vi sara il deployemnt dovrete configuare le tue email dove ci sta scritto tuoindirizzo

```bash
        - name: GF_SMTP_ENABLED
          value: "true"
        - name: GF_SMTP_HOST
          value: "smtp.gmail.com:587"
        - name: GF_SMTP_USER
          value: "tuoindirizzo@gmail.com"
        - name: GF_SMTP_PASSWORD
          valueFrom:
            secretKeyRef:
              name: smtp-secret
              key: password
        - name: GF_SMTP_FROM_ADDRESS
          value: "tuoindirizzo@gmail.com"
        - name: GF_SMTP_SKIP_VERIFY
          value: "true"
        - name: GF_SMTP_STARTTLS_POLICY
          value: "Opportunistic"
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

## 2️⃣ versione outlook

# prima di applicare il deployment creare un account outlook per gli alert e una password per le app su sicurezza
qui sotto dove vi sara il deployemnt dovrete configuare le tue email dove ci sta scritto tuoindirizzo

```bash
        - name: GF_SMTP_ENABLED
          value: "true"
        - name: GF_SMTP_HOST
          value: "smtp.office365.com:587"
        - name: GF_SMTP_USER
          value: "youruser@domain.com"
        - name: GF_SMTP_PASSWORD
          valueFrom:
            secretKeyRef:
              name: smtp-secret
              key: password
        - name: GF_SMTP_FROM_ADDRESS
          value: "youruser@domain.com"
        - name: GF_SMTP_SKIP_VERIFY
          value: "true"
        - name: GF_SMTP_STARTTLS_POLICY
          value: "Opportunistic"
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