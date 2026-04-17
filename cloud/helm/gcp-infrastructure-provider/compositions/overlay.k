import .context_variables as cv
import .models.v1alpha1.kubernetesm_crossplane_io_v1alpha1_object as kubernetes
import .models.v1beta1.storage_gcpm_upbound_io_v1beta1_bucket as gcp
import .models.v1beta1.storage_gcpm_upbound_io_v1beta1_bucket_i_a_m_member as gcp_iam

get_items = lambda obs: any, vars: {str:any} -> [any] {
    _labels = vars["labels"] if "labels" in vars else {}
    _baseName = vars["baseName"] if "baseName" in vars else ""
    _gsaEmail = str(vars["gsaEmail"] if "gsaEmail" in vars else "")
    _namespace = str(vars["namespace"] if "namespace" in vars else "")
    _managementPolicies = vars["managementPolicies"] if "managementPolicies" in vars else ["*"]

    _items: [any] = []

    if bool(vars["overlayEnabled"] if "overlayEnabled" in vars else False):
        _items += [gcp.Bucket {
            metadata = {
                annotations = {"crossplane.io/composition-resource-name": "overlay-bucket"}
                labels = _labels
                name = "{}-overlay".format(_baseName)
            }
            spec = {
                forProvider = {
                    forceDestroy = True
                    labels = _labels
                    location = str(vars["region"] if "region" in vars else "")
                    storageClass = "STANDARD"
                    uniformBucketLevelAccess = True
                }
                managementPolicies = _managementPolicies
            }
        }]

        _items += [gcp_iam.BucketIAMMember {
            metadata = {
                annotations = {"crossplane.io/composition-resource-name": "overlay-iam"}
                labels = _labels
            }
            spec = {
                forProvider = {
                    bucketRef = {"name": "{}-overlay".format(_baseName)}
                    member = "serviceAccount:{}".format(_gsaEmail)
                    role = "roles/storage.admin"
                }
                managementPolicies = _managementPolicies
            }
        }]

        _items += [kubernetes.Object {
            metadata = {
                annotations = {"crossplane.io/composition-resource-name": "overlay-configmap"}
                labels = _labels
                name = "{}-overlay-config".format(_baseName)
            }
            spec = {
                forProvider = {
                    manifest = {
                        "apiVersion": "v1"
                        "kind": "ConfigMap"
                        "metadata": {
                            "name": "overlay-config"
                            "namespace": _namespace
                        }
                        "data": {
                            "bucket": "{}-overlay".format(_baseName)
                        }
                    }
                }
                managementPolicies = [str(vars["managementPolicies"] if "managementPolicies" in vars else "Default")]
            }
        }]

    _items
}

_vars = {
    "baseName": cv.baseName
    "gsaEmail": cv.gsaEmail
    "labels": cv.labels
    "managementPolicies": cv.managementPolicies
    "namespace": cv.namespace
    "overlayEnabled": cv.overlayEnabled
    "region": cv.region
}

items = {"items": get_items(cv.obs, _vars)}
