import .context_variables as cv
import .models.v1alpha1.kubernetesm_crossplane_io_v1alpha1_object as kubernetes
import k8s.api.core.v1 as k8s_core
import crypto
import yaml

get_items = lambda obs: any, vars: {str:any} -> [any] {
    _labels = vars["labels"] if "labels" in vars else {}
    _meta = vars["metadata"] if "metadata" in vars else {}
    _name = str(_meta["name"] if "name" in _meta else "")
    _namespace = str(vars["namespace"] if "namespace" in vars else "")
    _managementPolicies = vars["managementPolicies"] if "managementPolicies" in vars else ["*"]

    _init_cm = k8s_core.ConfigMap {
        metadata = {
            labels = _labels
            name = "init-config"
            namespace = _namespace
        }
        data = {
            "PROJECT_ID": str(vars["projectId"] if "projectId" in vars else "")
            "REGION": str(vars["region"] if "region" in vars else "")
        }
    }

    _items: [any] = [
        kubernetes.Object {
            metadata = {
                annotations = {"crossplane.io/composition-resource-name": "init-configmap"}
                labels = _labels
                name = "{}-init-config".format(_name)
            }
            spec = {
                forProvider = {"manifest": _init_cm}
                managementPolicies = [str(vars["managementPolicies"] if "managementPolicies" in vars else "Default")]
            }
        }
    ]

    _items
}

_vars = {
    "labels": cv.labels
    "managementPolicies": cv.managementPolicies
    "metadata": cv.metadata
    "namespace": cv.namespace
    "projectId": cv.projectId
    "region": cv.region
}

_res = cv.obs?.resources or {}
_status = _res?["managed-service-details-configmap"]?.resource?.status?.atProvider?.manifest?.status or {}
_conditions = _status?.conditions or []
_is_ready_ctx = any c in _conditions {c.type == "Ready" and c.status == "True"}

items = {
    "items": get_items(cv.obs, _vars)
    "status": {"managedServiceDetailsReady": _is_ready_ctx}
}
