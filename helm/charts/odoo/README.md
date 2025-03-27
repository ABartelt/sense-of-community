# Odoo Helm Chart

This Helm chart deploys Odoo with PostgreSQL HA, including:
- Odoo 18.0
- PostgreSQL HA for database
- Ingress configuration with TLS
- Persistent storage for Odoo data

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
    password: "your-postgres-password"

odoo:
  config:
    admin_passwd: "your-admin-password"  # Change this in production
```

3. Install the chart with dependencies:
```bash
helm install odoo ./odoo/helm/odoo -f my-values.yaml -n your-namespace
```

## Configuration

The following table lists the configurable parameters of the Odoo chart and their default values.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `global.domain` | Base domain for all services | `technotuev.de` |
| `odoo.image.repository` | Odoo image repository | `odoo` |
| `odoo.image.tag` | Odoo image tag | `18.0` |
| `odoo.hostname` | Odoo hostname | `odoo.technotuev.de` |
| `odoo.persistence.size` | Odoo data PVC size | `10Gi` |
| `odoo.config.addons_path` | Odoo addons path | `/mnt/extra-addons` |
| `odoo.config.admin_passwd` | Odoo admin password | `admin` |
| `postgresql-ha.auth.username` | PostgreSQL username | `odoo` |
| `postgresql-ha.auth.database` | PostgreSQL database | `postgres` |
| `postgresql-ha.primary.persistence.size` | PostgreSQL primary PVC size | `10Gi` |
| `postgresql-ha.read.replicaCount` | Number of PostgreSQL read replicas | `1` |

## Ingress Configuration

The chart configures ingress for Odoo:
- Hostname: `odoo.technotuev.de`
- TLS enabled with Let's Encrypt certificates
- Traefik Ingress Controller

## Secrets

The following secrets are required:
- `postgres-secrets`: Contains PostgreSQL credentials

## Volumes and ConfigMaps

The chart creates the following volumes and ConfigMaps:
- `odoo-data-pvc`: Persistent volume for Odoo data
- `odoo-config`: Contains Odoo configuration

## Benefits of the Architecture

1. **High Availability**:
   - PostgreSQL HA with automatic failover
   - Read replicas for database load balancing

2. **Data Safety**:
   - Persistent storage for Odoo data
   - Database replication

3. **Security**:
   - TLS encryption for all external access
   - Secrets management for sensitive data
   - Regular security updates through Bitnami charts

4. **Maintainability**:
   - Easy scaling options
   - Standardized configuration
   - Automated deployment

## Upgrading

To upgrade the deployment:
```bash
helm upgrade odoo ./odoo/helm/odoo -f my-values.yaml -n your-namespace
```

## Uninstallation

To uninstall the deployment:
```bash
helm uninstall odoo -n your-namespace
```

Note: This will not delete the PVCs. To delete the PVCs, you need to manually delete them:
```bash
kubectl delete pvc odoo-data-pvc postgresql-ha-postgresql-0 postgresql-ha-postgresql-1 -n your-namespace
``` 