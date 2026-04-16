import .context_variables as cv
import crossplane_provider_upjet_gcp.v1beta1.sql_gcp_upbound_io_v1beta1_database as sql_db
import crossplane_provider_upjet_gcp.v1beta1.sql_gcp_upbound_io_v1beta1_database_instance as sql_instance
import crossplane_provider_upjet_gcp.v1beta1.sql_gcp_upbound_io_v1beta1_user as sql_user

_sql_items: [any] = [
    sql_instance.DatabaseInstance {
        metadata = {
            annotations = {"gotemplating.fn.crossplane.io/composition-resource-name": "database-primary"}
            labels = cv.labels
            name = cv.databaseInstanceName
        }
        spec = {
            forProvider = {
                databaseVersion = cv.databaseSpec["databaseVersion"] if "databaseVersion" in cv.databaseSpec else "POSTGRES_15"
                deletionProtection = cv.databaseSpec["deletionProtection"] if "deletionProtection" in cv.databaseSpec else (not cv.forceDestroy)
                if cv.cmkEnabled:
                    encryptionKeyName = cv.cmkKeyName
                region = cv.region
                rootPasswordSecretRef = {
                    key = "password"
                    name = cv.databaseSpec["rootPasswordSecretName"] if "rootPasswordSecretName" in cv.databaseSpec else "placeholder"
                    namespace = cv.namespace
                }
                settings = [{
                    databaseFlags = [{"name": "cloudsql.iam_authentication", "value": "on"}]
                    diskSize = cv.databaseSpec["storageGB"] if "storageGB" in cv.databaseSpec else 10
                    diskType = "PD_SSD"
                    edition = "ENTERPRISE"
                    insightsConfig = [{
                        queryInsightsEnabled = cv.databaseSpec["queryInsightsEnabled"] if "queryInsightsEnabled" in cv.databaseSpec else True
                    }]
                    ipConfiguration = [{
                        ipv4Enabled = False
                        privateNetwork = "projects/{}/global/networks/{}".format(cv.projectId, cv.env["vpcName"] if "vpcName" in cv.env else "")
                        sslMode = "TRUSTED_CLIENT_CERTIFICATE_REQUIRED"
                    }]
                    tier = cv.databaseSpec["instanceType"] if "instanceType" in cv.databaseSpec else "db-custom-1-3840"
                    userLabels = cv.backupTargetLabels
                }]
            }
            managementPolicies = cv.managementPolicies
        }
    }
    sql_db.Database {
        metadata = {
            annotations = {
                "crossplane.io/external-name": cv.databaseName
                "gotemplating.fn.crossplane.io/composition-resource-name": "liferay-db"
            }
            labels = cv.labels
            name = "{}-db".format(cv.metadata["name"] if "name" in cv.metadata else "")
        }
        spec = {
            forProvider = {
                charset = "UTF8"
                collation = "en_US.UTF8"
                instanceSelector = {"matchControllerRef": True}
            }
            managementPolicies = cv.managementPolicies
        }
    }
    sql_user.User {
        metadata = {
            annotations = {
                "crossplane.io/external-name": cv.databaseIamUser
                "gotemplating.fn.crossplane.io/composition-resource-name": "liferay-iam-user"
            }
            labels = cv.labels
            name = "{}-db-user".format(cv.metadata["name"] if "name" in cv.metadata else "")
        }
        spec = {
            forProvider = {
                instanceSelector = {"matchControllerRef": True}
                type = "CLOUD_IAM_SERVICE_ACCOUNT"
            }
            managementPolicies = cv.managementPolicies
        }
    }
]

_sql_items += [{
    "apiVersion": "protection.crossplane.io/v1beta1"
    "kind": "Usage"
    "metadata": {
        "annotations": {
            "gotemplating.fn.crossplane.io/composition-resource-name": "usage-instance-by-{}".format(t)
        }
        "name": "{}-instance-by-{}".format(cv.metadata["name"] if "name" in cv.metadata else "", t)
        "namespace": cv.namespace
    }
    "spec": {
        "by": {
            "apiVersion": "sql.gcp.upbound.io/v1beta1"
            "kind": "Database" if t == "db" else "User"
            "resourceRef": {"name": "{}-{}".format(cv.metadata["name"] if "name" in cv.metadata else "", t)}
        }
        "of": {
            "apiVersion": "sql.gcp.upbound.io/v1beta1"
            "kind": "DatabaseInstance"
            "resourceRef": {"name": cv.databaseInstanceName}
        }
    }
} for t in ["db", "db-user"]]

if option("combined", "false") != "true":
    items = {"items": _sql_items}

