import .context_variables as cv
import crossplane_provider_upjet_gcp.v1beta1.cloudplatform_gcp_upbound_io_v1beta1_service_account as gcp_sa

_gsa = gcp_sa.ServiceAccount {
    metadata = {
        annotations = {"crossplane.io/composition-resource-name": "liferay-gsa"}
        labels = cv.labels
        name = cv.gsaName
    }
    spec = {
        forProvider = {
            displayName = "Liferay Service Account for {}".format(cv.baseName)
        }
        managementPolicies = cv.managementPolicies
    }
}

_wi_iam = [{
    "apiVersion": "cloudplatform.gcp.upbound.io/v1beta1"
    "kind": "ServiceAccountIAMMember"
    "metadata": {
        "annotations": {"crossplane.io/composition-resource-name": "liferay-wi-iam"}
        "labels": cv.labels
        "name": "{}-wi-iam".format(cv.gsaName)
    }
    "spec": {
        "forProvider": {
            "member": "principal://iam.googleapis.com/projects/{}/locations/global/workloadIdentityPools/{}.svc.id.goog/subject/ns/{}/sa/liferay-default".format(cv.env["projectNumber"] if "projectNumber" in cv.env else "", cv.env["projectId"] if "projectId" in cv.env else "", cv.namespace)
            "role": "roles/iam.workloadIdentityUser"
            "serviceAccountIdRef": {"name": cv.gsaName}
        }
        "managementPolicies": cv.managementPolicies
    }
}]

_sql_client_iam = [{
    "apiVersion": "cloudplatform.gcp.upbound.io/v1beta1"
    "kind": "ProjectIAMMember"
    "metadata": {
        "annotations": {"crossplane.io/composition-resource-name": "liferay-sql-client-iam"}
        "labels": cv.labels
    }
    "spec": {
        "forProvider": {
            "member": "serviceAccount:{}".format(cv.gsaEmail)
            "project": cv.env["projectId"] if "projectId" in cv.env else ""
            "role": "roles/cloudsql.client"
        }
        "managementPolicies": cv.managementPolicies
    }
}]

_sql_instance_user_iam = [{
    "apiVersion": "cloudplatform.gcp.upbound.io/v1beta1"
    "kind": "ProjectIAMMember"
    "metadata": {
        "annotations": {"crossplane.io/composition-resource-name": "liferay-sql-instance-user-iam"}
        "labels": cv.labels
    }
    "spec": {
        "forProvider": {
            "member": "serviceAccount:{}".format(cv.gsaEmail)
            "project": cv.env["projectId"] if "projectId" in cv.env else ""
            "role": "roles/cloudsql.instanceUser"
        }
        "managementPolicies": cv.managementPolicies
    }
}]

_profiler_iam = [{
    "apiVersion": "cloudplatform.gcp.upbound.io/v1beta1"
    "kind": "ProjectIAMMember"
    "metadata": {
        "annotations": {"crossplane.io/composition-resource-name": "liferay-profiler-iam"}
        "labels": cv.labels
    }
    "spec": {
        "forProvider": {
            "member": "serviceAccount:{}".format(cv.gsaEmail)
            "project": cv.env["projectId"] if "projectId" in cv.env else ""
            "role": "roles/cloudprofiler.agent"
        }
        "managementPolicies": cv.managementPolicies
    }
}]

_kms_items = []
if cv.cmkEnabled:
    _kms_items += [
        {
            "apiVersion": "kms.gcp.upbound.io/v1beta1"
            "kind": "KeyRing"
            "metadata": {
                "annotations": {"crossplane.io/composition-resource-name": "liferay-keyring"}
                "labels": cv.labels
                "name": "{}-keyring".format(cv.baseName)
            }
            "spec": {
                "forProvider": {"location": cv.region}
                "managementPolicies": cv.managementPolicies
            }
        }
        {
            "apiVersion": "kms.gcp.upbound.io/v1beta1"
            "kind": "CryptoKey"
            "metadata": {
                "annotations": {"crossplane.io/composition-resource-name": "liferay-cryptokey"}
                "labels": cv.labels
                "name": "{}-key".format(cv.baseName)
            }
            "spec": {
                "forProvider": {
                    "keyRingSelector": {"matchControllerRef": True}
                    "purpose": "ENCRYPT_DECRYPT"
                    "rotationPeriod": "86400s"
                }
                "managementPolicies": cv.managementPolicies
            }
        }
    ]
    _kms_targets = [
        {"name": "sql", "svc": "gcp-sa-cloud-sql"}
        {"name": "storage", "svc": "gs-project-accounts"}
    ]
    _kms_items += [{
        "apiVersion": "kms.gcp.upbound.io/v1beta1"
        "kind": "CryptoKeyIAMMember"
        "metadata": {
            "annotations": {"crossplane.io/composition-resource-name": "liferay-{}-kms-binding".format(t["name"])}
            "labels": cv.labels
        }
        "spec": {
            "forProvider": {
                "cryptoKeyIdRef": {"name": "{}-key".format(cv.baseName)}
                "member": "serviceAccount:service-{}@{}.iam.gserviceaccount.com".format(cv.env["projectNumber"] if "projectNumber" in cv.env else "", t["svc"])
                "role": "roles/cloudkms.cryptoKeyEncrypterDecrypter"
            }
            "managementPolicies": cv.managementPolicies
        }
    } for t in _kms_targets]

items = {"items": [
    _gsa
] + _wi_iam + _sql_client_iam + _sql_instance_user_iam + _profiler_iam + _kms_items}
