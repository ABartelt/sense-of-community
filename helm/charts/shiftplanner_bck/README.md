# ShiftPlanner Helm Chart

This Helm chart deploys the ShiftPlanner application stack, including:
- Keycloak for authentication
- PostgreSQL HA for database
- Redis Cluster for caching
- ShiftPlanner API
- ShiftPlanner Client

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
    adminPassword: "your-admin-password"
    keycloakPassword: "your-keycloak-db-password"
    muddiUser: "your-muddi-user"
    muddiPassword: "your-muddi-password"
    muddiDb: "your-muddi-db"
```

3. Install the chart with dependencies:
```bash
helm install shiftplanner ./ShiftPlanner/helm/shiftplanner -f my-values.yaml -n your-namespace
```

## Configuration

The following table lists the configurable parameters of the ShiftPlanner chart and their default values.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `global.domain` | Base domain for all services | `technotuev.de` |
| `postgresql-ha.auth.username` | PostgreSQL username | `keycloak` |
| `postgresql-ha.auth.database` | PostgreSQL database | `keycloak` |
| `postgresql-ha.primary.persistence.size` | PostgreSQL primary PVC size | `10Gi` |
| `postgresql-ha.read.replicaCount` | Number of PostgreSQL read replicas | `1` |
| `keycloak.auth.adminUser` | Keycloak admin username | `admin` |
| `keycloak.ingress.hostname` | Keycloak hostname | `connect.technotuev.de` |
| `redis-cluster.master.persistence.size` | Redis master PVC size | `5Gi` |
| `redis-cluster.replica.replicaCount` | Number of Redis replicas | `1` |
| `shiftPlannerApi.image.repository` | API image repository | `ghcr.io/muddi-markt/shiftplanner/api` |
| `shiftPlannerApi.image.tag` | API image tag | `v1.2` |
| `shiftPlannerClient.image.repository` | Client image repository | `ghcr.io/muddi-markt/shiftplanner/client` |
| `shiftPlannerClient.image.tag` | Client image tag | `v1.2` |

## Ingress Configuration

The chart configures three ingress resources:
1. Keycloak: `connect.technotuev.de`
2. API: `api-doppelschicht.technotuev.de`
3. Client: `doppelschicht.technotuev.de`

All ingress resources are configured with TLS using Let's Encrypt certificates.

## Secrets

The following secrets are required:
- `postgres-secrets`: Contains PostgreSQL and Muddi application credentials

## Volumes and ConfigMaps

The chart creates the following volumes and ConfigMaps:
- `client-config`: Contains client customization files
- `postgres-backup-pvc`: Persistent volume for database backups

## Database Backups

The chart includes an automated backup system:
- Hourly backups of both Keycloak and Muddi databases
- 7-day retention period
- Backups stored in `/var/backup`
- Automatic cleanup of old backups

## Benefits of the Architecture

1. **High Availability**:
   - PostgreSQL HA with automatic failover
   - Redis Cluster for distributed caching
   - Multiple replicas for both databases

2. **Data Safety**:
   - Regular automated backups
   - Persistent storage for all components
   - Backup retention policy

3. **Performance**:
   - Redis Cluster for improved caching
   - Read replicas for database load balancing
   - Optimized resource allocation

4. **Security**:
   - TLS encryption for all external access
   - Secrets management for sensitive data
   - Regular security updates through Bitnami charts

5. **Maintainability**:
   - Automated backup system
   - Easy scaling options
   - Standardized configuration

## Upgrading

To upgrade the deployment:
```bash
helm upgrade shiftplanner ./ShiftPlanner/helm/shiftplanner -f my-values.yaml -n your-namespace
```

## Uninstallation

To uninstall the deployment:
```bash
helm uninstall shiftplanner -n your-namespace
```

Note: This will not delete the PVCs. To delete the PVCs, you need to manually delete them:
```bash
kubectl delete pvc postgresql-ha-postgresql-0 postgresql-ha-postgresql-1 postgres-backup-pvc -n your-namespace
``` 