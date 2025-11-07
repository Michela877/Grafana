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