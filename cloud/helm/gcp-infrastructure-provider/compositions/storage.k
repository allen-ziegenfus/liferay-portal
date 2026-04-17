import .context_variables as cv
import .models.v1beta1.storage_gcpm_upbound_io_v1beta1_bucket as gcp
import .models.v1beta1.storage_gcpm_upbound_io_v1beta1_bucket_i_a_m_member as gcp_iam

get_items = lambda obs: any, vars: {str:any} -> [any] {
    _storage_spec = vars["storage_spec"] if "storage_spec" in vars else {}
    _labels = vars["labels"] if "labels" in vars else {}
    _baseName = vars["baseName"] if "baseName" in vars else ""
    _bucket_name = str(vars["bucketName"] if "bucketName" in vars else "{}-dl".format(_baseName))
    _managementPolicies = vars["managementPolicies"] if "managementPolicies" in vars else ["*"]

    _items: [any] = [
        gcp.Bucket {
            apiVersion = "storage.gcp.m.upbound.io/v1beta1"
            kind = "Bucket"
            metadata = {
                annotations = {"crossplane.io/composition-resource-name": "liferay-gcs-bucket"}
                labels = _labels
                name = _bucket_name
            }
            spec = {
                forProvider = {
                    forceDestroy = bool(vars["forceDestroy"] if "forceDestroy" in vars else False)
                    labels = _labels | {"active": "true", "should-back-up": "true"}
                    location = str(vars["region"] if "region" in vars else "")
                    storageClass = str(_storage_spec["storageClass"] if "storageClass" in _storage_spec else "STANDARD")
                    uniformBucketLevelAccess = True
                    versioning = {enabled = bool(_storage_spec["enableVersioning"] if "enableVersioning" in _storage_spec else True)}
                }
                if vars["cmkEnabled"] if "cmkEnabled" in vars else False:
                    forProvider.encryption = {
                        defaultKmsKeyName = str(vars["cmkKeyName"] if "cmkKeyName" in vars else "")
                    }
                managementPolicies = _managementPolicies
            }
        },
        gcp_iam.BucketIAMMember {
            apiVersion = "storage.gcp.m.upbound.io/v1beta1"
            kind = "BucketIAMMember"
            metadata = {
                annotations = {"crossplane.io/composition-resource-name": "liferay-gcs-iam"}
                labels = _labels
            }
            spec = {
                forProvider = {
                    member = "serviceAccount:{}".format(str(vars["gsaEmail"] if "gsaEmail" in vars else ""))
                    role = "roles/storage.admin"
                    bucketRef = {
                        name = _bucket_name
                    }
                }
                managementPolicies = _managementPolicies
            }
        }
    ]

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
    "region": cv.region
    "storage_spec": cv.storage_spec
}

items = {"items": get_items(cv.obs, _vars)}
