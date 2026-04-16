import crypto

# 1. Extract Parameters
_params = option("params")
ctx = _params.ctx
obs = _params.get("obs") or {"resources": {}}
oxr = _params.oxr

_environment_data = ctx.get("apiextensions.crossplane.io/environment") or {}
_metadata = oxr.get("metadata") or {}
_spec = oxr.get("spec") or {}

# 2. Base Variables (ASCII Sorted: A-Z before a-z)
_cmk_spec = _spec.get("cmk") or {}
backup = _spec.get("backup") or {}
cmkEnabled = _cmk_spec.get("enabled") or False
databaseSpec = _spec.get("database") or {}
environmentId = _spec.get("environmentId") or ""
forceDestroy = _spec.get("forceDestroy") or False
namespace = _metadata.get("namespace") or ""
overlay = _spec.get("overlay") or {}
projectId = _spec.get("projectId") or ""
region = databaseSpec.get("region") or _spec.get("region") or ""
storage_spec = _spec.get("storage") or {}

# 3. Computed Names & Strings (ASCII Sorted)
baseName = "{}-{}".format(
    "{}-{}".format(projectId, environmentId)[:18],
    crypto.sha256("{}-{}-{}".format(_environment_data.get("projectNumber") or "", projectId, environmentId))[:6]
)
cmkKeyName = "projects/{}/locations/{}/keyRings/{}-keyring/cryptoKeys/{}-key".format(_environment_data.get("projectId") or "", region, baseName, baseName)
databaseIamUser = "{}@{}.iam".format("{}-sa".format(_metadata.get("name") or ""), _environment_data.get("projectId") or "")
databaseInstanceName = "{}-db-instance".format(_metadata.get("name") or "")
databaseName = databaseSpec.get("name") or "lportal"
databasePort = "5432"
gsaEmail = "{}@{}.iam.gserviceaccount.com".format("{}-sa".format(_metadata.get("name") or ""), _environment_data.get("projectId") or "")
gsaName = "{}-sa".format(_metadata.get("name") or "")
instanceConnectionName = "{}:{}:{}".format(_environment_data.get("projectId") or "", region, databaseInstanceName)
jobName = "{}-db-grant".format(_metadata.get("name") or "")
projectIdFull = "{}-{}".format(projectId, environmentId)
searchName = "{}-es".format(_metadata.get("name") or "")
searchNamespace = "{}-elasticsearch".format(namespace)
searchSecretName = "{}-es-elastic-user".format(searchName)

# 4. Labels & Policies (ASCII Sorted)
labels = {
    "app": "liferay"
    "deployment-name": _environment_data.get("deploymentName") or ""
    "environment-id": environmentId
    "project-id": projectId
}
if _spec.get("commonTags"):
    labels.update(_spec.get("commonTags"))

backupTargetLabels = {**labels, "active": "true", "should-back-up": "true"}
orphan = _spec.get("orphanOnDelete") or False
managementPolicies = ["Create", "Observe", "Update"] if orphan else ["*"]
managementPolicy = "ObserveCreateUpdate" if orphan else "Default"
managementPoliciesNoUpdate = ["Create", "Observe"] if orphan else ["Create", "Delete", "Observe"]
managementPoliciesOnce = ["Create", "Observe", "Delete"]
