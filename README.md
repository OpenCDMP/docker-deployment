# OpenCDMP Docker Deployment

This repository provides an example configuration for deploying OpenCDMP with Docker and Docker Compose. By following the setup below, you can spin up a complete, containerized environment for OpenCDMP.

---

## Overview

**OpenCDMP** is an open and extensible software platform designed to simplify the management, monitoring, and maintenance of **Output Management Plans (OMPs)**, such as **Data Management Plans (DMPs)** and **Software Management Plans (SMPs)**. It provides a flexible and customizable environment that streamlines the complex processes involved in handling OMPs, ensuring efficiency, compliance, and collaboration across various projects and organizations. 
This **docker-deployment** repository contains Docker Compose files and supporting resources that demonstrate how to get OpenCDMP services up and running easily in containers.

---

## Prerequisites

1. **Docker** (latest recommended)  
   [Install Docker](https://docs.docker.com/get-docker/)

2. **Docker Compose**  
   [Install Docker Compose](https://docs.docker.com/compose/install/)

3. **Git** (to clone this repository)  
   [Install Git](https://git-scm.com/downloads)

---

## Repository Structure

Below is a brief overview of the key files and folders:

```
docker-deployment/
|── .env
|── docker-compose.yml
|── docker-compose.override.yml
|── deploy_opencdmp.sh
|── config-files/
 └── ...configuration files for each service...
```
- **`deploy_opencdmp.sh`** – A convenience script to deploy all containers for OpenCDMP.  
- **`.env`** – Example environment file containing env variables for containers.
- **`docker-compose.yml`** – Main Docker Compose file.
- **`docker-compose.override.yml`** – Override Compose file, with networks, port mappings, and volume configuration.

---

## Configuration

1. **Clone the Repository**
```bash
git clone https://github.com/OpenCDMP/docker-deployment.git
cd docker-deployment
```

2. **Adjust `.env` file**

3. **Review and Align Configuration Files**
  - The `config-files/` folder contains configuration files per service that you can adapt for your deployment.
  - Ensure these files match your .env settings and environment needs.

4. **Review Compose Files** 
  - Verify or modify any settings (e.g., exposed ports, volumes, service names) to fit your environment.

---

## Usage

For a straightforward deployment, simply run:

```bash
./deploy_opencdmp.sh
```

This script pulls necessary images (if not present) and starts the containers in the background. Once finished, you can verify the services are up and running via Docker logs or by visiting the relevant ports in your browser.
After the containers come up, navigate to `http://host.docker.internal:8081/`.
More information can be found in the docs here: https://opencdmp.github.io/getting-started/deployment/

---

## Storage

For storage all data are saved in the host at the `storage/` folder. Align `docker-compose.override.yml` based on you deployment's requirements.

---

## Logs and Troubleshooting

Logs are persisted at the `logs/` folder per service.

---

## License

OpenCDMP is released under the [EUPL 1.2 License](LICENSE).

---

## 🌐 **Contact**

For questions or support, please contact:

- **Email**: opencdmp at cite.gr
