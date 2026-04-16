import .context_variables as l
import crossplane_provider_upjet_gcp.v1beta1.storage_gcp_upbound_io_v1beta1_bucket as gcp

schema LiferayBucket:
    is_backup: bool = False
    suffix: str

    _bucket = gcp.Bucket {
        metadata = {
            annotations = {
                "gotemplating.fn.crossplane.io/composition-resource-name": "liferay-gcs-{}".format(suffix)
            }
            labels = l.backupTargetLabels if is_backup else l.labels
            name = "{}-{}".format(l.baseName, suffix)
        }
        spec = {
            forProvider = {
                forceDestroy = l.forceDestroy
                location = l.storage_spec.get("region") or l.region
                storageClass = "STANDARD"
                versioning = [{enabled = l.storage_spec.get("enableVersioning") or True}]
            }
            if l.cmkEnabled:
                forProvider.encryption = [{
                    defaultKmsKeyName = l.cmkKeyName
                }]
            managementPolicies = l.managementPolicies
        }
    }

    resource: gcp.Bucket = _bucket

_items: [any] = [
    LiferayBucket {
        is_backup = True
        suffix = "dl"
    }.resource
]

# Add Bucket IAM Member
_items += [{
    "apiVersion": "storage.gcp.m.upbound.io/v1beta1"
    "kind": "BucketIAMMember"
    "metadata": {
        "annotations": {"gotemplating.fn.crossplane.io/composition-resource-name": "liferay-gcs-iam"}
        "labels": l.labels
    }
    "spec": {
        "forProvider": {
            "bucketRef": {"name": "{}-dl".format(l.baseName)}
            "member": "serviceAccount:{}".format(l.gsaEmail)
            "role": "roles/storage.admin"
        }
        "managementPolicies": l.managementPolicies
    }
}]

items = {"items": _items}
