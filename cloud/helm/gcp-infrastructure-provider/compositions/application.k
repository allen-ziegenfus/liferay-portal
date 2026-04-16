import .context_variables as cv
import crossplane_provider_kubernetes.v1alpha1 as kubernetes
import k8s.api.core.v1 as k8s_core

_app_res_map = cv.obs.get("resources") or {}
_job_entry = _app_res_map.get("liferay-db-grant-job") or {}
_job_obj = _job_entry.get("resource") if _job_entry else {}
_job_status = _job_obj.get("status") if _job_obj else {}
_conditions = _job_status.get("conditions") or []
_is_ready = any c in _conditions {c.type == "Ready" and c.status == "True"}

_items: [any] = []

if _is_ready:
    _secret_manifest = k8s_core.Secret {
        metadata = {
            labels = cv.labels
            name = "managed-service-details"
            namespace = cv.namespace
        }
        stringData = {
            "DATABASE_ENDPOINT": "localhost"
            "DATABASE_INSTANCE_NAME": cv.instanceConnectionName
            "DATABASE_PORT": str(cv.databasePort)
            "DATABASE_USERNAME": str(cv.databaseIamUser)
            "LIFERAY_GCS_BUCKET_NAME": "{}-dl".format(cv.baseName)
            "LIFERAY_OVERLAY_BUCKET_NAME": "{}-overlay".format(cv.baseName)
        }
        type = "Opaque"
    }

    _items += [kubernetes.Object {
        metadata = {
            annotations = {
                "crossplane.io/external-name": "{}-managed-service-details-secret".format(cv.baseName)
                "gotemplating.fn.crossplane.io/composition-resource-name": "managed-service-details-secret"
            }
            labels = cv.labels
            name = "{}-managed-service-details-secret".format(cv.baseName)
        }
        spec = {
            forProvider = {
                manifest = _secret_manifest
            }
            managementPolicy = cv.managementPolicy
        }
    }]

items = {"items": _items}
