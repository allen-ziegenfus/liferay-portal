import .context_variables as cv
import crossplane_provider_upjet_gcp.v1beta1.secretmanager_gcp_upbound_io_v1beta1_secret as gcp_secret
import crossplane_provider_upjet_gcp.v1beta1.secretmanager_gcp_upbound_io_v1beta1_secret_i_a_m_member as gcp_secret_iam

get_items = lambda obs: any, vars: {str:any} -> [any] {
    _baseName = str(vars.get("baseName") or "")
    _labels = vars.get("labels") or {}
    _gsaEmail = str(vars.get("gsaEmail") or "")
    _secret_name = "{}-secret".format(_baseName)

    _secret_items: [any] = [
        gcp_secret.Secret {
            metadata = {
                annotations = {"crossplane.io/composition-resource-name": "liferay-secret"}
                labels = _labels
                name = _secret_name
            }
            spec = {
                forProvider = {
                    replication = [{
                        auto = [{}]
                    }]
                }
                managementPolicies = vars.get("managementPolicies") or ["*"]
            }
        },
        gcp_secret_iam.SecretIAMMember {
            metadata = {
                annotations = {"crossplane.io/composition-resource-name": "liferay-secret-iam"}
                labels = _labels
            }
            spec = {
                forProvider = {
                    member = "serviceAccount:{}".format(_gsaEmail)
                    role = "roles/secretmanager.secretAccessor"
                    secretIdRef = {"name": _secret_name}
                }
                managementPolicies = vars.get("managementPolicies") or ["*"]
            }
        }
    ]

    _secret_items
}

_vars = {
    "baseName": cv.baseName
    "gsaEmail": cv.gsaEmail
    "labels": cv.labels
    "managementPolicies": cv.managementPolicies
}

items = {"items": get_items(cv.obs, _vars)}
