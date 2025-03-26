# Community Services Helm Chart

This Helm chart deploys the community services including Pretix and ShiftPlanner with their dependencies.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+
- MicroK8s with the following addons enabled:
  - storage
  - ingress
  - cert-manager
  - metrics-server
  - prometheus
  - traefik

## Installation

1. Add the Bitnami repository:
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```

2. Create a namespace for the services:
```bash
kubectl create namespace community
```

3. Create a values file with your configuration:
```bash
cp values.yaml values.custom.yaml
# Edit values.custom.yaml with your specific configuration
```

4. Install the chart:
```bash
helm install community-services . -n community -f values.custom.yaml
```

## Configuration

The following table lists the configurable parameters of the chart and their default values.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `global.environment` | Environment name | `production` |
| `global.domain` | Domain name for services | `der-ttn.de` |
| `postgresql-ha.enabled` | Enable PostgreSQL HA | `true` |
| `redis-cluster.enabled` | Enable Redis Cluster | `true` |
| `keycloak.enabled` | Enable Keycloak | `true` |
| `pretix.enabled` | Enable Pretix | `true` |

## Services

### PostgreSQL HA
- High-availability PostgreSQL cluster
- Automatic backups
- Metrics enabled for Prometheus

### Redis Cluster
- Redis cluster with master and replicas
- Authentication enabled
- Metrics enabled for Prometheus

### Keycloak
- Identity and access management
- Uses external PostgreSQL database
- Ingress configured with TLS
- Metrics enabled for Prometheus

### Pretix
- Event ticketing system
- Uses external PostgreSQL and Redis
- Ingress configured with TLS

## Backup and Restore

### PostgreSQL Backups
The PostgreSQL HA chart includes built-in backup functionality. Backups are stored in the configured storage location.

### Redis Backups
Redis cluster includes snapshot functionality for data persistence.

## Monitoring

All services expose metrics that can be scraped by Prometheus:
- PostgreSQL metrics
- Redis metrics
- Keycloak metrics
- Pretix metrics

## Ingress

All services are configured with Ingress and TLS:
- Pretix: `https://${PRETIX_HOSTNAME}`
- Keycloak: `https://auth.der-ttn.de`

## Storage

All persistent storage uses the `microk8s-hostpath` storage class. Adjust the storage sizes in the values file according to your needs. 