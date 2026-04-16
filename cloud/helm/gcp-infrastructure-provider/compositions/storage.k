import .context_variables as cv
import crossplane_provider_upjet_gcp.v1beta1.storage_gcp_upbound_io_v1beta1_bucket as gcp
import crossplane_provider_upjet_gcp.v1beta1.storage_gcp_upbound_io_v1beta1_bucket_i_a_m_member as gcp_iam

_storage_items: [any] = [
    gcp.Bucket {
        metadata = {
            annotations = {"crossplane.io/composition-resource-name": "liferay-gcs-bucket"}
            labels = cv.labels
            name = "{}-dl".format(cv.baseName)
        }
        spec = {
            forProvider = {
                forceDestroy = cv.forceDestroy
                labels = cv.backupTargetLabels
                location = cv.storage_spec.get("region") or cv.region
                storageClass = "STANDARD"
                uniformBucketLevelAccess = True
                versioning = [{enabled = cv.storage_spec.get("enableVersioning") or True}]
            }
            if cv.cmkEnabled:
                forProvider.encryption = [{
                    defaultKmsKeyName = cv.cmkKeyName
                }]
            managementPolicies = cv.managementPolicies
        }
    },
    gcp_iam.BucketIAMMember {
        metadata = {
            annotations = {"crossplane.io/composition-resource-name": "liferay-gcs-iam"}
            labels = cv.labels
        }
        spec = {
            forProvider = {
                bucketRef = {"name": "{}-dl".format(cv.baseName)}
                member = "serviceAccount:{}".format(cv.gsaEmail)
                role = "roles/storage.admin"
            }
            managementPolicies = cv.managementPolicies
        }
    }
]

items = {"items": _storage_items}
