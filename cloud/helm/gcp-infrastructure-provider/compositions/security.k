import .context_variables as cv
import crossplane_provider_upjet_gcp.v1beta1.cloudplatform_gcp_upbound_io_v1beta1_project_i_a_m_member as project_iam
import crossplane_provider_upjet_gcp.v1beta1.cloudplatform_gcp_upbound_io_v1beta1_service_account as sa
import crossplane_provider_upjet_gcp.v1beta1.cloudplatform_gcp_upbound_io_v1beta1_service_account_i_a_m_member as sa_iam
import crossplane_provider_upjet_gcp.v1beta1.kms_gcp_upbound_io_v1beta1_crypto_key as kms_key
import crossplane_provider_upjet_gcp.v1beta1.kms_gcp_upbound_io_v1beta1_crypto_key_i_a_m_member as kms_iam
import crossplane_provider_upjet_gcp.v1beta1.kms_gcp_upbound_io_v1beta1_key_ring as kms_keyring

_gsa = sa.ServiceAccount {
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

_wi_iam = [sa_iam.ServiceAccountIAMMember {
    metadata = {
        annotations = {"crossplane.io/composition-resource-name": "liferay-wi-iam"}
        labels = cv.labels
        name = "{}-wi-iam".format(cv.gsaName)
    }
    spec = {
        forProvider = {
            member = "principal://iam.googleapis.com/projects/{}/locations/global/workloadIdentityPools/{}.svc.id.goog/subject/ns/{}/sa/liferay-default".format(cv.env["projectNumber"] if "projectNumber" in cv.env else "", cv.env["projectId"] if "projectId" in cv.env else "", cv.namespace)
            role = "roles/iam.workloadIdentityUser"
            serviceAccountIdRef = {"name": cv.gsaName}
        }
        managementPolicies = cv.managementPolicies
    }
}]

_sql_client_iam = [project_iam.ProjectIAMMember {
    metadata = {
        annotations = {"crossplane.io/composition-resource-name": "liferay-sql-client-iam"}
        labels = cv.labels
    }
    spec = {
        forProvider = {
            member = "serviceAccount:{}".format(cv.gsaEmail)
            project = cv.env["projectId"] if "projectId" in cv.env else ""
            role = "roles/cloudsql.client"
        }
        managementPolicies = cv.managementPolicies
    }
}]

_sql_instance_user_iam = [project_iam.ProjectIAMMember {
    metadata = {
        annotations = {"crossplane.io/composition-resource-name": "liferay-sql-instance-user-iam"}
        labels = cv.labels
    }
    spec = {
        forProvider = {
            member = "serviceAccount:{}".format(cv.gsaEmail)
            project = cv.env["projectId"] if "projectId" in cv.env else ""
            role = "roles/cloudsql.instanceUser"
        }
        managementPolicies = cv.managementPolicies
    }
}]

_profiler_iam = [project_iam.ProjectIAMMember {
    metadata = {
        annotations = {"crossplane.io/composition-resource-name": "liferay-profiler-iam"}
        labels = cv.labels
    }
    spec = {
        forProvider = {
            member = "serviceAccount:{}".format(cv.gsaEmail)
            project = cv.env["projectId"] if "projectId" in cv.env else ""
            role = "roles/cloudprofiler.agent"
        }
        managementPolicies = cv.managementPolicies
    }
}]

_kms_items = []
if cv.cmkEnabled:
    _kms_items += [
        kms_keyring.KeyRing {
            metadata = {
                annotations = {"crossplane.io/composition-resource-name": "liferay-keyring"}
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
                annotations = {"crossplane.io/composition-resource-name": "liferay-cryptokey"}
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
    _kms_items += [kms_iam.CryptoKeyIAMMember {
        metadata = {
            annotations = {"crossplane.io/composition-resource-name": "liferay-{}-kms-binding".format(t["name"])}
            labels = cv.labels
        }
        spec = {
            forProvider = {
                cryptoKeyIdRef = {"name": "{}-key".format(cv.baseName)}
                member = "serviceAccount:service-{}@{}.iam.gserviceaccount.com".format(cv.env["projectNumber"] if "projectNumber" in cv.env else "", t["svc"])
                role = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
            }
            managementPolicies = cv.managementPolicies
        }
    } for t in _kms_targets]

items = {"items": [
    _gsa
] + _wi_iam + _sql_client_iam + _sql_instance_user_iam + _profiler_iam + _kms_items}
