# Setup iniziale Grafana pack

Questa guida descrive i passaggi per configurare l’ambiente di monitoraggio `Grafana` su Kubernetes.

---

## 1️⃣ Creazione del ningress controller

utilizzare questo comando

```bash
helm install ingress-nginx ingress-nginx/ingress-nginx   --namespace ingress-nginx --create-namespace   --set controller.service.type=LoadBalancer
```

---

## 1️⃣ Creazione del namespace

Creare il namespace dedicato alle applicazioni:

```bash
kubectl create ns monitoring
```

---

## 2️⃣ Creazione dei singoli con kustomize

ma prima bisognera configurare il service con il load balancer o senno l'ingress successivamente avviare l'installazione con quest'ordine di creazione usando kustomize "GRAFANA-METRICS-PROMETHEUS-LOKI-PROMTAIL-TEMPO" qui sotto il comando:

```bash
kubectl apply -k "path assoluto in locale"
```

---

## 3️⃣ credenziali per accedere

le credenziali base per accedere sono 

id admin
password admin

una volta eseguito l'accesso e cambiato la password si avra tutto lo stack grafana configurato

se da accesso sbagliato usare questi comandi prima entrare nel pod poi cambiare la password

```bash
# Accedi al pod e resetta la password
sudo kubectl exec -it grafana-7ff457789c-56dj5 -n monitoring -- /bin/sh
```

```bash
# Dentro il container, esegui:
grafana-cli admin reset-admin-password admin
```

---

## 4️⃣ configurazione dashboard Grafana Prometheus

15661 questo codice ti rilascia la dashboard con prometheus per tutto il cluster kubernetes

## 4️⃣ configurazione dashboard Loki Grafana

QUI SOTTO DASHBOARD PER LOKI PER I LOG DEI SINGOLI CONTAINER
usare questa regex ^/var/log/containers/[a-zA-Z0-9-]+_[a-zA-Z0-9-]+_.+\.log$

andare su editor e impostare variables e mettere su data source loki e la regex sopra

po su query tipe mettere label values e poi label filename

```yaml
{
  "annotations": {
    "list": [
      {
        "$$hashKey": "object:75",
        "builtIn": 1,
        "datasource": {
          "uid": "-- Grafana --"
        },
        "enable": true,
        "hide": true,
        "iconColor": "rgba(0, 211, 255, 1)",
        "name": "Annotations & Alerts",
        "target": {
          "limit": 100,
          "matchAny": false,
          "tags": [],
          "type": "dashboard"
        },
        "type": "dashboard"
      }
    ]
  },
  "description": "Log Viewer Dashboard for Loki",
  "editable": true,
  "fiscalYearStartMonth": 0,
  "graphTooltip": 0,
  "id": 0,
  "links": [
    {
      "$$hashKey": "object:59",
      "icon": "bolt",
      "includeVars": true,
      "keepTime": true,
      "tags": [],
      "targetBlank": true,
      "title": "View In Explore",
      "type": "link",
      "url": "/explore?orgId=1&left=[\"now-1h\",\"now\",\"Loki\",{\"expr\":\"{filename=\\\"$filename\\\"}\"},{\"ui\":[true,true,true,\"none\"]}]"
    },
    {
      "$$hashKey": "object:61",
      "icon": "external link",
      "tags": [],
      "targetBlank": true,
      "title": "Learn LogQL",
      "type": "link",
      "url": "https://grafana.com/docs/loki/latest/logql/"
    }
  ],
  "panels": [
    {
      "datasource": {
        "type": "loki",
        "uid": "P8E80F9AEF21F6940"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "hidden",
            "barAlignment": 0,
            "barWidthFactor": 0.6,
            "drawStyle": "bars",
            "fillOpacity": 100,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "linear",
            "lineWidth": 1,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "never",
            "showValues": false,
            "spanNulls": false,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "links": [],
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": 0
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          },
          "unit": "short"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 3,
        "w": 24,
        "x": 0,
        "y": 0
      },
      "id": 6,
      "options": {
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": false
        },
        "tooltip": {
          "hideZeros": false,
          "mode": "multi",
          "sort": "none"
        }
      },
      "pluginVersion": "12.2.0",
      "targets": [
        {
          "datasource": {
            "type": "loki",
            "uid": "P8E80F9AEF21F6940"
          },
          "expr": "sum(count_over_time({filename=\"$filename\"} |= \"$search\" [$__interval]))",
          "legendFormat": "",
          "refId": "A"
        }
      ],
      "title": "",
      "type": "timeseries"
    },
    {
      "datasource": {
        "type": "loki",
        "uid": "P8E80F9AEF21F6940"
      },
      "fieldConfig": {
        "defaults": {},
        "overrides": []
      },
      "gridPos": {
        "h": 25,
        "w": 24,
        "x": 0,
        "y": 3
      },
      "id": 2,
      "maxDataPoints": "",
      "options": {
        "dedupStrategy": "none",
        "enableInfiniteScrolling": false,
        "enableLogDetails": true,
        "prettifyLogMessage": false,
        "showCommonLabels": false,
        "showLabels": false,
        "showTime": true,
        "sortOrder": "Descending",
        "wrapLogMessage": false
      },
      "pluginVersion": "12.2.0",
      "targets": [
        {
          "datasource": {
            "type": "loki",
            "uid": "P8E80F9AEF21F6940"
          },
          "expr": "{filename=\"$filename\"} |= \"$search\" | logfmt",
          "hide": false,
          "legendFormat": "",
          "refId": "A"
        }
      ],
      "title": "",
      "transparent": true,
      "type": "logs"
    }
  ],
  "preload": false,
  "refresh": "",
  "schemaVersion": 42,
  "tags": [],
  "templating": {
    "list": [
      {
        "current": {
          "text": "/var/log/containers/traffic-generator-7b5bf85f6f-8rgqm_default_generator-072a06a2715df672d618ec829b6e845da7e0bb916e258c4c8f2c2d9ad537c965.log",
          "value": "/var/log/containers/traffic-generator-7b5bf85f6f-8rgqm_default_generator-072a06a2715df672d618ec829b6e845da7e0bb916e258c4c8f2c2d9ad537c965.log"
        },
        "definition": "",
        "label": "File",
        "name": "filename",
        "options": [],
        "query": {
          "label": "filename",
          "refId": "LokiVariableQueryEditor-VariableQuery",
          "stream": "",
          "type": 1
        },
        "refresh": 1,
        "regex": "",
        "type": "query"
      },
      {
        "current": {
          "text": "",
          "value": ""
        },
        "label": "String Match",
        "name": "search",
        "options": [
          {
            "selected": true,
            "text": "",
            "value": ""
          }
        ],
        "query": "",
        "type": "textbox"
      }
    ]
  },
  "time": {
    "from": "now-5m",
    "to": "now"
  },
  "timepicker": {
    "refresh_intervals": [
      "10s",
      "30s",
      "1m",
      "5m",
      "15m",
      "30m",
      "1h",
      "2h",
      "1d"
    ]
  },
  "timezone": "",
  "title": "Logs / App",
  "uid": "sadlil-loki-apps-dashboard",
  "version": 8
}
```

## 4️⃣ configurazione dashboard Tempo Grafana

```yaml
{
  "annotations": {
    "list": [
      {
        "builtIn": 1,
        "datasource": {
          "type": "grafana",
          "uid": "-- Grafana --"
        },
        "enable": true,
        "hide": true,
        "iconColor": "rgba(0, 211, 255, 1)",
        "name": "Annotations & Alerts",
        "type": "dashboard"
      }
    ]
  },
  "description": "Shows high level LLM successes and failures.",
  "editable": true,
  "fiscalYearStartMonth": 0,
  "graphTooltip": 0,
  "id": 0,
  "links": [],
  "panels": [
    {
      "datasource": {
        "type": "tempo",
        "uid": "P214B5B846CF3925F"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "thresholds"
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": 0
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 5,
        "w": 6,
        "x": 0,
        "y": 0
      },
      "id": 6,
      "options": {
        "colorMode": "value",
        "graphMode": "area",
        "justifyMode": "auto",
        "orientation": "auto",
        "percentChangeColorMode": "standard",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "textMode": "auto",
        "wideLayout": true
      },
      "pluginVersion": "12.2.0",
      "targets": [
        {
          "datasource": {
            "type": "tempo",
            "uid": "P214B5B846CF3925F"
          },
          "filters": [
            {
              "id": "2981aa81",
              "operator": "=",
              "scope": "span"
            }
          ],
          "limit": 1000,
          "query": "{name=\"span\"}",
          "queryType": "traceqlSearch",
          "refId": "A",
          "spss": 10,
          "tableType": "traces"
        }
      ],
      "title": "Total Requests",
      "transformations": [
        {
          "id": "organize",
          "options": {
            "excludeByName": {
              "Duration": true,
              "Name": true,
              "Service": true,
              "Start time": true,
              "nested": true
            },
            "includeByName": {},
            "indexByName": {},
            "renameByName": {}
          }
        },
        {
          "id": "reduce",
          "options": {
            "includeTimeField": false,
            "mode": "reduceFields",
            "reducers": [
              "count"
            ]
          }
        }
      ],
      "type": "stat"
    },
    {
      "datasource": {
        "type": "tempo",
        "uid": "P214B5B846CF3925F"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "thresholds"
          },
          "custom": {
            "align": "auto",
            "cellOptions": {
              "type": "auto"
            },
            "footer": {
              "reducers": []
            },
            "inspect": false
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": 0
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 10,
        "w": 17,
        "x": 6,
        "y": 0
      },
      "id": 5,
      "options": {
        "cellHeight": "sm",
        "showHeader": true,
        "sortBy": [
          {
            "desc": true,
            "displayName": "outputs.llmResponseInfo.output"
          }
        ]
      },
      "pluginVersion": "12.2.0",
      "targets": [
        {
          "datasource": {
            "type": "tempo",
            "uid": "P214B5B846CF3925F"
          },
          "limit": 1000,
          "query": "{name=\"step\" } | select(span.output.value)",
          "queryType": "traceql",
          "refId": "A",
          "spss": 10,
          "tableType": "spans"
        }
      ],
      "title": "Failed Validations",
      "transformations": [
        {
          "id": "extractFields",
          "options": {
            "format": "json",
            "jsonPaths": [
              {
                "alias": "Prompt 1",
                "path": "inputs.msgHistory[0]['content']"
              },
              {
                "alias": "LLM Response",
                "path": "outputs.llmResponseInfo.output"
              },
              {
                "alias": "Prompt 2",
                "path": "inputs.msgHistory[1]['content']"
              },
              {
                "alias": "Prompt 3",
                "path": "inputs.msgHistory[2]['content']"
              },
              {
                "alias": "Prompt 4",
                "path": "inputs.msgHistory[3]['content']"
              },
              {
                "alias": "outcome1",
                "path": "outputs.validatorLogs[0].validationResult.outcome"
              },
              {
                "alias": "outcome2",
                "path": "outputs.validatorLogs[1].validationResult.outcome"
              },
              {
                "alias": "outcome3",
                "path": "outputs.validatorLogs[2].validationResult.outcome"
              },
              {
                "alias": "outcome4",
                "path": "outputs.validatorLogs[3].validationResult.outcome"
              },
              {
                "alias": "outcome5",
                "path": "outputs.validatorLogs[4].validationResult.outcome"
              }
            ],
            "source": "output.value"
          }
        },
        {
          "id": "filterByValue",
          "options": {
            "filters": [
              {
                "config": {
                  "id": "equal",
                  "options": {
                    "value": "fail"
                  }
                },
                "fieldName": "outcome1"
              },
              {
                "config": {
                  "id": "equal",
                  "options": {
                    "value": "fail"
                  }
                },
                "fieldName": "outcome2"
              },
              {
                "config": {
                  "id": "equal",
                  "options": {
                    "value": "fail"
                  }
                },
                "fieldName": "outcome3"
              },
              {
                "config": {
                  "id": "equal",
                  "options": {
                    "value": "fail"
                  }
                },
                "fieldName": "outcome4"
              },
              {
                "config": {
                  "id": "equal",
                  "options": {
                    "value": "fail"
                  }
                },
                "fieldName": "outcome5"
              }
            ],
            "match": "any",
            "type": "include"
          }
        },
        {
          "id": "organize",
          "options": {
            "excludeByName": {
              "Duration": true,
              "Name": true,
              "Prompt": true,
              "Prompt 1": false,
              "Prompt 2": true,
              "Prompt 3": true,
              "Prompt 4": true,
              "Span ID": false,
              "Start time": true,
              "Trace Name": true,
              "Trace Service": true,
              "outcome1": true,
              "outcome2": true,
              "outcome3": true,
              "outcome4": true,
              "outcome5": true,
              "output.value": true,
              "traceIdHidden": false
            },
            "includeByName": {},
            "indexByName": {
              "Duration": 7,
              "LLM Response": 9,
              "Name": 5,
              "Prompt 1": 8,
              "Prompt 2": 10,
              "Prompt 3": 11,
              "Prompt 4": 12,
              "Span ID": 3,
              "Start time": 4,
              "Trace Name": 2,
              "Trace Service": 1,
              "outcome1": 13,
              "outcome2": 14,
              "outcome3": 15,
              "outcome4": 16,
              "outcome5": 17,
              "output.value": 6,
              "traceIdHidden": 0
            },
            "renameByName": {
              "Message History": "",
              "Prompt 1": "Prompt"
            }
          }
        },
        {
          "disabled": true,
          "id": "convertFieldType",
          "options": {
            "conversions": [
              {
                "destinationType": "boolean",
                "targetField": "outcome1"
              },
              {
                "destinationType": "boolean",
                "targetField": "outcome2"
              }
            ],
            "fields": {}
          }
        }
      ],
      "type": "table"
    },
    {
      "datasource": {
        "type": "tempo",
        "uid": "P214B5B846CF3925F"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "thresholds"
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": 0
              },
              {
                "color": "#EAB839",
                "value": 0
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 5,
        "w": 6,
        "x": 0,
        "y": 5
      },
      "id": 7,
      "options": {
        "colorMode": "value",
        "graphMode": "area",
        "justifyMode": "auto",
        "orientation": "auto",
        "percentChangeColorMode": "standard",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "textMode": "auto",
        "wideLayout": true
      },
      "pluginVersion": "12.2.0",
      "targets": [
        {
          "datasource": {
            "type": "tempo",
            "uid": "P214B5B846CF3925F"
          },
          "limit": 1000,
          "query": "{name=\"step\" } | select(span.output.value)",
          "queryType": "traceql",
          "refId": "A",
          "tableType": "spans"
        }
      ],
      "title": "Total Failed Validations",
      "transformations": [
        {
          "id": "extractFields",
          "options": {
            "format": "json",
            "jsonPaths": [
              {
                "alias": "Prompt 1",
                "path": "inputs.msgHistory[0]['content']"
              },
              {
                "alias": "LLM Response",
                "path": "outputs.llmResponseInfo.output"
              },
              {
                "alias": "Prompt 2",
                "path": "inputs.msgHistory[1]['content']"
              },
              {
                "alias": "Prompt 3",
                "path": "inputs.msgHistory[2]['content']"
              },
              {
                "alias": "Prompt 4",
                "path": "inputs.msgHistory[3]['content']"
              },
              {
                "alias": "outcome1",
                "path": "outputs.validatorLogs[0].validationResult.outcome"
              },
              {
                "alias": "outcome2",
                "path": "outputs.validatorLogs[1].validationResult.outcome"
              },
              {
                "alias": "outcome3",
                "path": "outputs.validatorLogs[2].validationResult.outcome"
              },
              {
                "alias": "outcome4",
                "path": "outputs.validatorLogs[3].validationResult.outcome"
              },
              {
                "alias": "outcome5",
                "path": "outputs.validatorLogs[4].validationResult.outcome"
              }
            ],
            "source": "output.value"
          }
        },
        {
          "id": "filterByValue",
          "options": {
            "filters": [
              {
                "config": {
                  "id": "equal",
                  "options": {
                    "value": "fail"
                  }
                },
                "fieldName": "outcome1"
              },
              {
                "config": {
                  "id": "equal",
                  "options": {
                    "value": "fail"
                  }
                },
                "fieldName": "outcome2"
              },
              {
                "config": {
                  "id": "equal",
                  "options": {
                    "value": "fail"
                  }
                },
                "fieldName": "outcome3"
              },
              {
                "config": {
                  "id": "equal",
                  "options": {
                    "value": "fail"
                  }
                },
                "fieldName": "outcome4"
              },
              {
                "config": {
                  "id": "equal",
                  "options": {
                    "value": "fail"
                  }
                },
                "fieldName": "outcome5"
              }
            ],
            "match": "any",
            "type": "include"
          }
        },
        {
          "id": "organize",
          "options": {
            "excludeByName": {
              "Duration": true,
              "LLM Response": true,
              "Name": true,
              "Prompt": true,
              "Prompt 1": true,
              "Prompt 2": true,
              "Prompt 3": true,
              "Prompt 4": true,
              "Span ID": false,
              "Start time": true,
              "Trace Name": true,
              "Trace Service": true,
              "outcome1": true,
              "outcome2": true,
              "outcome3": true,
              "outcome4": true,
              "outcome5": true,
              "output.value": true,
              "traceIdHidden": true
            },
            "includeByName": {},
            "indexByName": {
              "Duration": 7,
              "LLM Response": 9,
              "Name": 5,
              "Prompt 1": 8,
              "Prompt 2": 10,
              "Prompt 3": 11,
              "Prompt 4": 12,
              "Span ID": 3,
              "Start time": 4,
              "Trace Name": 2,
              "Trace Service": 1,
              "outcome1": 13,
              "outcome2": 14,
              "outcome3": 15,
              "outcome4": 16,
              "outcome5": 17,
              "output.value": 6,
              "traceIdHidden": 0
            },
            "renameByName": {
              "Message History": "",
              "Prompt 1": "Prompt"
            }
          }
        },
        {
          "id": "reduce",
          "options": {
            "reducers": [
              "count"
            ]
          }
        }
      ],
      "type": "stat"
    },
    {
      "collapsed": false,
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 10
      },
      "id": 2,
      "panels": [],
      "title": "Guard behavior",
      "type": "row"
    },
    {
      "datasource": {
        "type": "tempo",
        "uid": "P214B5B846CF3925F"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "fillOpacity": 80,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "lineWidth": 1,
            "scaleDistribution": {
              "type": "linear"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": 0
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 11
      },
      "id": 1,
      "options": {
        "barRadius": 0,
        "barWidth": 0.97,
        "fullHighlight": false,
        "groupWidth": 0.7,
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "orientation": "auto",
        "showValue": "auto",
        "stacking": "none",
        "tooltip": {
          "hideZeros": false,
          "mode": "single",
          "sort": "none"
        },
        "xTickLabelRotation": 0,
        "xTickLabelSpacing": 0
      },
      "pluginVersion": "12.2.0",
      "targets": [
        {
          "datasource": {
            "type": "tempo",
            "uid": "P214B5B846CF3925F"
          },
          "filters": [
            {
              "id": "0b3c1488",
              "operator": "=",
              "scope": "span"
            }
          ],
          "limit": 1000,
          "metricsQueryType": "range",
          "queryType": "traceqlSearch",
          "refId": "A",
          "serviceMapUseNativeHistograms": false,
          "tableType": "traces"
        }
      ],
      "title": "Guard run duration",
      "type": "barchart"
    },
    {
      "datasource": {
        "type": "tempo",
        "uid": "P214B5B846CF3925F"
      },
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "thresholds"
          },
          "custom": {
            "align": "auto",
            "cellOptions": {
              "type": "auto"
            },
            "footer": {
              "reducers": []
            },
            "inspect": false
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": 0
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 16,
        "w": 11,
        "x": 12,
        "y": 11
      },
      "id": 8,
      "options": {
        "cellHeight": "sm",
        "showHeader": true,
        "sortBy": [
          {
            "desc": true,
            "displayName": "outputs.llmResponseInfo.output"
          }
        ]
      },
      "pluginVersion": "12.2.0",
      "targets": [
        {
          "datasource": {
            "type": "tempo",
            "uid": "P214B5B846CF3925F"
          },
          "limit": 20,
          "query": "{name=\"step\" } | select(span.output.value)",
          "queryType": "traceql",
          "refId": "A",
          "tableType": "spans"
        }
      ],
      "title": "All Guard Runs",
      "transformations": [
        {
          "id": "extractFields",
          "options": {
            "format": "json",
            "jsonPaths": [
              {
                "alias": "Prompt 1",
                "path": "inputs.msgHistory[0]['content']"
              },
              {
                "alias": "LLM Response",
                "path": "outputs.llmResponseInfo.output"
              },
              {
                "alias": "Prompt 2",
                "path": "inputs.msgHistory[1]['content']"
              },
              {
                "alias": "Prompt 3",
                "path": "inputs.msgHistory[2]['content']"
              },
              {
                "alias": "Prompt 4",
                "path": "inputs.msgHistory[3]['content']"
              },
              {
                "alias": "outcome1",
                "path": "outputs.validatorLogs[0].validationResult.outcome"
              },
              {
                "alias": "outcome2",
                "path": "outputs.validatorLogs[1].validationResult.outcome"
              },
              {
                "alias": "outcome3",
                "path": "outputs.validatorLogs[2].validationResult.outcome"
              },
              {
                "alias": "outcome4",
                "path": "outputs.validatorLogs[3].validationResult.outcome"
              },
              {
                "alias": "outcome5",
                "path": "outputs.validatorLogs[4].validationResult.outcome"
              }
            ],
            "source": "output.value"
          }
        },
        {
          "id": "organize",
          "options": {
            "excludeByName": {
              "Duration": true,
              "Name": true,
              "Prompt": true,
              "Prompt 1": false,
              "Prompt 2": true,
              "Prompt 3": true,
              "Prompt 4": true,
              "Span ID": false,
              "Start time": true,
              "Trace Name": true,
              "Trace Service": true,
              "outcome1": true,
              "outcome2": true,
              "outcome3": true,
              "outcome4": true,
              "outcome5": true,
              "output.value": true,
              "traceIdHidden": true
            },
            "includeByName": {},
            "indexByName": {
              "Duration": 7,
              "LLM Response": 9,
              "Name": 5,
              "Prompt 1": 8,
              "Prompt 2": 10,
              "Prompt 3": 11,
              "Prompt 4": 12,
              "Span ID": 3,
              "Start time": 4,
              "Trace Name": 2,
              "Trace Service": 1,
              "outcome1": 13,
              "outcome2": 14,
              "outcome3": 15,
              "outcome4": 16,
              "outcome5": 17,
              "output.value": 6,
              "traceIdHidden": 0
            },
            "renameByName": {
              "Message History": "",
              "Prompt 1": "Prompt"
            }
          }
        }
      ],
      "type": "table"
    },
    {
      "datasource": {
        "type": "tempo",
        "uid": "P214B5B846CF3925F"
      },
      "description": "These occur when a runtime error is invoked and the Guard is not able to fulfill a request as exepected",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "thresholds"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "",
            "axisPlacement": "auto",
            "fillOpacity": 80,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "lineWidth": 1,
            "scaleDistribution": {
              "type": "linear"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": 0
              },
              {
                "color": "red",
                "value": 80
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 19
      },
      "id": 4,
      "options": {
        "barRadius": 0,
        "barWidth": 0.97,
        "fullHighlight": false,
        "groupWidth": 0.7,
        "legend": {
          "calcs": [],
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "orientation": "auto",
        "showValue": "auto",
        "stacking": "none",
        "tooltip": {
          "hideZeros": false,
          "mode": "single",
          "sort": "none"
        },
        "xTickLabelRotation": 0,
        "xTickLabelSpacing": 0
      },
      "pluginVersion": "12.2.0",
      "targets": [
        {
          "datasource": {
            "type": "tempo",
            "uid": "P214B5B846CF3925F"
          },
          "filters": [
            {
              "id": "9a2ba9ae",
              "operator": "=",
              "scope": "span"
            },
            {
              "id": "status",
              "operator": "=",
              "scope": "intrinsic",
              "tag": "status",
              "value": "error",
              "valueType": "keyword"
            },
            {
              "id": "span-name",
              "isCustomValue": false,
              "operator": "=",
              "scope": "span",
              "tag": "name",
              "value": [],
              "valueType": "string"
            }
          ],
          "hide": false,
          "limit": 20,
          "metricsQueryType": "range",
          "queryType": "traceqlSearch",
          "refId": "A",
          "serviceMapUseNativeHistograms": false,
          "tableType": "traces"
        }
      ],
      "title": "Guard Execution Errors",
      "transformations": [
        {
          "id": "calculateField",
          "options": {
            "mode": "reduceRow",
            "reduce": {
              "reducer": "count"
            },
            "replaceFields": true
          }
        }
      ],
      "type": "barchart"
    }
  ],
  "preload": false,
  "refresh": "",
  "schemaVersion": 42,
  "tags": [],
  "templating": {
    "list": []
  },
  "time": {
    "from": "now-5m",
    "to": "now"
  },
  "timepicker": {},
  "timezone": "",
  "title": "Guardrails Starter Dashboard",
  "uid": "dff9fb38-6dda-40ff-8e65-7b188d9f607a",
  "version": 8
}
```
