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

# Sense of Community Helm Chart

This unified Helm chart deploys all community applications and their shared infrastructure, including:
- Shared PostgreSQL HA database
- Shared Redis Cluster for caching
- Shared Keycloak for authentication
- Pretix for ticket management
- ShiftPlanner for shift planning
- Odoo for business management

## Prerequisites

- Kubernetes 1.19+
- Helm 3.0+
- Traefik Ingress Controller with Let's Encrypt support

## Installation

1. Add the Bitnami repository:
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```

2. Create a values file (e.g., `my-values.yaml`) with your configuration:
```yaml
secrets:
  postgres:
    password: "your-shared-postgres-password"
  redis:
    password: "your-shared-redis-password"
  keycloak:
    adminPassword: "your-keycloak-admin-password"
    clientSecret: "your-keycloak-client-secret"

# Enable/disable applications as needed
pretix:
  enabled: true
shiftplanner:
  enabled: true
odoo:
  enabled: true
```

3. Install the chart with dependencies:
```bash
helm install sense-of-community ./helm/sense-of-community -f my-values.yaml -n your-namespace
```

## Configuration

The following table lists the main configurable parameters of the chart and their default values.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `global.domain` | Base domain for all services | `technotuev.de` |
| `postgresql-ha.enabled` | Enable shared PostgreSQL | `true` |
| `postgresql-ha.auth.username` | Shared PostgreSQL username | `shared` |
| `postgresql-ha.primary.persistence.size` | PostgreSQL primary PVC size | `20Gi` |
| `redis-cluster.enabled` | Enable shared Redis | `true` |
| `redis-cluster.master.persistence.size` | Redis master PVC size | `10Gi` |
| `keycloak.enabled` | Enable shared Keycloak | `true` |
| `keycloak.auth.adminUser` | Keycloak admin username | `admin` |
| `keycloak.ingress.hostname` | Keycloak hostname | `connect.technotuev.de` |
| `pretix.enabled` | Enable Pretix | `true` |
| `pretix.hostname` | Pretix hostname | `tickets.technotuev.de` |
| `shiftplanner.enabled` | Enable ShiftPlanner | `true` |
| `shiftplanner.hostname` | ShiftPlanner hostname | `doppelschicht.technotuev.de` |
| `odoo.enabled` | Enable Odoo | `true` |
| `odoo.hostname` | Odoo hostname | `odoo.technotuev.de` |

## Architecture

The chart implements a shared infrastructure approach:

1. **Shared Database**:
   - PostgreSQL HA with automatic failover
   - Read replicas for load balancing
   - Separate databases for each application

2. **Shared Caching**:
   - Redis Cluster for distributed caching
   - Replicas for high availability
   - Shared across all applications

3. **Shared Authentication**:
   - Keycloak for centralized authentication
   - TLS-enabled ingress
   - Client-specific realms

4. **Applications**:
   - Independent deployment of each application
   - Shared infrastructure resources
   - Configurable enable/disable per application

## Benefits

1. **Resource Efficiency**:
   - Shared infrastructure reduces resource usage
   - Centralized management of common services
   - Optimized storage allocation

2. **High Availability**:
   - Database failover and replication
   - Distributed caching
   - Load balancing across replicas

3. **Security**:
   - Centralized authentication
   - TLS encryption for all services
   - Secrets management

4. **Maintainability**:
   - Single chart for all applications
   - Consistent configuration
   - Easy scaling and updates

## Upgrading

To upgrade the deployment:
```bash
helm upgrade sense-of-community ./helm/sense-of-community -f my-values.yaml -n your-namespace
```

## Uninstallation

To uninstall the deployment:
```bash
helm uninstall sense-of-community -n your-namespace
```

Note: This will not delete the PVCs. To delete the PVCs, you need to manually delete them:
```bash
kubectl delete pvc -l app.kubernetes.io/instance=sense-of-community -n your-namespace
``` 