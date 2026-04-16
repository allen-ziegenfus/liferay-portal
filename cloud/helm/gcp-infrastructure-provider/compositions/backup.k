import .context_variables as cv
import crossplane_provider_kubernetes.v1alpha1 as kubernetes
import crossplane_provider_upjet_gcp.v1beta1.storage_gcp_upbound_io_v1beta1_bucket as storage_bucket
import k8s.api.core.v1 as k8s_core
import k8s.api.rbac.v1 as k8s_rbac

_items: [any] = []

if cv.backup.enabled:
    _backup_vault_labels = {**cv.labels, "is-backup-vault": "true"}

    _items += [storage_bucket.Bucket {
        metadata = {
            annotations = {"gotemplating.fn.crossplane.io/composition-resource-name": "{}-vault".format(cv.baseName)}
            labels = _backup_vault_labels
            name = "{}-vault".format(cv.baseName)
        }
        spec = {
            forProvider = {
                forceDestroy = cv.forceDestroy
                if cv.cmkEnabled:
                    encryption = [{
                        defaultKmsKeyName = cv.cmkKeyName
                    }]
                labels = _backup_vault_labels
                lifecycleRule = [{
                    action = [{"type": "Delete"}]
                    condition = [{"age": cv.backup.retentionDays + 2}]
                }]
                location = cv.backup.get("region") or cv.region
                storageClass = cv.backup.storageClass
                uniformBucketLevelAccess = True
            }
            managementPolicies = cv.managementPolicies
        }
    }]

    _backup_sa = k8s_core.ServiceAccount {
        metadata = {
            labels = cv.labels
            name = "backup-create-service-account"
            namespace = cv.namespace
        }
    }

    _backup_rb = k8s_rbac.RoleBinding {
        metadata = {
            labels = cv.labels
            name = "backup-create-role-binding"
            namespace = cv.namespace
        }
        roleRef = {
            apiGroup = "rbac.authorization.k8s.io"
            kind = "ClusterRole"
            name = "backup-create-cluster-role"
        }
        subjects = [{
            kind = "ServiceAccount"
            name = "backup-create-service-account"
            namespace = cv.namespace
        }]
    }

    _items += [kubernetes.Object {
        metadata = {
            annotations = {"gotemplating.fn.crossplane.io/composition-resource-name": "backup-create-service-account"}
            labels = cv.labels
            name = "backup-create-service-account"
        }
        spec = {
            forProvider = {"manifest": _backup_sa}
            managementPolicy = cv.managementPolicy
        }
    }]

    _items += [kubernetes.Object {
        metadata = {
            annotations = {"gotemplating.fn.crossplane.io/composition-resource-name": "backup-create-role-binding"}
            labels = cv.labels
            name = "backup-create-role-binding"
        }
        spec = {
            forProvider = {"manifest": _backup_rb}
            managementPolicy = cv.managementPolicy
        }
    }]

items = {"items": _items}
