import .context_variables as cv
import .models.v1alpha1.kubernetesm_crossplane_io_v1alpha1_object as kubernetes
import .models.v1beta1.storage_gcpm_upbound_io_v1beta1_bucket as storage_bucket
import .models.v1beta1.storage_gcpm_upbound_io_v1beta1_bucket_i_a_m_member as storage_iam
import k8s.api.core.v1 as k8s_core
import k8s.api.rbac.v1 as k8s_rbac
import crypto

get_items = lambda obs: any, vars: {str:any} -> [any] {
    _backup = (vars["backup"] if "backup" in vars else {}) or {}
    _backup_items: [any] = []
    _baseName = str(vars["baseName"] if "baseName" in vars else "")
    _labels = vars["labels"] if "labels" in vars else {}
    _meta_name = str(vars["metadata"]["name"] if "metadata" in vars and "name" in vars["metadata"] else "")
    _gsaEmail = str(vars["gsaEmail"] if "gsaEmail" in vars else "")
    _namespace = str(vars["namespace"] if "namespace" in vars else "")
    _managementPolicies = vars["managementPolicies"] if "managementPolicies" in vars else ["*"]
    _managementPolicy = vars["managementPolicy"] if "managementPolicy" in vars else "Default"

    _get_iam_name = lambda role: str, bucket: str -> str {
        _hash = crypto.sha256(_meta_name + role + "serviceAccount:" + _gsaEmail + bucket)[:12:]
        "{}-{}".format(_meta_name, _hash)
    }

    if bool(_backup["enabled"] if "enabled" in _backup else False):
        _backup_vault_labels = _labels | {"is-backup-vault": "true"}
        _bucket_name = "{}-vault".format(_baseName)

        _backup_items += [storage_bucket.Bucket {
            apiVersion = "storage.gcp.m.upbound.io/v1beta1"
            kind = "Bucket"
            metadata = {
                annotations = {"crossplane.io/composition-resource-name": "liferay-gcs-backup"}
                labels = _backup_vault_labels
                name = _bucket_name
            }
            spec = {
                forProvider = {
                    forceDestroy = bool(vars["forceDestroy"] if "forceDestroy" in vars else False)
                    labels = _backup_vault_labels
                    lifecycleRule = [{
                        action = {$type = "Delete"}
                        condition = {age = (int(_backup["retentionDays"] if "retentionDays" in _backup else 30)) + 2}
                    }]
                    location = str(_backup["region"] if "region" in _backup else (vars["region"] if "region" in vars else ""))
                    storageClass = str(_backup["storageClass"] if "storageClass" in _backup else "NEARLINE")
                    uniformBucketLevelAccess = True
                }
                if bool(vars["cmkEnabled"] if "cmkEnabled" in vars else False):
                    forProvider.encryption = {
                        defaultKmsKeyName = str(vars["cmkKeyName"] if "cmkKeyName" in vars else "")
                    }
                managementPolicies = _managementPolicies
            }
        }]

        _backup_items += [storage_iam.BucketIAMMember {
            apiVersion = "storage.gcp.m.upbound.io/v1beta1"
            kind = "BucketIAMMember"
            metadata = {
                annotations = {"crossplane.io/composition-resource-name": "liferay-gcs-backup-iam"}
                labels = _labels
                name = _get_iam_name("roles/storage.admin", _bucket_name)
            }
            spec = {
                forProvider = {
                    bucketRef = {"name": _bucket_name}
                    member = "serviceAccount:{}".format(_gsaEmail)
                    role = "roles/storage.admin"
                }
                managementPolicies = _managementPolicies
            }
        }]

        _backup_cr = k8s_rbac.ClusterRole {
            apiVersion = "rbac.authorization.k8s.io/v1"
            kind = "ClusterRole"
            metadata = {
                labels = _labels
                name = "backup-create-cluster-role"
            }
            rules = [{
                apiGroups = [""]
                resources = ["serviceaccounts"]
                verbs = ["create", "delete", "get", "list", "watch"]
            }]
        }

        _backup_crb = k8s_rbac.ClusterRoleBinding {
            apiVersion = "rbac.authorization.k8s.io/v1"
            kind = "ClusterRoleBinding"
            metadata = {
                labels = _labels
                name = "backup-create-cluster-role-binding"
            }
            roleRef = {
                apiGroup = "rbac.authorization.k8s.io"
                kind = "ClusterRole"
                name = "backup-create-cluster-role"
            }
            subjects = [{
                kind = "ServiceAccount"
                name = "backup-create-service-account"
                namespace = _namespace
            }]
        }

        _backup_items += [
            kubernetes.Object {
            apiVersion = "kubernetes.m.crossplane.io/v1alpha1"
            kind = "Object"
                metadata = {
                    annotations = {"crossplane.io/composition-resource-name": "backup-create-cluster-role"}
                    labels = _labels
                    name = "backup-create-cluster-role"
                }
                spec = {
                    forProvider = {"manifest": _backup_cr}
                    managementPolicies = [_managementPolicy]
                }
            },
            kubernetes.Object {
            apiVersion = "kubernetes.m.crossplane.io/v1alpha1"
            kind = "Object"
                metadata = {
                    annotations = {"crossplane.io/composition-resource-name": "backup-create-cluster-role-binding"}
                    labels = _labels
                    name = "backup-create-cluster-role-binding"
                }
                spec = {
                    forProvider = {"manifest": _backup_crb}
                    managementPolicies = [_managementPolicy]
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
    "gsaEmail": cv.gsaEmail
    "labels": cv.labels
    "managementPolicies": cv.managementPolicies
    "managementPolicy": cv.managementPolicy
    "metadata": cv.metadata
    "namespace": cv.namespace
    "region": cv.region
}

items = {"items": get_items(cv.obs, _vars)}
