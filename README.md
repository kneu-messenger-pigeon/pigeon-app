# Pigeon app
[![CI/CD - integration build, testing and deploy](https://github.com/kneu-messenger-pigeon/pigeon-app/actions/workflows/ci-cd.yaml/badge.svg)](https://github.com/kneu-messenger-pigeon/pigeon-app/actions/workflows/ci-cd.yaml)
[![Deploy production](https://github.com/kneu-messenger-pigeon/pigeon-app/actions/workflows/production-deploy.yaml/badge.svg)](https://github.com/kneu-messenger-pigeon/pigeon-app/actions/workflows/production-deploy.yaml)

Implementation of a bot that sends students notifications with new scores added to the University's electronic journal (based on the engine "Dekanat").
Architecturally it is designed as a cross-platform solution (for any messanger). It provides an internal event bus (Kafka) with new scores events, score data  REST API, and a framework to make a bot for any messengers. For now, only the Telegram bot is implemented.

## Key points
 1. Microservice architecture
 2. Event-based architecture: Kafka event bus and SQS.
 3. REST API
 4. 100% Unit test coverage
 5. Automatical integration testing. Includes browser automatization for JavaScript.
 6. CI/CD flow:
    -  Microservice unit test
    -  Microservice image build
    -  Build new application docker-compose.yml with latest sha256-hash of docker-images
    -  Test application build with integration test
    -  Commit new image hashes into docker-conpose.prod.yml
    -  Deploy prod
  7. Reliability monitoring: service health check-pinger based connected to docker health check and send health-signal to healthcheck.io service.
  8. Reliability and stability monitoring: VictoriaMetrics with Grafana dashboard and alerting by key product metrics.
  9. Codecov report for code coverage analysis.

## Microservices
[comment]: <> (Start service list)

| Service | Release status | Codecov |
|---------|----------------|---------|
| [gateway](https://github.com/kneu-messenger-pigeon/gateway) | [![Release](https://github.com/kneu-messenger-pigeon/gateway/actions/workflows/release.yaml/badge.svg)](https://github.com/kneu-messenger-pigeon/gateway/actions/workflows/release.yaml) |  |
| [init-kafka](https://github.com/kneu-messenger-pigeon/init-kafka) | [![Release](https://github.com/kneu-messenger-pigeon/init-kafka/actions/workflows/release.yaml/badge.svg)](https://github.com/kneu-messenger-pigeon/init-kafka/actions/workflows/release.yaml) | [![codecov](https://codecov.io/gh/kneu-messenger-pigeon/init-kafka/branch/main/graph/badge.svg?token=6MFQNOFBIT)](https://codecov.io/gh/kneu-messenger-pigeon/init-kafka) |
| [secondary-db-watcher](https://github.com/kneu-messenger-pigeon/secondary-db-watcher) | [![Release](https://github.com/kneu-messenger-pigeon/secondary-db-watcher/actions/workflows/release.yaml/badge.svg)](https://github.com/kneu-messenger-pigeon/secondary-db-watcher/actions/workflows/release.yaml) | [![codecov](https://codecov.io/gh/kneu-messenger-pigeon/secondary-db-watcher/branch/main/graph/badge.svg?token=HYI5IYUXND)](https://codecov.io/gh/kneu-messenger-pigeon/secondary-db-watcher) |
| [secondary-db-disciplines-importer](https://github.com/kneu-messenger-pigeon/secondary-db-disciplines-importer) | [![Release](https://github.com/kneu-messenger-pigeon/secondary-db-disciplines-importer/actions/workflows/release.yaml/badge.svg)](https://github.com/kneu-messenger-pigeon/secondary-db-disciplines-importer/actions/workflows/release.yaml) | [![codecov](https://codecov.io/gh/kneu-messenger-pigeon/secondary-db-disciplines-importer/branch/main/graph/badge.svg?token=GEAF4VU2NV)](https://codecov.io/gh/kneu-messenger-pigeon/secondary-db-disciplines-importer) |
| [secondary-db-lessons-importer](https://github.com/kneu-messenger-pigeon/secondary-db-lessons-importer) | [![Release](https://github.com/kneu-messenger-pigeon/secondary-db-lessons-importer/actions/workflows/release.yaml/badge.svg)](https://github.com/kneu-messenger-pigeon/secondary-db-lessons-importer/actions/workflows/release.yaml) | [![codecov](https://codecov.io/gh/kneu-messenger-pigeon/secondary-db-lessons-importer/branch/main/graph/badge.svg?token=ZTYOWR0HRO)](https://codecov.io/gh/kneu-messenger-pigeon/secondary-db-lessons-importer) |
| [secondary-db-scores-importer](https://github.com/kneu-messenger-pigeon/secondary-db-scores-importer) | [![Release](https://github.com/kneu-messenger-pigeon/secondary-db-scores-importer/actions/workflows/release.yaml/badge.svg)](https://github.com/kneu-messenger-pigeon/secondary-db-scores-importer/actions/workflows/release.yaml) | [![codecov](https://codecov.io/gh/kneu-messenger-pigeon/secondary-db-scores-importer/branch/main/graph/badge.svg?token=GFH2336CCW)](https://codecov.io/gh/kneu-messenger-pigeon/secondary-db-scores-importer) |
| [realtime-capture](https://github.com/kneu-messenger-pigeon/realtime-capture) | [![Release](https://github.com/kneu-messenger-pigeon/realtime-changes-event-sender/actions/workflows/release.yaml/badge.svg)](https://github.com/kneu-messenger-pigeon/realtime-changes-event-sender/actions/workflows/release.yaml) | [![codecov](https://codecov.io/gh/kneu-messenger-pigeon/realtime-capture/graph/badge.svg?token=3XFR44LX9B)](https://codecov.io/gh/kneu-messenger-pigeon/realtime-capture) |
| [realtime-importer](https://github.com/kneu-messenger-pigeon/realtime-importer) | [![Release](https://github.com/kneu-messenger-pigeon/realtime-importer/actions/workflows/release.yaml/badge.svg)](https://github.com/kneu-messenger-pigeon/realtime-importer/actions/workflows/release.yaml) | [![codecov](https://codecov.io/gh/kneu-messenger-pigeon/realtime-importer/branch/main/graph/badge.svg?token=1N19RLKSQF)](https://codecov.io/gh/kneu-messenger-pigeon/realtime-importer) |
| [storage-writer](https://github.com/kneu-messenger-pigeon/storage-writer) | [![Release](https://github.com/kneu-messenger-pigeon/storage-writer/actions/workflows/release.yaml/badge.svg)](https://github.com/kneu-messenger-pigeon/storage-writer/actions/workflows/release.yaml) | [![codecov](https://codecov.io/gh/kneu-messenger-pigeon/storage-writer/branch/main/graph/badge.svg?token=Z3VCW3EHF7)](https://codecov.io/gh/kneu-messenger-pigeon/storage-writer) |
| [score-storage-api](https://github.com/kneu-messenger-pigeon/score-storage-api) | [![Release](https://github.com/kneu-messenger-pigeon/score-storage-api/actions/workflows/release.yaml/badge.svg)](https://github.com/kneu-messenger-pigeon/score-storage-api/actions/workflows/release.yaml) | [![codecov](https://codecov.io/gh/kneu-messenger-pigeon/score-storage-api/branch/main/graph/badge.svg?token=JV3ANYCWB0)](https://codecov.io/gh/kneu-messenger-pigeon/score-storage-api) |
| [authorizer](https://github.com/kneu-messenger-pigeon/authorizer) | [![Release](https://github.com/kneu-messenger-pigeon/authorizer/actions/workflows/release.yaml/badge.svg)](https://github.com/kneu-messenger-pigeon/authorizer/actions/workflows/release.yaml) | [![codecov](https://codecov.io/gh/kneu-messenger-pigeon/authorizer/branch/main/graph/badge.svg?token=VI5R8LW1AQ)](https://codecov.io/gh/kneu-messenger-pigeon/authorizer) |
| [telegram-app](https://github.com/kneu-messenger-pigeon/telegram-app) | [![Release](https://github.com/kneu-messenger-pigeon/telegram-app/actions/workflows/release.yaml/badge.svg)](https://github.com/kneu-messenger-pigeon/telegram-app/actions/workflows/release.yaml) | [![codecov](https://codecov.io/gh/kneu-messenger-pigeon/telegram-app/branch/main/graph/badge.svg?token=MFL0ALRHTI)](https://codecov.io/gh/kneu-messenger-pigeon/telegram-app) |
| [healthcheck-pinger](https://github.com/kneu-messenger-pigeon/healthcheck-pinger) | [![Release](https://github.com/kneu-messenger-pigeon/healthcheck-pinger/actions/workflows/release.yaml/badge.svg)](https://github.com/kneu-messenger-pigeon/healthcheck-pinger/actions/workflows/release.yaml) | [![codecov](https://codecov.io/github/kneu-messenger-pigeon/healthcheck-pinger/branch/main/graph/badge.svg?token=yMS8HoUIPK)](https://codecov.io/github/kneu-messenger-pigeon/healthcheck-pinger) |

[comment]: <> (End service list)

## Packages

[comment]: <> (Start packages list)

| Package | Test status | Codecov |
|---------|-------------|---------|
| [victoria-metrics-init](https://github.com/kneu-messenger-pigeon/victoria-metrics-init) | [![Test](https://github.com/kneu-messenger-pigeon/victoria-metrics-init/actions/workflows/test.yaml/badge.svg)](https://github.com/kneu-messenger-pigeon/victoria-metrics-init/actions/workflows/test.yaml) | [![codecov](https://codecov.io/gh/kneu-messenger-pigeon/victoria-metrics-init/graph/badge.svg?token=VxRIsL6Kej)](https://codecov.io/gh/kneu-messenger-pigeon/victoria-metrics-init) |
| [score-client](https://github.com/kneu-messenger-pigeon/score-client) | [![Test](https://github.com/kneu-messenger-pigeon/score-client/actions/workflows/test.yaml/badge.svg)](https://github.com/kneu-messenger-pigeon/score-client/actions/workflows/test.yaml) | [![codecov](https://codecov.io/gh/kneu-messenger-pigeon/score-client/branch/main/graph/badge.svg?token=GJNJLNLCCG)](https://codecov.io/gh/kneu-messenger-pigeon/score-client) |
| [score-api](https://github.com/kneu-messenger-pigeon/score-api) | [![Test](https://github.com/kneu-messenger-pigeon/score-api/actions/workflows/test.yaml/badge.svg)](https://github.com/kneu-messenger-pigeon/score-api/actions/workflows/test.yaml) | [![codecov](https://codecov.io/gh/kneu-messenger-pigeon/score-api/branch/main/graph/badge.svg?token=LJQQU7MSW9)](https://codecov.io/gh/kneu-messenger-pigeon/score-api) |
| [fileStorage](https://github.com/kneu-messenger-pigeon/fileStorage) | [![Test](https://github.com/kneu-messenger-pigeon/fileStorage/actions/workflows/test.yaml/badge.svg)](https://github.com/kneu-messenger-pigeon/fileStorage/actions/workflows/test.yaml) | [![codecov](https://codecov.io/gh/kneu-messenger-pigeon/fileStorage/branch/main/graph/badge.svg?token=XW2SKJNDJ2)](https://codecov.io/gh/kneu-messenger-pigeon/fileStorage) |
| [events](https://github.com/kneu-messenger-pigeon/events) | [![.github/workflows/test.yaml](https://github.com/kneu-messenger-pigeon/events/actions/workflows/test.yaml/badge.svg)](https://github.com/kneu-messenger-pigeon/events/actions/workflows/test.yaml) | [![codecov](https://codecov.io/gh/kneu-messenger-pigeon/events/branch/main/graph/badge.svg?token=65FYMUI8KW)](https://codecov.io/gh/kneu-messenger-pigeon/events) |
| [dekanat-events](https://github.com/kneu-messenger-pigeon/dekanat-events) | [![Test](https://github.com/kneu-messenger-pigeon/dekanat-events/actions/workflows/test.yaml/badge.svg)](https://github.com/kneu-messenger-pigeon/dekanat-events/actions/workflows/test.yaml) | [![codecov](https://codecov.io/gh/kneu-messenger-pigeon/dekanat-events/graph/badge.svg?token=ELCOmE65Vt)](https://codecov.io/gh/kneu-messenger-pigeon/dekanat-events) |
| [client-framework](https://github.com/kneu-messenger-pigeon/client-framework) | [![Test](https://github.com/kneu-messenger-pigeon/client-framework/actions/workflows/test.yaml/badge.svg)](https://github.com/kneu-messenger-pigeon/client-framework/actions/workflows/test.yaml) | [![codecov](https://codecov.io/gh/kneu-messenger-pigeon/client-framework/branch/main/graph/badge.svg?token=DJJL96ZCED)](https://codecov.io/gh/kneu-messenger-pigeon/client-framework) |
| [authorizer-client](https://github.com/kneu-messenger-pigeon/authorizer-client) | [![Test](https://github.com/kneu-messenger-pigeon/authorizer-client/actions/workflows/test.yaml/badge.svg)](https://github.com/kneu-messenger-pigeon/authorizer-client/actions/workflows/test.yaml) | [![codecov](https://codecov.io/gh/kneu-messenger-pigeon/authorizer-client/branch/main/graph/badge.svg?token=72G31R0CBU)](https://codecov.io/gh/kneu-messenger-pigeon/authorizer-client) |
| [berejant/go-kneu](https://github.com/berejant/go-kneu) | [![Test](https://github.com/berejant/go-kneu/actions/workflows/test.yaml/badge.svg)](https://github.com/berejant/go-kneu/actions/workflows/test.yaml) | [![codecov](https://codecov.io/gh/berejant/go-kneu/branch/main/graph/badge.svg?token=H5FUKIITQJ)](https://codecov.io/gh/berejant/go-kneu) |

[comment]: <> (End packages list)

### References

 - [Codecov report page](https://app.codecov.io/gh/kneu-messenger-pigeon)
