import .context_variables as cv
import crossplane_provider_upjet_gcp.v1beta1.storage_gcp_upbound_io_v1beta1_bucket as gcp
import crossplane_provider_upjet_gcp.v1beta1.storage_gcp_upbound_io_v1beta1_bucket_i_a_m_member as gcp_iam

schema LiferayBucket:
    is_backup: bool = False
    suffix: str

    _bucket = gcp.Bucket {
        metadata = {
            annotations = {
                "crossplane.io/composition-resource-name": "liferay-gcs-{}".format(suffix)
            }
            labels = cv.backupTargetLabels if is_backup else cv.labels
            name = "{}-{}".format(cv.baseName, suffix)
        }
        spec = {
            forProvider = {
                forceDestroy = cv.forceDestroy
                location = cv.storage_spec["region"] if "region" in cv.storage_spec else cv.region
                storageClass = "STANDARD"
                versioning = [{enabled = cv.storage_spec["enableVersioning"] if "enableVersioning" in cv.storage_spec else True}]
            }
            if cv.cmkEnabled:
                forProvider.encryption = [{
                    defaultKmsKeyName = cv.cmkKeyName
                }]
            managementPolicies = cv.managementPolicies
        }
    }

    resource: gcp.Bucket = _bucket

_storage_items: [any] = [
    LiferayBucket {
        is_backup = True
        suffix = "dl"
    }.resource
]

_storage_items += [gcp_iam.BucketIAMMember {
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
}]

items = {"items": _storage_items}
