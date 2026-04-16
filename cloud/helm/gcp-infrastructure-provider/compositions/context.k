import .context_variables as cv
import yaml

_config_data = {
    "baseName": cv.baseName
    "databaseInstanceName": cv.databaseInstanceName
    "databaseName": cv.databaseName
    "databasePort": cv.databasePort
    "gsaEmail": cv.gsaEmail
    "gsaName": cv.gsaName
    "instanceConnectionName": cv.instanceConnectionName
    "namespace": cv.namespace
    "projectId": cv.projectId
    "region": cv.region
}

_ctx_res_map = cv.obs["resources"] if "resources" in cv.obs else {}
_job_entry_ctx = _ctx_res_map["liferay-db-grant-job"] if "liferay-db-grant-job" in _ctx_res_map else {}
_job_obj_ctx = _job_entry_ctx["resource"] if "resource" in _job_entry_ctx else {}
_job_status_ctx = _job_obj_ctx["status"] if "status" in _job_obj_ctx else {}
_conditions_ctx = _job_status_ctx["conditions"] if "conditions" in _job_status_ctx else []
_is_ready_ctx = any c in _conditions_ctx {c.type == "Ready" and c.status == "True"}

_context_items: [any] = [
    {
        "apiVersion": "kubernetes.m.crossplane.io/v1alpha1"
        "kind": "Object"
        "metadata": {
            "annotations": {"gotemplating.fn.crossplane.io/composition-resource-name": "composition-context"}
            "name": "{}-composition-context".format(cv.metadata["name"] if "name" in cv.metadata else "")
        }
        "spec": {
            "forProvider": {
                "manifest": {
                    "apiVersion": "v1"
                    "data": {
                        "variables": yaml.encode(_config_data)
                    }
                    "kind": "ConfigMap"
                    "metadata": {
                        "name": "composition-context"
                        "namespace": cv.namespace
                    }
                }
            }
            "managementPolicies": cv.managementPolicies
        }
    }
]

_context_status = {
    "status": {"managedServiceDetailsReady": _is_ready_ctx}
}

if option("combined", "false") != "true":
    items = {"items": _context_items, **_context_status}

