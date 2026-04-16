import .context_variables as cv
import crossplane_provider_kubernetes.v1alpha1 as kubernetes
import k8s.api.core.v1 as k8s_core

get_items = lambda obs: any, vars: {str:any} -> [any] {
    _status = obs?.resources?["liferay-db-grant-job"]?.resource?.status or {}
    _conditions = _status?.conditions or []

    _is_ready = any c in _conditions {c.type == "Ready" and c.status == "True"}

    _items = []

    if _is_ready:
        _labels = vars["labels"] if "labels" in vars else {}
        _namespace = vars["namespace"] if "namespace" in vars else ""
        _baseName = vars["baseName"] if "baseName" in vars else ""

        _secret_manifest = k8s_core.Secret {
            metadata = {
                labels = _labels
                name = "managed-service-details"
                namespace = _namespace
            }
            stringData = {
                "DATABASE_ENDPOINT": "localhost"
                "DATABASE_INSTANCE_NAME": str(vars["instanceConnectionName"] if "instanceConnectionName" in vars else "")
                "DATABASE_PORT": str(vars["databasePort"] if "databasePort" in vars else "")
                "DATABASE_USERNAME": str(vars["databaseIamUser"] if "databaseIamUser" in vars else "")
                "LIFERAY_GCS_BUCKET_NAME": "{}-dl".format(_baseName)
                "LIFERAY_OVERLAY_BUCKET_NAME": "{}-overlay".format(_baseName)
            }
            type = "Opaque"
        }

        _items += [kubernetes.Object {
            metadata = {
                annotations = {
                    "crossplane.io/external-name": "{}-managed-service-details-secret".format(_baseName)
                    "crossplane.io/composition-resource-name": "managed-service-details-secret"
                }
                labels = _labels
                name = "{}-managed-service-details-secret".format(_baseName)
            }
            spec = {
                forProvider = {
                    manifest = _secret_manifest
                }
                managementPolicy = vars["managementPolicy"] if "managementPolicy" in vars else "Default"
            }
        }]

    _items
}

_vars = {
    "baseName": cv.baseName
    "databaseIamUser": cv.databaseIamUser
    "databasePort": cv.databasePort
    "instanceConnectionName": cv.instanceConnectionName
    "labels": cv.labels
    "managementPolicy": cv.managementPolicy
    "namespace": cv.namespace
}

items = {"items": get_items(cv.obs, _vars)}
