import .context_variables as cv

_items = [{
    "apiVersion": "kubernetes.crossplane.io/v1alpha1"
    "kind": "Object"
    "metadata": {
        "annotations": {"gotemplating.fn.crossplane.io/composition-resource-name": "liferay-overlay-cm"}
        "labels": cv.labels
        "name": "{}-overlay".format(cv.metadata["name"] if "name" in cv.metadata else "")
    }
    "spec": {
        "forProvider": {
            "manifest": {
                "apiVersion": "v1"
                "kind": "ConfigMap"
                "metadata": {
                    "name": "{}-overlay".format(cv.metadata["name"] if "name" in cv.metadata else "")
                    "namespace": cv.namespace
                }
                "data": cv.overlay.get("data") or {}
            }
        }
        "managementPolicy": cv.managementPolicy
    }
}] if cv.overlay.get("enabled") else []

items = {"items": _items}
