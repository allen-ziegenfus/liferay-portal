import .context_variables as cv
import crossplane_provider_upjet_gcp.v1beta1.storage_gcp_upbound_io_v1beta1_bucket as gcp
import crossplane_provider_upjet_gcp.v1beta1.storage_gcp_upbound_io_v1beta1_bucket_i_a_m_member as gcp_iam

get_items = lambda obs: any, vars: {str:any} -> [any] {
    _storage_spec = vars["storage_spec"] if "storage_spec" in vars else {}
    _labels = vars["labels"] if "labels" in vars else {}
    _baseName = vars["baseName"] if "baseName" in vars else ""
    _gsaEmail = str(vars["gsaEmail"] if "gsaEmail" in vars else "")

    _storage_items: [any] = [
        gcp.Bucket {
            metadata = {
                annotations = {"crossplane.io/composition-resource-name": "liferay-gcs-bucket"}
                labels = _labels
                name = "{}-dl".format(_baseName)
            }
            spec = {
                forProvider = {
                    forceDestroy = bool(vars["forceDestroy"] if "forceDestroy" in vars else False)
                    labels = _labels | {"active": "true", "should-back-up": "true"}
                    location = str(_storage_spec["region"] if "region" in _storage_spec else (vars["region"] if "region" in vars else ""))
                    storageClass = "STANDARD"
                    uniformBucketLevelAccess = True
                    versioning = [{enabled = bool(_storage_spec["enableVersioning"] if "enableVersioning" in _storage_spec else True)}]
                }
                if vars.get("cmkEnabled"):
                    forProvider.encryption = [{
                        defaultKmsKeyName = str(vars["cmkKeyName"] if "cmkKeyName" in vars else "")
                    }]
                managementPolicies = vars["managementPolicies"] if "managementPolicies" in vars else ["*"]
            }
        },
        gcp_iam.BucketIAMMember {
            metadata = {
                annotations = {"crossplane.io/composition-resource-name": "liferay-gcs-iam"}
                labels = _labels
            }
            spec = {
                forProvider = {
                    bucketRef = {"name": "{}-dl".format(_baseName)}
                    member = "serviceAccount:{}".format(_gsaEmail)
                    role = "roles/storage.admin"
                }
                managementPolicies = vars["managementPolicies"] if "managementPolicies" in vars else ["*"]
            }
        }
    ]

    _storage_items
}

_vars = {
    "baseName": cv.baseName
    "cmkEnabled": cv.cmkEnabled
    "cmkKeyName": cv.cmkKeyName
    "forceDestroy": cv.forceDestroy
    "gsaEmail": cv.gsaEmail
    "labels": cv.labels
    "managementPolicies": cv.managementPolicies
    "metadata": cv.metadata
    "region": cv.region
    "storage_spec": cv.storage_spec
}

items = {"items": get_items(cv.obs, _vars)}
