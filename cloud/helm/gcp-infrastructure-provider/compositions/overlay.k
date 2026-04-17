import .context_variables as cv
import .models.v1alpha1.kubernetesm_crossplane_io_v1alpha1_object as kubernetes
import .models.v1beta1.storage_gcpm_upbound_io_v1beta1_bucket as gcp
import .models.v1beta1.storage_gcpm_upbound_io_v1beta1_bucket_i_a_m_member as gcp_iam

get_items = lambda obs: any, vars: {str:any} -> [any] {
    _labels = vars["labels"] if "labels" in vars else {}
    _baseName = vars["baseName"] if "baseName" in vars else ""
    _overlayBucketName = str(vars["overlayBucketName"] if "overlayBucketName" in vars else "{}-overlay".format(_baseName))
    _gsaEmail = str(vars["gsaEmail"] if "gsaEmail" in vars else "")
    _namespace = str(vars["namespace"] if "namespace" in vars else "")
    _managementPolicies = vars["managementPolicies"] if "managementPolicies" in vars else ["*"]

    _items: [any] = []

    if bool(vars["overlayEnabled"] if "overlayEnabled" in vars else False):
        _items += [gcp.Bucket {
            metadata = {
                annotations = {"crossplane.io/composition-resource-name": "liferay-overlay-bucket"}
                labels = _labels
                name = _overlayBucketName
            }
            spec = {
                forProvider = {
                    forceDestroy = bool(vars["forceDestroy"] if "forceDestroy" in vars else False)
                    labels = _labels
                    location = str(vars["overlayRegion"] if "overlayRegion" in vars and vars["overlayRegion"] else (vars["region"] if "region" in vars else ""))
                    project = str(vars["projectId"] if "projectId" in vars else "")
                    storageClass = "STANDARD"
                    uniformBucketLevelAccess = True
                }
                managementPolicies = _managementPolicies
            }
        }]

        _items += [gcp_iam.BucketIAMMember {
            metadata = {
                annotations = {"crossplane.io/composition-resource-name": "liferay-gsa-overlay-bucket-iam"}
                labels = _labels
            }
            spec = {
                forProvider = {
                    bucketRef = {"name": _overlayBucketName}
                    member = "serviceAccount:{}".format(_gsaEmail)
                    role = "roles/storage.objectViewer"
                }
                managementPolicies = _managementPolicies
            }
        }]

    _items
}

_vars = {
    "baseName": cv.baseName
    "forceDestroy": cv.forceDestroy
    "gsaEmail": cv.gsaEmail
    "labels": cv.labels
    "managementPolicies": cv.managementPolicies
    "namespace": cv.namespace
    "overlayEnabled": cv.overlayEnabled
    "overlayRegion": cv.overlay["region"] if "region" in cv.overlay else ""
    "projectId": cv.env["projectId"] if "projectId" in cv.env else ""
    "region": cv.region
}

items = {"items": get_items(cv.obs, _vars)}
