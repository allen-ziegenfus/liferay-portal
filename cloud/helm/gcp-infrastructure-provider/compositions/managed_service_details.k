import .context_variables as cv
import .models.v1alpha1.kubernetesm_crossplane_io_v1alpha1_object as kubernetes
import k8s.api.core.v1 as k8s_core

get_items = lambda obs: any, vars: {str:any} -> [any] {
    _meta = vars["metadata"] if "metadata" in vars else {}
    _name = str(_meta["name"] if "name" in _meta else "")
    _labels = vars["labels"] if "labels" in vars else {}
    _namespace = str(vars["namespace"] if "namespace" in vars else "")
    _gsaEmail = str(vars["gsaEmail"] if "gsaEmail" in vars else "")

    _managed_service_details_cm = k8s_core.ConfigMap {
        metadata = {
            labels = _labels
            name = "managed-service-details"
            namespace = _namespace
        }
        data = {
            "GSA_EMAIL": _gsaEmail
        }
    }

    _items: [any] = [
        kubernetes.Object {
            metadata = {
                annotations = {"crossplane.io/composition-resource-name": "managed-service-details-configmap"}
                labels = _labels
                name = "{}-managed-service-details".format(_name)
            }
            spec = {
                forProvider = {"manifest": _managed_service_details_cm}
                managementPolicies = [str(vars["managementPolicies"] if "managementPolicies" in vars else "Default")]
            }
        }
    ]

    _items
}

_vars = {
    "gsaEmail": cv.gsaEmail
    "labels": cv.labels
    "managementPolicies": cv.managementPolicies
    "metadata": cv.metadata
    "namespace": cv.namespace
}

items = {"items": get_items(cv.obs, _vars)}
