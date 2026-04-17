import crypto

params = option("params") or {}
ctx = params?.ctx or {}
obs = params?.obs or {"resources": {}}
oxr = params?.oxr or {}

env = ctx?["apiextensions.crossplane.io/environment"] or {}
metadata = oxr?.metadata or {}
spec = oxr?.spec or {}

backup = spec?.backup or {}
cmkEnabled = spec?.cmk?.enabled or False
databaseSpec = spec?.database or {}
environmentId = spec?.environmentId or ""
forceDestroy = spec?.forceDestroy or False
namespace = metadata?.namespace or ""
overlay = spec?.overlay or {}
overlayEnabled = overlay?.enabled or False
projectId = spec?.projectId or ""
region = databaseSpec?.region or spec?.region or ""
storage_spec = spec?.storage or {}

# Dual naming scheme, matching the legacy go-template composition:
# - baseName = XR metadata.name — used for namespace-scoped Crossplane/K8s
#   resources (ServiceAccount, Job, DatabaseInstance, Usage, etc.).
# - hashedName = {projectIdFull[:18]}-{sha256(projectNumber+projectIdFull)[:6]}
#   — used for GCP resources that need globally unique names (GCS buckets,
#   KMS keyrings, the managed-service-details external-name).
baseName = metadata?.name or ""
projectIdFull = "{}-{}".format(projectId, environmentId)
uidHash = crypto.sha256("{}-{}".format(env?.projectNumber or "", projectIdFull))[:6:]
hashedName = "{}-{}".format(projectIdFull[:18:], uidHash)

cmkKeyName = "projects/{}/locations/{}/keyRings/{}-keyring/cryptoKeys/{}-key".format(env?.projectId or "", region, hashedName, hashedName)
databaseIamUser = "{}-sa@{}.iam".format(baseName, env?.projectId or "")
databaseInstanceName = "{}-db-instance".format(baseName)
databaseObjectName = "{}-db".format(baseName)
databaseUserObjectName = "{}-db-user".format(baseName)
databaseName = databaseSpec?.name or "lportal"
databasePort = "5432"
gsaEmail = "{}-sa@{}.iam.gserviceaccount.com".format(baseName, env?.projectId or "")
gsaName = "{}-sa".format(baseName)
instanceConnectionName = "{}:{}:{}".format(env?.projectId or "", region, databaseInstanceName)
jobName = "{}-db-grant".format(baseName)
searchName = "{}-es".format(baseName)
searchNamespace = "{}-elasticsearch".format(namespace)
searchSecretName = "{}-es-elastic-user".format(searchName)

# Bucket names are globally unique across GCP, so use hashedName.
bucketName = "{}-dl".format(hashedName)
overlayBucketName = "{}-overlay".format(hashedName)
backupBucketName = "{}-vault".format(hashedName)
managedServiceDetailsExternalName = "{}-managed-service-details-secret".format(hashedName)

labels = {
    "app": "liferay"
    "deployment-name": env?.deploymentName or ""
    "environment-id": environmentId
    "project-id": projectId
} | (spec?.commonTags or {})

backupTargetLabels = labels | {"active": "true", "should-back-up": "true"}
orphan = spec?.orphanOnDelete or False
managementPolicies = ["Create", "Observe", "Update"] if orphan else ["*"]
managementPolicy = "ObserveCreateUpdate" if orphan else "Default"
managementPoliciesNoUpdate = ["Create", "Observe"] if orphan else ["Create", "Delete", "Observe"]
managementPoliciesOnce = ["Create", "Observe", "Delete"]
