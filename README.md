# OpenCDMP Docker example

This repository holds an example Docker Compose setup that starts a complete [OpenCDMP](https://github.com/OpenCDMP/OpenCDMP) installation on one machine: the webapp, the API service, the notification and annotation services, a DOCX and an RDA JSON file transformer, the RDA maDMP evaluator, the Zenodo deposit service, PostgreSQL, Elasticsearch, RabbitMQ, Keycloak, the Gotenberg PDF service, and an Nginx proxy in front of them.

> **For local evaluation only.** Every password is a demo default, Keycloak runs in development mode, and the application is served over plain HTTP. Before real users sign in, work through [Before going to production](https://opencdmp.github.io/deployment/install/production/).

The full walkthrough is in the [Installation guide](https://opencdmp.github.io/deployment/install/).

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) with [Docker Compose](https://docs.docker.com/compose/install/) version 2 (the `docker compose` command).
- [Git](https://git-scm.com/downloads), to clone the repository.
- About 8 GB of memory for the containers; they can grow to about 16 GB.
- Internet access on the first start, to pull the images and to download the `analysis-icu` plugin of Elasticsearch.

## Files

```
docker-deployment/
├── .env                          # registries, image versions, ports, paths, Elasticsearch passwords
├── docker-compose.yml            # the services and their images
├── docker-compose.override.yml   # ports, volumes, networks, health checks, memory limits
└── config-files/                 # configuration of each service (proxy, keycloak, postgres, rabbitmq, elk, opencdmp/<service>)
```

The containers keep their data in `storage/` and write their logs to `logs/`, next to these files.

## Start

```bash
git clone https://github.com/OpenCDMP/docker-deployment.git
cd docker-deployment
docker compose up -d
```

The first start takes a few minutes: Elasticsearch installs its `analysis-icu` plugin, Keycloak imports the `OpenCDMP` realm, and the API service creates the database schema. The containers start in dependency order on their own. Check them with `docker compose ps`; the API service and the plugins report `healthy` once they are ready.

## Open the application

Open **http://opencdmp.localhost:8180/** and sign in with the demo administrator of the imported realm:

| | User | Password |
| --- | --- | --- |
| OpenCDMP | `opencdmp-admin` | `admin` |
| Keycloak admin console, at http://opencdmp.localhost:8180/auth/ | `keycloak-admin` | `admin` |

These accounts and passwords are demo defaults: change them before anyone else can reach the installation.

`opencdmp.localhost` needs no setup: browsers resolve every `*.localhost` name to your own machine, and inside Docker the proxy answers to the same name. If your browser cannot open it, add `127.0.0.1 opencdmp.localhost` to your hosts file.

## Adapt the example

- **Passwords.** `ELASTIC_PASSWORD` (the Elasticsearch `elastic` superuser) and `ELASTIC_API_PASSWORD` (the user the API service connects as) are in `.env`; the Keycloak administrator (`KC_BOOTSTRAP_ADMIN_USERNAME`, `KC_BOOTSTRAP_ADMIN_PASSWORD`) is in `config-files/keycloak/keycloak.env`. All of them take effect on the first start only, so change them before it. [Replace the demo secrets](https://opencdmp.github.io/deployment/install/production/#replace-the-demo-secrets) lists the others, including the client secrets of the realm.
- **Ports.** The application is published on port `8180` (`PROXY_APP_PORT`) and PostgreSQL on `127.0.0.1:5433` (`POSTGRES_PORT`). To serve the application on another port or host name, replace `8180` or `opencdmp.localhost` in `.env`, in the files under `config-files/`, and in `docker-compose.override.yml`.
- **Services.** The files under `config-files/` configure each service; see [Configuration](https://opencdmp.github.io/deployment/configuration/), [Keycloak setup](https://opencdmp.github.io/deployment/configuration/keycloak/), and [Registering plugin services](https://opencdmp.github.io/deployment/configuration/plugin-services/). Publishing to Zenodo needs your own Zenodo (sandbox) application in `config-files/opencdmp/zenodo/config/app-test.env`; see [Deposit services](https://opencdmp.github.io/deployment/configuration/backend/deposit/).

## Logs and troubleshooting

Each service logs to its own folder under `logs/`. See [Logging and monitoring](https://opencdmp.github.io/deployment/configuration/logging-and-monitoring/) and [Troubleshooting a deployment](https://opencdmp.github.io/deployment/troubleshooting/).

## Start over or upgrade

- To discard the installation, run `docker compose down`, then delete the `storage/` and `logs/` folders.
- To move to a new version, follow the [upgrade guide](https://opencdmp.github.io/deployment/install/upgrade/).

## License

This example is licensed under the [European Union Public Licence (EUPL) v1.2](LICENSE).
