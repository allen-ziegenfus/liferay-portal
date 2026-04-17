import context_variables as cv

get_items = lambda obs: any, vars: {str:any} -> [any] {
    _items: [any] = []
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
