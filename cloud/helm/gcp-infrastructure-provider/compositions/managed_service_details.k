import context_variables as cv
import models.v1alpha1.kubernetesm_crossplane_io_v1alpha1_object as kubernetes
import k8s.api.core.v1 as k8s_core

get_items = lambda obs: any, vars: {str:any} -> [any] {
    _labels = vars?.labels or {}
    _namespace = str(vars?.namespace or "")
    _baseName = str(vars?.baseName or "")
    _projectId = str(vars?.projectId or "")
    _managementPolicies = vars?.managementPolicies or ["*"]

    _secret = k8s_core.Secret {
        apiVersion = "v1"
        kind = "Secret"
        metadata = {
            labels = _labels
            name = "managed-service-details"
            namespace = _namespace
        }
        stringData = {
            DATABASE_ENDPOINT = "localhost"
            DATABASE_INSTANCE_NAME = "{}:us-central1:{}-db-instance".format(_projectId, _baseName)
            DATABASE_PORT = "5432"
            DATABASE_USERNAME = "{}-sa@{}.iam".format(_baseName, _projectId)
            LIFERAY_GCS_BUCKET_NAME = str(vars?.bucketName or "{}-dl".format(_baseName))
            LIFERAY_OVERLAY_BUCKET_NAME = str(vars?.overlayBucketName or "{}-overlay".format(_baseName))
        }
    }

    [
        kubernetes.Object {
            apiVersion = "kubernetes.m.crossplane.io/v1alpha1"
            kind = "Object"
            metadata = {
                annotations = {"crossplane.io/composition-resource-name": "managed-service-details-secret"}
                labels = _labels
                name = "{}-managed-service-details-secret".format(_baseName)
            }
            spec = {
                forProvider = {manifest = _secret}
                managementPolicies = _managementPolicies
            }
        }
    ]
}

_vars = {
    "baseName": cv.baseName
    "gsaEmail": cv.gsaEmail
    "labels": cv.labels
    "managementPolicies": cv.managementPolicies
    "namespace": cv.namespace
    "projectId": cv.env?.projectId or ""
}

items = {"items": get_items(cv.obs, _vars)}
