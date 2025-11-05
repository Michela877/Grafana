# Progetti maven applicare questo al pom con zipkin

```bash
        <!--monioraggio-->
        <dependency>
            <groupId>io.micrometer</groupId>
            <artifactId>micrometer-tracing-bridge-brave</artifactId>
        </dependency>
        <dependency>
            <groupId>io.zipkin.reporter2</groupId>
            <artifactId>zipkin-reporter-brave</artifactId>
        </dependency>
        <!-- Spring Boot Actuator per metriche -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-actuator</artifactId>
        </dependency>
```

# Progetti maven applicare questo al application.yaml da cambiare il name servizi-service con il nome appropriato al servizio

```bash
management:
  endpoints:
    web:
      exposure:
        include: health, info, metrics, prometheus
  tracing:
    sampling:
      probability: 1.0
  zipkin:
    tracing:
      endpoint: http://tempo.monitoring.svc.cluster.local:9411/api/v2/spans

spring:
  servlet:
    multipart:
      max-file-size: 1024MB
      max-request-size: 1024MB
  cloud.azure.storage.blob.connection-string: ${BLOBSTORAGE_CONNECTION_STRING}
  application:
    name: servizi-service

logging:
  pattern:
    correlation: '[${spring.application.name:},%X{traceId:-},%X{spanId:-}]'

server:
  port: ${SERVER_PORT:8085}

loki:
  url: ${LOKI_URL:http://localhost:3100/loki/api/v1/push}

asv:
  datasource:
    corsi:
      enabled: true
```

# Progetti maven applicare questo al deployment.yaml backend

```bash
          env:
            - name: MANAGEMENT_ZIPKIN_TRACING_ENDPOINT
              value: "http://tempo.monitoring.svc.cluster.local:9411/api/v2/spans"
```

# Query da applicare al traceQL

visualizza tutti gli span con status 200

```bash
{ span.status = "200" }
```

visualizza tutti gli span con status ok

```bash
{ span.status = "200" || span.status = "201" || span.status = "202" || span.status = "204" || span.status = "206" }
```

visualizza tutti gli span con status error

```bash
{ span.status = "400" || span.status = "401" || span.status = "403" || span.status = "404" || span.status = "500" || span.status = "502" || span.status = "503" || span.status = "504" }
```