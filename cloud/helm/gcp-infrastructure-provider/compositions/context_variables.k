import crypto

_params = option("params") or {}
ctx = _params["ctx"] if "ctx" in _params else {}
obs = _params["obs"] if "obs" in _params else {
    "resources": {}
}
oxr = _params["oxr"] if "oxr" in _params else {}

env = ctx["apiextensions.crossplane.io/environment"] if "apiextensions.crossplane.io/environment" in ctx else {}
metadata = oxr["metadata"] if "metadata" in oxr else {}
spec = oxr["spec"] if "spec" in oxr else {}

_cmk_spec = spec["cmk"] if "cmk" in spec else {}
backup = spec["backup"] if "backup" in spec else {}
cmkEnabled = _cmk_spec["enabled"] if "enabled" in _cmk_spec else False
databaseSpec = spec["database"] if "database" in spec else {}
environmentId = spec["environmentId"] if "environmentId" in spec else ""
forceDestroy = spec["forceDestroy"] if "forceDestroy" in spec else False
namespace = metadata["namespace"] if "namespace" in metadata else ""
overlay = spec["overlay"] if "overlay" in spec else {}
projectId = spec["projectId"] if "projectId" in spec else ""
region = databaseSpec["region"] if "region" in databaseSpec else (spec["region"] if "region" in spec else "")
storage_spec = spec["storage"] if "storage" in spec else {}

baseName = "{}-{}".format("{}-{}".format(projectId, environmentId)[:18:], crypto.sha256("{}-{}-{}".format(env["projectNumber"] if "projectNumber" in env else "", projectId, environmentId))[:6:])
cmkKeyName = "projects/{}/locations/{}/keyRings/{}-keyring/cryptoKeys/{}-key".format(env["projectId"] if "projectId" in env else "", region, baseName, baseName)
databaseIamUser = "{}@{}.iam".format("{}-sa".format(metadata["name"] if "name" in metadata else ""), env["projectId"] if "projectId" in env else "")
databaseInstanceName = "{}-db-instance".format(metadata["name"] if "name" in metadata else "")
databaseName = databaseSpec["name"] if "name" in databaseSpec else "lportal"
databasePort = "5432"
gsaEmail = "{}@{}.iam.gserviceaccount.com".format("{}-sa".format(metadata["name"] if "name" in metadata else ""), env["projectId"] if "projectId" in env else "")
gsaName = "{}-sa".format(metadata["name"] if "name" in metadata else "")
instanceConnectionName = "{}:{}:{}".format(env["projectId"] if "projectId" in env else "", region, databaseInstanceName)
jobName = "{}-db-grant".format(metadata["name"] if "name" in metadata else "")
projectIdFull = "{}-{}".format(projectId, environmentId)
searchName = "{}-es".format(metadata["name"] if "name" in metadata else "")
searchNamespace = "{}-elasticsearch".format(namespace)
searchSecretName = "{}-es-elastic-user".format(searchName)

labels = {
    "app": "liferay"
    "deployment-name": env["deploymentName"] if "deploymentName" in env else ""
    "environment-id": environmentId
    "project-id": projectId
}
if "commonTags" in spec and spec["commonTags"]:
    labels.update(spec["commonTags"])

backupTargetLabels = {**labels, "active": "true", "should-back-up": "true"}
orphan = spec["orphanOnDelete"] if "orphanOnDelete" in spec else False
managementPolicies = ["Create", "Observe", "Update"] if orphan else ["*"]
managementPolicy = "ObserveCreateUpdate" if orphan else "Default"
managementPoliciesNoUpdate = ["Create", "Observe"] if orphan else ["Create", "Delete", "Observe"]
managementPoliciesOnce = ["Create", "Observe", "Delete"]
