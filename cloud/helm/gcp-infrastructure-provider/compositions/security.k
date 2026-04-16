import .context_variables as cv
import crossplane_provider_upjet_gcp.v1beta1.cloudplatform_gcp_upbound_io_v1beta1_project_i_a_m_member as project_iam
import crossplane_provider_upjet_gcp.v1beta1.cloudplatform_gcp_upbound_io_v1beta1_service_account as sa
import crossplane_provider_upjet_gcp.v1beta1.cloudplatform_gcp_upbound_io_v1beta1_service_account_i_a_m_member as sa_iam
import crossplane_provider_upjet_gcp.v1beta1.kms_gcp_upbound_io_v1beta1_crypto_key as kms_key
import crossplane_provider_upjet_gcp.v1beta1.kms_gcp_upbound_io_v1beta1_crypto_key_i_a_m_member as kms_iam
import crossplane_provider_upjet_gcp.v1beta1.kms_gcp_upbound_io_v1beta1_key_ring as kms_keyring

_items: [any] = [
    sa.ServiceAccount {
        metadata = {
            annotations = {"gotemplating.fn.crossplane.io/composition-resource-name": "liferay-gsa"}
            labels = cv.labels
            name = cv.gsaName
        }
        spec.forProvider = {
            displayName = "Liferay {} Service Account".format(cv.gsaName)
        }
    }
    sa_iam.ServiceAccountIAMMember {
        metadata = {
            annotations = {"gotemplating.fn.crossplane.io/composition-resource-name": "liferay-wi-binding"}
            labels = cv.labels
        }
        spec.forProvider = {
            member = "serviceAccount:{}.svc.id.goog[{}/liferay-default]".format(cv.env["projectId"] if "projectId" in cv.env else "", cv.namespace)
            role = "roles/iam.workloadIdentityUser"
            serviceAccountIdRef = {"name": cv.gsaName}
        }
    }
]

_items += [project_iam.ProjectIAMMember {
    metadata = {
        annotations = {"gotemplating.fn.crossplane.io/composition-resource-name": "liferay-sql-{}-role".format(r.split('.')[-1])}
        labels = cv.labels
    }
    spec.forProvider = {
        member = "serviceAccount:{}".format(cv.gsaEmail)
        project = cv.env["projectId"] if "projectId" in cv.env else ""
        role = r
    }
} for r in ["roles/cloudsql.instanceUser", "roles/cloudsql.client"]]

if cv.cmkEnabled:
    _items += [
        kms_keyring.KeyRing {
            metadata = {
                annotations = {"gotemplating.fn.crossplane.io/composition-resource-name": "liferay-keyring"}
                labels = cv.labels
                name = "{}-keyring".format(cv.baseName)
            }
            spec = {
                forProvider = {"location": cv.region}
                managementPolicies = cv.managementPolicies
            }
        }
        kms_key.CryptoKey {
            metadata = {
                annotations = {"gotemplating.fn.crossplane.io/composition-resource-name": "liferay-cryptokey"}
                labels = cv.labels
                name = "{}-key".format(cv.baseName)
            }
            spec = {
                forProvider = {
                    keyRingSelector = {"matchControllerRef": True}
                    purpose = "ENCRYPT_DECRYPT"
                    rotationPeriod = "86400s"
                }
                managementPolicies = cv.managementPolicies
            }
        }
    ]

    _kms_targets = [
        {"name": "sql", "svc": "gcp-sa-cloud-sql"}
        {"name": "storage", "svc": "gs-project-accounts"}
    ]
    _items += [kms_iam.CryptoKeyIAMMember {
        metadata = {
            annotations = {"gotemplating.fn.crossplane.io/composition-resource-name": "liferay-{}-kms-binding".format(t.name)}
            labels = cv.labels
        }
        spec = {
            forProvider = {
                cryptoKeyIdRef = {"name": "{}-key".format(cv.baseName)}
                member = "serviceAccount:service-{}@{}.iam.gserviceaccount.com".format(cv.env["projectNumber"] if "projectNumber" in cv.env else "", t.svc)
                role = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
            }
            managementPolicies = cv.managementPolicies
        }
    } for t in _kms_targets]

items = {"items": _items}
