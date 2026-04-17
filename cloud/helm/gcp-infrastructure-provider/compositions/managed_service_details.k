import context_variables as cv
import models.v1alpha1.kubernetesm_crossplane_io_v1alpha1_object as kubernetes
import k8s.api.core.v1 as k8s_core

get_items = lambda obs: any, vars: {str:any} -> [any] {
    _labels = vars["labels"] if "labels" in vars else {}
    _namespace = str(vars["namespace"] if "namespace" in vars else "")
    _baseName = str(vars["baseName"] if "baseName" in vars else "")

    _managed_service_details_secret = k8s_core.Secret {
        apiVersion = "v1"
        kind = "Secret"
        metadata = {
            labels = _labels
            name = "managed-service-details"
            namespace = _namespace
        }
        stringData = {
            "DATABASE_ENDPOINT": "localhost"
            "DATABASE_INSTANCE_NAME": "{}:us-central1:{}-db-instance".format(str(vars["projectId"] if "projectId" in vars else ""), _baseName)
            "DATABASE_PORT": "5432"
            "DATABASE_USERNAME": "{}-sa@{}.iam".format(_baseName, str(vars["projectId"] if "projectId" in vars else ""))
            "LIFERAY_GCS_BUCKET_NAME": str(vars["bucketName"] if "bucketName" in vars else "{}-dl".format(_baseName))
            "LIFERAY_OVERLAY_BUCKET_NAME": str(vars["overlayBucketName"] if "overlayBucketName" in vars else "{}-overlay".format(_baseName))
        }
    }

    _items: [any] = [
        kubernetes.Object {
            apiVersion = "kubernetes.m.crossplane.io/v1alpha1"
            kind = "Object"
            metadata = {
                annotations = {"crossplane.io/composition-resource-name": "managed-service-details-secret"}
                labels = _labels
                name = "{}-managed-service-details-secret".format(_baseName)
            }
            spec = {
                forProvider = {"manifest": _managed_service_details_secret}
                managementPolicies = vars["managementPolicies"] if "managementPolicies" in vars else ["*"]
            }
        }
    ]

    _items
}

_vars = {
    "baseName": cv.baseName
    "gsaEmail": cv.gsaEmail
    "labels": cv.labels
    "managementPolicies": cv.managementPolicies
    "namespace": cv.namespace
    "projectId": cv.env["projectId"] if "projectId" in cv.env else ""
}

items = {"items": get_items(cv.obs, _vars)}
