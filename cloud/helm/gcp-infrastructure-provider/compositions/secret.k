import .context_variables as cv
import crossplane_provider_upjet_gcp.v1beta1.secretmanager_gcp_upbound_io_v1beta1_secret as gcp_secret
import crossplane_provider_upjet_gcp.v1beta1.secretmanager_gcp_upbound_io_v1beta1_secret_i_a_m_member as gcp_secret_iam

get_items = lambda obs: any, vars: {str:any} -> [any] {
    _baseName = str(vars["baseName"] if "baseName" in vars else "")
    _labels = vars["labels"] if "labels" in vars else {}
    _gsaEmail = str(vars["gsaEmail"] if "gsaEmail" in vars else "")
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
                managementPolicies = vars["managementPolicies"] if "managementPolicies" in vars else ["*"]
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
                managementPolicies = vars["managementPolicies"] if "managementPolicies" in vars else ["*"]
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
