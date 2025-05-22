# Kubernetes RBAC Helm Chart

## Overview

This Helm chart provisions role-based access control (RBAC) resources in Kubernetes clusters. It dynamically creates appropriate ClusterRoles and ClusterRoleBindings based on the cluster environment (dev, stage, or prod), providing different permission levels for DevOps teams and developers.

## Features

- Environment-aware RBAC configuration
- Customizable role and group names
- Separate toggles for DevOps and Developer permissions
- Consistent permissions model across environments

## Access Matrix

| Environment | DevOps Team | Developers |
|-------------|-------------|------------|
| Dev         | Admin Access | Admin Access |
| Stage       | Admin Access | Read-Only Access |
| Prod        | Admin Access | Read-Only Access |

## Detailed Permissions

### DevOps Team
The DevOps team maintains admin-level access across all environments to facilitate cluster management, deployment processes, and troubleshooting.

#### Permissions (All Environments)
- Full access to all Kubernetes resources
- Ability to create, update, delete, and view all resources
- Access to cluster-wide configuration and settings

### Developer Team
Developer permissions vary by environment to balance productivity with security:

#### Dev Environment
In development environments, developers have admin-level access to support rapid development and testing:
- Full access to create, update, delete resources
- Access to deployments, pods, services, configmaps, and secrets
- Ability to manage networking resources like ingresses
- Complete control over jobs and cronjobs

#### Stage/Prod Environments
In stage and production environments, developers have read-only access:
- View-only access to most resources (get, list, watch)
- Limited access to pod logs for troubleshooting
- Ability to execute commands in pods (pods/exec) in staging only
- No permissions to modify any production resources

## Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `clusterStage` | Target environment (dev, stage, prod) | `"prod"` |
| `enableDevopsRbacs` | Enable RBAC for DevOps team | `true` |
| `enableDevelopersRbacs` | Enable RBAC for Developer team | `true` |

## Installation


```bash
# Add zhivotnoe
helm repo add zhivotnoe https://yazhivotnoe.github.io/charts/ && helm repo update

# Install for dev environment
helm install rbacs zhivotnoe/rbacs --set clusterStage=dev

# Install for staging environment
helm install rbacs zhivotnoe/rbacs --set clusterStage=stage

# Install for production environment
helm install rbacs zhivotnoe/rbacs --set clusterStage=prod
```

## Usage Examples

### Disable Developer RBAC

```bash
helm install rbacs zhivotnoe/rbacs \
  --set clusterStage=prod \
  --set enableDevelopersRbacs=false
```

### Disable DevOps RBAC

```bash
helm install rbacs zhivotnoe/rbacs \
  --set clusterStage=stage \
  --set enableDevopsRbacs=false
```

## Notes

- The chart uses Kubernetes ClusterRoles and ClusterRoleBindings, which are cluster-wide resources
- Both DevOps and Developer RBAC can be toggled independently using the `enableDevopsRbacs` and `enableDevelopersRbacs` values
- The configuration follows security best practices by restricting access in higher environments
- DevOps roles are intentionally privileged to enable infrastructure management
- Developer roles follow the principle of least privilege in stage and production

## Security Considerations

- Regularly audit the permissions granted by these roles
- Consider implementing additional controls like Pod Security Policies
- Ensure your authentication provider properly maps users to the correct groups
- Periodically review logs for unauthorized access attempts