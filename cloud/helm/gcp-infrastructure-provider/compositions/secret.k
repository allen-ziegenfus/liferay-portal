import .context_variables as cv
import crossplane_provider_upjet_gcp.v1beta1.secretmanager_gcp_upbound_io_v1beta1_secret as gcp_secret
import crossplane_provider_upjet_gcp.v1beta1.secretmanager_gcp_upbound_io_v1beta1_secret_i_a_m_member as gcp_secret_iam

_liferay_secret = gcp_secret.Secret {
    metadata = {
        annotations = {"crossplane.io/composition-resource-name": "liferay-secret"}
        labels = cv.labels
        name = "{}-secret".format(cv.baseName)
    }
    spec = {
        forProvider = {
            replication = [{
                auto = [{}]
            }]
        }
        managementPolicies = cv.managementPolicies
    }
}

_secret_iam = gcp_secret_iam.SecretIAMMember {
    metadata = {
        annotations = {"crossplane.io/composition-resource-name": "liferay-secret-iam"}
        labels = cv.labels
        name = "{}-secret-iam".format(cv.baseName)
    }
    spec = {
        forProvider = {
            member = "serviceAccount:{}".format(cv.gsaEmail)
            role = "roles/secretmanager.secretAccessor"
            secretIdRef = {"name": "{}-secret".format(cv.baseName)}
        }
        managementPolicies = cv.managementPolicies
    }
}

items = {"items": [
    _liferay_secret
    _secret_iam
]}
