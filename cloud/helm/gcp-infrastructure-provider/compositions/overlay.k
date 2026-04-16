import .context_variables as cv
import crossplane_provider_kubernetes.v1alpha1 as kubernetes
import crossplane_provider_upjet_gcp.v1beta1.storage_gcp_upbound_io_v1beta1_bucket as gcp
import crossplane_provider_upjet_gcp.v1beta1.storage_gcp_upbound_io_v1beta1_bucket_i_a_m_member as gcp_iam
import k8s.api.core.v1 as k8s_core

get_items = lambda obs: any, vars: {str:any} -> [any] {
    _overlay = (vars["overlay"] if "overlay" in vars else {}) or {}
    _baseName = str(vars["baseName"] if "baseName" in vars else "")
    _labels = vars["labels"] if "labels" in vars else {}
    _meta_name = str(vars["metadata"]["name"] if "metadata" in vars and "name" in vars["metadata"] else "")
    _gsaEmail = str(vars["gsaEmail"] if "gsaEmail" in vars else "")
    
    _items = []

    if bool(_overlay["enabled"] if "enabled" in _overlay else False):
        _bucket_name = "{}-overlay".format(_baseName)
        
        _items += [gcp.Bucket {
            metadata = {
                annotations = {"crossplane.io/composition-resource-name": "liferay-overlay-bucket"}
                labels = _labels
                name = _bucket_name
            }
            spec = {
                forProvider = {
                    forceDestroy = bool(vars["forceDestroy"] if "forceDestroy" in vars else False)
                    labels = _labels
                    location = str(_overlay["region"] if "region" in _overlay else (vars["region"] if "region" in vars else ""))
                    storageClass = "STANDARD"
                    uniformBucketLevelAccess = True
                    versioning = [{enabled = True}]
                }
                if bool(vars["cmkEnabled"] if "cmkEnabled" in vars else False):
                    forProvider.encryption = [{
                        defaultKmsKeyName = str(vars["cmkKeyName"] if "cmkKeyName" in vars else "")
                    }]
                managementPolicies = vars["managementPolicies"] if "managementPolicies" in vars else ["*"]
            }
        }]

        _items += [gcp_iam.BucketIAMMember {
            metadata = {
                annotations = {"crossplane.io/composition-resource-name": "liferay-gsa-overlay-bucket-iam"}
                labels = _labels
            }
            spec = {
                forProvider = {
                    bucketRef = {"name": _bucket_name}
                    member = "serviceAccount:{}".format(_gsaEmail)
                    role = "roles/storage.objectViewer"
                }
                managementPolicies = vars["managementPolicies"] if "managementPolicies" in vars else ["*"]
            }
        }]

        _items += [kubernetes.Object {
            metadata = {
                annotations = {"crossplane.io/composition-resource-name": "liferay-overlay-cm"}
                labels = _labels
                name = "{}-overlay".format(_meta_name)
            }
            spec = {
                forProvider = {
                    manifest = k8s_core.ConfigMap {
                        data = _overlay["data"] if "data" in _overlay else {}
                        metadata = {
                            name = "{}-overlay".format(_meta_name)
                            namespace = str(vars["namespace"] if "namespace" in vars else "")
                        }
                    }
                }
                managementPolicy = str(vars["managementPolicy"] if "managementPolicy" in vars else "Default")
            }
        }]

    _items
}

_vars = {
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
    "overlay": cv.overlay
    "region": cv.region
}

items = {"items": get_items(cv.obs, _vars)}
