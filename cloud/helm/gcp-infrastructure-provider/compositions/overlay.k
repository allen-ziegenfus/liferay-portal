import .context_variables as cv
import crossplane_provider_kubernetes.v1alpha1 as kubernetes
import k8s.api.core.v1 as k8s_core

get_items = lambda obs: any, vars: {str:any} -> [any] {
    _overlay = vars?.overlay or {}
    _items = []

    if _overlay?.enabled:
        _items += [kubernetes.Object {
            metadata = {
                annotations = {"crossplane.io/composition-resource-name": "liferay-overlay-cm"}
                labels = vars["labels"]
                name = "{}-overlay".format(vars["metadata"]?.name or "")
            }
            spec = {
                forProvider = {
                    manifest = k8s_core.ConfigMap {
                        data = _overlay?.data or {}
                        metadata = {
                            name = "{}-overlay".format(vars["metadata"]?.name or "")
                            namespace = vars["namespace"]
                        }
                    }
                }
                managementPolicy = vars["managementPolicy"]
            }
        }]

    _items
}

_vars = {
    "labels": cv.labels
    "managementPolicy": cv.managementPolicy
    "metadata": cv.metadata
    "namespace": cv.namespace
    "overlay": cv.overlay
}

items = {"items": get_items(cv.obs, _vars)}
