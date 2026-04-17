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

# managedServiceDetailsReady mirrors the db-grant-job readiness condition.
# Consumers (e.g. the liferay app) poll this flag on the composite status.
_grant_conditions = cv.obs?.resources?["liferay-db-grant-job"]?.resource?.status?.conditions or []
_is_ready = any c in _grant_conditions { c.type == "Ready" and c.status == "True" }

items = {
    "items": get_items(cv.obs, _vars)
    "status": {"managedServiceDetailsReady": _is_ready}
}
