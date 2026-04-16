import .context_variables as cv

_overlay_items = [{
    "apiVersion": "kubernetes.crossplane.io/v1alpha1"
    "kind": "Object"
    "metadata": {
        "annotations": {"crossplane.io/composition-resource-name": "liferay-overlay-cm"}
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

items = {"items": _overlay_items}
