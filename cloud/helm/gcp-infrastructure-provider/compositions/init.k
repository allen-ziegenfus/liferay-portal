import .context_variables as cv
import crossplane_provider_kubernetes.v1alpha1 as kubernetes
import k8s.api.core.v1 as k8s_core
import crypto
import yaml

get_items = lambda obs: any, vars: {str:any} -> [any] {
    _labels = vars["labels"] if "labels" in vars else {}
    _env = vars["env"] if "env" in vars else {}
    _projectId = str(vars["projectId"] if "projectId" in vars else "")
    _projectIdFull = str(vars["projectIdFull"] if "projectIdFull" in vars else "")
    _databaseName = str(vars["databaseName"] if "databaseName" in vars else "")
    _namespace = str(vars["namespace"] if "namespace" in vars else "")
    _metadata = vars["metadata"] if "metadata" in vars else {}
    _params = vars["params"] if "params" in vars else {}
    _oxr = vars["oxr"] if "oxr" in vars else {}

    _config_data = {
        "backup": vars["backup"] if "backup" in vars else {}
        "backupTargetLabels": _labels
        "baseName": str(vars["baseName"] if "baseName" in vars else "")
        "cmkEnabled": bool(vars["cmkEnabled"] if "cmkEnabled" in vars else False)
        "cmkKeyName": str(vars["cmkKeyName"] if "cmkKeyName" in vars else "")
        "commonTags": vars["commonTags"] if "commonTags" in vars else {}
        "databaseIamUser": str(vars["databaseIamUser"] if "databaseIamUser" in vars else "")
        "databaseInstanceName": str(vars["databaseInstanceName"] if "databaseInstanceName" in vars else "")
        "databaseName": _databaseName
        "databasePort": str(vars["databasePort"] if "databasePort" in vars else "")
        "databaseSpec": vars["databaseSpec"] if "databaseSpec" in vars else {}
        "deletionProtection": bool(vars["deletionProtection"] if "deletionProtection" in vars else False)
        "elasticsearchHealth": ""
        "environmentId": str(vars["environmentId"] if "environmentId" in vars else "")
        "forceDestroy": bool(vars["forceDestroy"] if "forceDestroy" in vars else False)
        "gsaEmail": str(vars["gsaEmail"] if "gsaEmail" in vars else "")
        "gsaName": str(vars["gsaName"] if "gsaName" in vars else "")
        "hash": crypto.sha256("{}-{}".format(_databaseName, _env["projectId"] if "projectId" in _env else ""))[:7:]
        "instanceConnectionName": str(vars["instanceConnectionName"] if "instanceConnectionName" in vars else "")
        "isReady": False
        "isSearchReady": False
        "jobName": str(vars["jobName"] if "jobName" in vars else "")
        "labels": _labels
        "managementPolicies": vars["managementPolicies"] if "managementPolicies" in vars else ["*"]
        "managementPoliciesNoUpdate": vars["managementPoliciesNoUpdate"] if "managementPoliciesNoUpdate" in vars else []
        "managementPoliciesOnce": vars["managementPoliciesOnce"] if "managementPoliciesOnce" in vars else []
        "namespace": _namespace
        "overlay": vars["overlay"] if "overlay" in vars else {}
        "projectId": _projectId
        "projectIdFull": _projectIdFull
        "region": str(vars["region"] if "region" in vars else "")
        "searchName": str(vars["searchName"] if "searchName" in vars else "")
        "searchNamespace": str(vars["searchNamespace"] if "searchNamespace" in vars else "")
        "searchSecretName": str(vars["searchSecretName"] if "searchSecretName" in vars else "")
        "storage": vars["storage_spec"] if "storage_spec" in vars else {}
        "uidHash": str(vars["uidHash"] if "uidHash" in vars else "")
    }

    _status = obs?.resources?["liferay-db-grant-job"]?.resource?.status or {}
    _conditions = _status?.conditions or []
    _is_ready_ctx = any c in _conditions {c.type == "Ready" and c.status == "True"}

    _init_items = [
        {
            "apiVersion": "apiextensions.crossplane.io/v1alpha1"
            "kind": "Context"
            "data": _config_data
        }
        kubernetes.Object {
            metadata = {
                annotations = {"crossplane.io/composition-resource-name": "composition-context"}
                name = "{}-composition-context".format(_metadata["name"] if "name" in _metadata else "")
            }
            spec = {
                forProvider = {
                    manifest = k8s_core.ConfigMap {
                        data = {
                            "desired_resources_summary": yaml.encode(_params["desired"]["resources"].keys() if "desired" in _params and "resources" in _params["desired"] else [])
                            "observed_composite_spec": yaml.encode(_oxr["spec"] if "spec" in _oxr else {})
                            "observed_composite_status": yaml.encode(_oxr["status"] if "status" in _oxr else {})
                            "observed_resources_summary": yaml.encode(obs["resources"].keys() if "resources" in obs else [])
                            "variables": yaml.encode(_config_data)
                        }
                        metadata = {
                            name = "composition-context"
                            namespace = _namespace
                        }
                    }
                }
                managementPolicy = vars["managementPolicy"] if "managementPolicy" in vars else "Default"
            }
        }
    ]

    _init_items
}

_vars = {
    "backup": cv.backup
    "baseName": cv.baseName
    "cmkEnabled": cv.cmkEnabled
    "cmkKeyName": cv.cmkKeyName
    "commonTags": cv.spec.get("commonTags") or {}
    "databaseIamUser": cv.databaseIamUser
    "databaseInstanceName": cv.databaseInstanceName
    "databaseName": cv.databaseName
    "databasePort": cv.databasePort
    "databaseSpec": cv.databaseSpec
    "deletionProtection": cv.spec.get("deletionProtection") or False
    "env": cv.env
    "environmentId": cv.environmentId
    "forceDestroy": cv.forceDestroy
    "gsaEmail": cv.gsaEmail
    "gsaName": cv.gsaName
    "instanceConnectionName": cv.instanceConnectionName
    "jobName": cv.jobName
    "labels": cv.labels
    "managementPolicies": cv.managementPolicies
    "managementPoliciesNoUpdate": cv.managementPoliciesNoUpdate
    "managementPoliciesOnce": cv.managementPoliciesOnce
    "metadata": cv.metadata
    "namespace": cv.namespace
    "overlay": cv.overlay
    "oxr": cv.oxr
    "params": cv.params
    "projectId": cv.projectId
    "projectIdFull": cv.projectIdFull
    "region": cv.region
    "searchName": cv.searchName
    "searchNamespace": cv.searchNamespace
    "searchSecretName": cv.searchSecretName
    "storage_spec": cv.storage_spec
    "uidHash": cv.uidHash
}

_status = cv.obs?.resources?["liferay-db-grant-job"]?.resource?.status or {}
_conditions = _status?.conditions or []
_is_ready_ctx = any c in _conditions {c.type == "Ready" and c.status == "True"}

items = {
    "items": get_items(cv.obs, _vars)
    "status": {"managedServiceDetailsReady": _is_ready_ctx}
}
