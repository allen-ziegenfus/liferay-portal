import .context_variables as cv
import crossplane_provider_kubernetes.v1alpha1 as kubernetes
import k8s.api.core.v1 as k8s_core

get_items = lambda obs: any, vars: {str:any} -> [any] {
    _status = obs?.resources?["liferay-db-grant-job"]?.resource?.status or {}

    _conditions = _status?.conditions or []

    _is_ready = any c in _conditions {c.type == "Ready" and c.status == "True"}

    _items = []

    if _is_ready:
        _secret_manifest = k8s_core.Secret {
            metadata = {
                labels = vars["labels"]
                name = "managed-service-details"
                namespace = vars["namespace"]
            }
            stringData = {
                "DATABASE_ENDPOINT": "localhost"
                "DATABASE_INSTANCE_NAME": vars["instanceConnectionName"]
                "DATABASE_PORT": str(vars["databasePort"])
                "DATABASE_USERNAME": str(vars["databaseIamUser"])
                "LIFERAY_GCS_BUCKET_NAME": "{}-dl".format(vars["baseName"])
                "LIFERAY_OVERLAY_BUCKET_NAME": "{}-overlay".format(vars["baseName"])
            }
            type = "Opaque"
        }

        _items += [kubernetes.Object {
            metadata = {
                annotations = {
                    "crossplane.io/external-name": "{}-managed-service-details-secret".format(vars["baseName"])
                    "crossplane.io/composition-resource-name": "managed-service-details-secret"
                }
                labels = vars["labels"]
                name = "{}-managed-service-details-secret".format(vars["baseName"])
            }
            spec = {
                forProvider = {
                    manifest = _secret_manifest
                }
                managementPolicy = vars["managementPolicy"]
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
