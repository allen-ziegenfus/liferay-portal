import .context_variables as cv
import crossplane_provider_kubernetes.v1alpha1 as kubernetes
import crossplane_provider_upjet_gcp.v1beta1.storage_gcp_upbound_io_v1beta1_bucket as storage_bucket
import k8s.api.core.v1 as k8s_core
import k8s.api.rbac.v1 as k8s_rbac

get_items = lambda obs: any, vars: {str:any} -> [any] {
    _backup = vars.get("backup") or {}
    _backup_items: [any] = []

    if _backup.get("enabled"):
        _backup_vault_labels = (vars.get("labels") or {}) | {"is-backup-vault": "true"}

        _backup_items += [storage_bucket.Bucket {
            metadata = {
                annotations = {"crossplane.io/composition-resource-name": "{}-vault".format(vars.get("baseName") or "")}
                labels = _backup_vault_labels
                name = "{}-vault".format(vars.get("baseName") or "")
            }
            spec = {
                forProvider = {
                    forceDestroy = vars.get("forceDestroy") or False
                    labels = _backup_vault_labels
                    lifecycleRule = [{
                        action = [{type = "Delete"}]
                        condition = [{age = (_backup.get("retentionDays") or 30) + 2}]
                    }]
                    location = _backup.get("region") or vars.get("region") or ""
                    storageClass = _backup.get("storageClass") or "NEARLINE"
                    uniformBucketLevelAccess = True
                }
                if vars.get("cmkEnabled"):
                    forProvider.encryption = [{
                        defaultKmsKeyName = vars.get("cmkKeyName") or ""
                    }]
                managementPolicies = vars.get("managementPolicies") or ["*"]
            }
        }]

        _backup_sa = k8s_core.ServiceAccount {
            metadata = {
                labels = vars.get("labels") or {}
                name = "backup-create-service-account"
                namespace = vars.get("namespace") or ""
            }
        }

        _backup_rb = k8s_rbac.RoleBinding {
            metadata = {
                labels = vars.get("labels") or {}
                name = "backup-create-role-binding"
                namespace = vars.get("namespace") or ""
            }
            roleRef = {
                apiGroup = "rbac.authorization.k8s.io"
                kind = "ClusterRole"
                name = "backup-create-cluster-role"
            }
            subjects = [{
                kind = "ServiceAccount"
                name = "backup-create-service-account"
                namespace = vars.get("namespace") or ""
            }]
        }

        _backup_items += [
            kubernetes.Object {
                metadata = {
                    annotations = {"crossplane.io/composition-resource-name": "backup-create-service-account"}
                    labels = vars.get("labels") or {}
                    name = "backup-create-service-account"
                }
                spec = {
                    forProvider = {"manifest": _backup_sa}
                    managementPolicy = vars.get("managementPolicy") or "Default"
                }
            }
            kubernetes.Object {
                metadata = {
                    annotations = {"crossplane.io/composition-resource-name": "backup-create-role-binding"}
                    labels = vars.get("labels") or {}
                    name = "backup-create-role-binding"
                }
                spec = {
                    forProvider = {"manifest": _backup_rb}
                    managementPolicy = vars.get("managementPolicy") or "Default"
                }
            }
        ]

    _backup_items
}

_vars = {
    "backup": cv.backup
    "baseName": cv.baseName
    "cmkEnabled": cv.cmkEnabled
    "cmkKeyName": cv.cmkKeyName
    "forceDestroy": cv.forceDestroy
    "labels": cv.labels
    "managementPolicies": cv.managementPolicies
    "managementPolicy": cv.managementPolicy
    "namespace": cv.namespace
    "region": cv.region
}

items = {"items": get_items(cv.obs, _vars)}
