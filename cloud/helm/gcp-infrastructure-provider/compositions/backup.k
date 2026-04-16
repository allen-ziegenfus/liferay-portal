import .context_variables as cv
import crossplane_provider_kubernetes.v1alpha1 as kubernetes
import crossplane_provider_upjet_gcp.v1beta1.storage_gcp_upbound_io_v1beta1_bucket as storage_bucket
import k8s.api.core.v1 as k8s_core

_backup_items: [any] = []

if cv.backup.get("enabled"):
    _backup_items += [storage_bucket.Bucket {
        metadata = {
            annotations = {"crossplane.io/composition-resource-name": "liferay-gcs-backup"}
            labels = cv.backupTargetLabels
            name = "{}-backup".format(cv.baseName)
        }
        spec = {
            forProvider = {
                forceDestroy = cv.forceDestroy
                location = cv.backup.get("region") or cv.region
                storageClass = "NEARLINE"
                versioning = [{enabled = True}]
            }
            if cv.cmkEnabled:
                forProvider.encryption = [{
                    defaultKmsKeyName = cv.cmkKeyName
                }]
            managementPolicies = cv.managementPolicies
        }
    }]

    _backup_items += [{
        "apiVersion": "storage.gcp.upbound.io/v1beta1"
        "kind": "BucketIAMMember"
        "metadata": {
            "annotations": {"crossplane.io/composition-resource-name": "liferay-gcs-backup-iam"}
            "labels": cv.labels
        }
        "spec": {
            "forProvider": {
                "bucketRef": {"name": "{}-backup".format(cv.baseName)}
                "member": "serviceAccount:{}".format(cv.gsaEmail)
                "role": "roles/storage.admin"
            }
            "managementPolicies": cv.managementPolicies
        }
    }]

    _backup_sa = k8s_core.ServiceAccount {
        metadata = {
            labels = cv.labels
            name = "backup-creator"
            namespace = cv.namespace
        }
    }

    _backup_rb = {
        "apiVersion": "rbac.authorization.k8s.io/v1"
        "kind": "RoleBinding"
        "metadata": {
            "name": "backup-create-role-binding"
            "namespace": cv.namespace
        }
        "roleRef": {
            "apiGroup": "rbac.authorization.k8s.io"
            "kind": "ClusterRole"
            "name": "backup-creator"
        }
        "subjects": [{
            "kind": "ServiceAccount"
            "name": "backup-creator"
            "namespace": cv.namespace
        }]
    }

    _backup_items += [
        kubernetes.Object {
            metadata = {
                annotations = {"crossplane.io/composition-resource-name": "backup-creator-sa"}
                labels = cv.labels
                name = "backup-creator-sa"
            }
            spec = {
                forProvider = {"manifest": _backup_sa}
                managementPolicy = cv.managementPolicy
            }
        }
        kubernetes.Object {
            metadata = {
                annotations = {"crossplane.io/composition-resource-name": "backup-create-role-binding"}
                labels = cv.labels
                name = "backup-create-role-binding"
            }
            spec = {
                forProvider = {"manifest": _backup_rb}
                managementPolicy = cv.managementPolicy
            }
        }
    ]

items = {"items": _backup_items}
