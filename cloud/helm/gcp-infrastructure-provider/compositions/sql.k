import .context_variables as cv
import crossplane_provider_upjet_gcp.v1beta1.sql_gcp_upbound_io_v1beta1_database as sql_db
import crossplane_provider_upjet_gcp.v1beta1.sql_gcp_upbound_io_v1beta1_database_instance as sql_instance
import crossplane_provider_upjet_gcp.v1beta1.sql_gcp_upbound_io_v1beta1_user as sql_user

get_items = lambda obs: any, vars: {str:any} -> [any] {
    _db_spec = vars["databaseSpec"] if "databaseSpec" in vars else {}
    _env = vars["env"] if "env" in vars else {}
    _meta = vars["metadata"] if "metadata" in vars else {}
    _labels = vars["labels"] if "labels" in vars else {}
    _namespace = vars["namespace"] if "namespace" in vars else ""

    _sql_items: [any] = [
        sql_instance.DatabaseInstance {
            metadata = {
                annotations = {"crossplane.io/composition-resource-name": "database-primary"}
                labels = _labels
                name = str(vars["databaseInstanceName"] if "databaseInstanceName" in vars else "")
            }
            spec = {
                forProvider = {
                    databaseVersion = str(_db_spec["databaseVersion"] if "databaseVersion" in _db_spec else "POSTGRES_18")
                    deletionProtection = bool(_db_spec["deletionProtection"] if "deletionProtection" in _db_spec else (not (vars["forceDestroy"] if "forceDestroy" in vars else False)))
                    if vars.get("cmkEnabled"):
                        encryptionKeyName = str(vars["cmkKeyName"] if "cmkKeyName" in vars else "")
                    region = str(vars["region"] if "region" in vars else "")
                    rootPasswordSecretRef = {
                        key = "password"
                        name = str(_db_spec["rootPasswordSecretName"] if "rootPasswordSecretName" in _db_spec else "placeholder")
                        namespace = _namespace
                    }
                    settings = [{
                        databaseFlags = [{"name": "cloudsql.iam_authentication", "value": "on"}]
                        diskSize = int(_db_spec["storageGB"] if "storageGB" in _db_spec else 10)
                        diskType = "PD_SSD"
                        edition = "ENTERPRISE"
                        insightsConfig = [{
                            queryInsightsEnabled = bool(_db_spec["queryInsightsEnabled"] if "queryInsightsEnabled" in _db_spec else True)
                        }]
                        ipConfiguration = [{
                            ipv4Enabled = False
                            privateNetwork = "projects/{}/global/networks/{}".format(str(vars["projectId"] if "projectId" in vars else ""), str(_env["vpcName"] if "vpcName" in _env else ""))
                            sslMode = "TRUSTED_CLIENT_CERTIFICATE_REQUIRED"
                        }]
                        tier = str(_db_spec["instanceType"] if "instanceType" in _db_spec else "db-custom-1-3840")
                        userLabels = _labels | {"active": "true", "should-back-up": "true"}
                    }]
                }
                managementPolicies = vars["managementPolicies"] if "managementPolicies" in vars else ["*"]
            }
        }
        sql_db.Database {
            metadata = {
                annotations = {
                    "crossplane.io/external-name": str(vars["databaseName"] if "databaseName" in vars else "")
                    "crossplane.io/composition-resource-name": "liferay-db"
                }
                labels = _labels
                name = "{}-db".format(_meta["name"] if "name" in _meta else "")
            }
            spec = {
                forProvider = {
                    charset = "UTF8"
                    collation = "en_US.UTF8"
                    instanceSelector = {"matchControllerRef": True}
                }
                managementPolicies = vars["managementPolicies"] if "managementPolicies" in vars else ["*"]
            }
        }
        sql_user.User {
            metadata = {
                annotations = {
                    "crossplane.io/external-name": str(vars["databaseIamUser"] if "databaseIamUser" in vars else "")
                    "crossplane.io/composition-resource-name": "liferay-iam-user"
                }
                labels = _labels
                name = "{}-db-user".format(_meta["name"] if "name" in _meta else "")
            }
            spec = {
                forProvider = {
                    instanceSelector = {"matchControllerRef": True}
                    type = "CLOUD_IAM_SERVICE_ACCOUNT"
                }
                managementPolicies = vars["managementPolicies"] if "managementPolicies" in vars else ["*"]
            }
        }
    ]

    _sql_items += [{
        "apiVersion": "protection.crossplane.io/v1beta1"
        "kind": "Usage"
        "metadata": {
            "annotations": {
                "crossplane.io/composition-resource-name": "usage-instance-by-{}".format("database" if t == "db" else "user")
            }
            "name": "{}-instance-by-{}".format(_meta["name"] if "name" in _meta else "", "database" if t == "db" else "user")
            "namespace": _namespace
        }
        "spec": {
            "by": {
                "apiVersion": "sql.gcp.upbound.io/v1beta1"
                "kind": "Database" if t == "db" else "User"
                "resourceRef": {"name": "{}-{}".format(_meta["name"] if "name" in _meta else "", t)}
            }
            "of": {
                "apiVersion": "sql.gcp.upbound.io/v1beta1"
                "kind": "DatabaseInstance"
                "resourceRef": {"name": str(vars["databaseInstanceName"] if "databaseInstanceName" in vars else "")}
            }
        }
    } for t in ["db", "db-user"]]

    _sql_items
}

_vars = {
    "baseName": cv.baseName
    "cmkEnabled": cv.cmkEnabled
    "cmkKeyName": cv.cmkKeyName
    "databaseIamUser": cv.databaseIamUser
    "databaseInstanceName": cv.databaseInstanceName
    "databaseName": cv.databaseName
    "databasePort": cv.databasePort
    "databaseSpec": cv.databaseSpec
    "env": cv.env
    "forceDestroy": cv.forceDestroy
    "labels": cv.labels
    "managementPolicies": cv.managementPolicies
    "metadata": cv.metadata
    "namespace": cv.namespace
    "projectId": cv.projectId
    "region": cv.region
}

if option("combined", "false") != "true":
    items = {"items": get_items(cv.obs, _vars)}

