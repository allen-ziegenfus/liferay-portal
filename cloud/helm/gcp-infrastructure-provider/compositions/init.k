import .context_variables as cv
import crossplane_provider_kubernetes.v1alpha1 as kubernetes
import k8s.api.core.v1 as k8s_core
import crypto
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

_status = cv.obs?.resources?["liferay-db-grant-job"]?.resource?.status or {}
_conditions = _status?.conditions or []

_is_ready_ctx = any c in _conditions {c.type == "Ready" and c.status == "True"}

_init_items = [
    {
        "apiVersion": "apiextensions.crossplane.io/v1alpha1"
        "kind": "Context"
        "data": {
            "backup": cv.backup
            "backupTargetLabels": cv.backupTargetLabels
            "baseName": cv.baseName
            "cmkEnabled": cv.cmkEnabled
            "cmkKeyName": cv.cmkKeyName
            "databaseIamUser": cv.databaseIamUser
            "databaseInstanceName": cv.databaseInstanceName
            "databaseName": cv.databaseName
            "databasePort": cv.databasePort
            "databaseSpec": cv.databaseSpec
            "elasticsearchHealth": ""
            "environmentId": cv.environmentId
            "forceDestroy": cv.forceDestroy
            "gsaEmail": cv.gsaEmail
            "gsaName": cv.gsaName
            "hash": crypto.sha256("{}-{}".format(cv.databaseName, cv.env?.projectId or ""))[:7:]
            "instanceConnectionName": cv.instanceConnectionName
            "isReady": False
            "isSearchReady": False
            "jobName": cv.jobName
            "labels": cv.labels
            "managementPolicies": cv.managementPolicies
            "managementPoliciesNoUpdate": cv.managementPoliciesNoUpdate
            "managementPoliciesOnce": cv.managementPoliciesOnce
            "namespace": cv.namespace
            "overlay": cv.overlay
            "projectId": cv.projectId
            "projectIdFull": cv.projectIdFull
            "region": cv.region
            "searchName": cv.searchName
            "searchNamespace": cv.searchNamespace
            "searchSecretName": cv.searchSecretName
            "storage": cv.storage_spec
            "uidHash": crypto.sha256("{}-{}".format(cv.env?.projectNumber or "", cv.projectIdFull))[:6:]
        }
    },
    kubernetes.Object {
        metadata = {
            annotations = {"crossplane.io/composition-resource-name": "composition-context"}
            name = "{}-composition-context".format(cv.metadata?.name or "")
        }
        spec = {
            forProvider = {
                manifest = k8s_core.ConfigMap {
                    data = {"variables": yaml.encode(_config_data)}
                    metadata = {
                        name = "composition-context"
                        namespace = cv.namespace
                    }
                }
            }
            managementPolicy = cv.managementPolicy
        }
    }
]

items = {
    "items": _init_items
    "status": {"managedServiceDetailsReady": _is_ready_ctx}
}
