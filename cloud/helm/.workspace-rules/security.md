---

alwaysApply: true
description: Pod security and IAM rules for Liferay cloud/helm workloads
globs: *

---

# Security Rules

## Pod / Container Security

Every container (including init containers) must have:

```yaml
securityContext:
    allowPrivilegeEscalation: false
    capabilities:
        drop:
            -   ALL
    runAsNonRoot: true
    runAsUser: 1000
    seccompProfile:
        type: RuntimeDefault
```

- Never use privileged containers
- Use read-only root filesystem where possible
- Enforce Kubernetes Pod Security `Restricted` profile on application namespaces

## IAM / Credentials

- Use Workload Identity (GCP) or IRSA (AWS) for pod credentials — never static keys in secrets
- Never share service accounts across workloads
- Bind permissions at the resource level (bucket, database) — not project/account level
- No wildcard (`*`) IAM actions
- Sync secrets via External Secrets Operator — never in `env` blocks or ConfigMaps directly

## Network

- Private subnets only for all nodes
- Default-deny ingress/egress NetworkPolicies
- Traffic to managed services must stay within private networks (VPC peering, PSC, Private Google Access)

## Images

- Pin images to specific tags or digests — no `latest` in production
- For AWS Marketplace: all images must be scanned and sourced from approved registries