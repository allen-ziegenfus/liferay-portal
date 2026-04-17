import context_variables as cv
import models.v1beta1.sql_gcpm_upbound_io_v1beta1_database as sql_db
import models.v1beta1.sql_gcpm_upbound_io_v1beta1_database_instance as sql_instance
import models.v1beta1.sql_gcpm_upbound_io_v1beta1_user as sql_user

_get_items_impl = lambda obs: any, vars: {str:any} -> [any] {
    _db_spec = vars["database"] if "database" in vars else {}
    _env = vars["env"] if "env" in vars else {}
    _labels = vars["labels"] if "labels" in vars else {}
    _managementPolicies = vars["managementPolicies"] if "managementPolicies" in vars else ["*"]

    _items: [any] = [
        sql_instance.DatabaseInstance {
            apiVersion = "sql.gcp.m.upbound.io/v1beta1"
            kind = "DatabaseInstance"
            metadata = {
                annotations = {"crossplane.io/composition-resource-name": "database-primary"}
                labels = _labels
                name = str(vars["databaseInstanceName"] if "databaseInstanceName" in vars else "")
            }
            spec = {
                forProvider = {
                    databaseVersion = str(_db_spec["databaseVersion"] if "databaseVersion" in _db_spec else "POSTGRES_18")
                    deletionProtection = bool(_db_spec["deletionProtection"] if "deletionProtection" in _db_spec else False)
                    region = str(vars["region"] if "region" in vars else "")
                    rootPasswordSecretRef = {
                        key = "password"
                        name = str(_db_spec["rootPasswordSecretName"] if "rootPasswordSecretName" in _db_spec else "placeholder")
                        
                    }
                    settings = {
                        databaseFlags = [{"name": "cloudsql.iam_authentication", "value": "on"}]
                        diskSize = int(_db_spec["storageGB"] if "storageGB" in _db_spec else 10)
                        diskType = "PD_SSD"
                        edition = "ENTERPRISE"
                        insightsConfig = {
                            queryInsightsEnabled = bool(_db_spec["queryInsightsEnabled"] if "queryInsightsEnabled" in _db_spec else True)
                        }
                        ipConfiguration = {
                            ipv4Enabled = False
                            privateNetwork = "projects/{}/global/networks/{}".format(str(vars["projectId"] if "projectId" in vars else ""), str(_env["vpcName"] if "vpcName" in _env else ""))
                            sslMode = "TRUSTED_CLIENT_CERTIFICATE_REQUIRED"
                        }
                        tier = str(_db_spec["instanceType"] if "instanceType" in _db_spec else "db-custom-1-3840")
                        userLabels = _labels | {"active": "true", "should-back-up": "true"}
                    }
                }
                managementPolicies = _managementPolicies
            }
        }
        sql_db.Database {
            apiVersion = "sql.gcp.m.upbound.io/v1beta1"
            kind = "Database"
            metadata = {
                annotations = {
                    "crossplane.io/composition-resource-name": "liferay-db"
                    "crossplane.io/external-name": str(vars["databaseName"] if "databaseName" in vars else "lportal")
                }
                labels = _labels
                name = str(vars["databaseObjectName"] if "databaseObjectName" in vars else "{}-db".format(str(vars["baseName"] if "baseName" in vars else "")))
            }
            spec = {
                forProvider = {
                    instanceRef = {
                        name = str(vars["databaseInstanceName"] if "databaseInstanceName" in vars else "")
                    }
                    project = str(vars["projectId"] if "projectId" in vars else "")
                }
                managementPolicies = _managementPolicies
            }
        }
        sql_user.User {
            apiVersion = "sql.gcp.m.upbound.io/v1beta1"
            kind = "User"
            metadata = {
                annotations = {
                    "crossplane.io/composition-resource-name": "liferay-iam-user"
                    "crossplane.io/external-name": str(vars["databaseIamUser"] if "databaseIamUser" in vars else "")
                }
                labels = _labels
                name = str(vars["databaseUserObjectName"] if "databaseUserObjectName" in vars else "{}-db-user".format(str(vars["baseName"] if "baseName" in vars else "")))
            }
            spec = {
                forProvider = {
                    instanceRef = {
                        name = str(vars["databaseInstanceName"] if "databaseInstanceName" in vars else "")
                    }
                    project = str(vars["projectId"] if "projectId" in vars else "")
                    $type = "CLOUD_IAM_SERVICE_ACCOUNT"
                }
                managementPolicies = _managementPolicies
            }
        }
        {
            apiVersion = "protection.crossplane.io/v1beta1"
            kind = "Usage"
            metadata = {
                annotations = {"crossplane.io/composition-resource-name": "usage-instance-by-database"}
                name = "{}-instance-by-database".format(str(vars["baseName"] if "baseName" in vars else ""))
            }
            spec = {
                of = {
                    apiVersion = "sql.gcp.m.upbound.io/v1beta1"
                    kind = "DatabaseInstance"
                    resourceRef = {name = str(vars["databaseInstanceName"] if "databaseInstanceName" in vars else "")}
                }
                by = {
                    apiVersion = "sql.gcp.m.upbound.io/v1beta1"
                    kind = "Database"
                    resourceRef = {name = str(vars["databaseObjectName"] if "databaseObjectName" in vars else "{}-db".format(str(vars["baseName"] if "baseName" in vars else "")))}
                }
            }
        }
        {
            apiVersion = "protection.crossplane.io/v1beta1"
            kind = "Usage"
            metadata = {
                annotations = {"crossplane.io/composition-resource-name": "usage-instance-by-user"}
                name = "{}-instance-by-user".format(str(vars["baseName"] if "baseName" in vars else ""))
            }
            spec = {
                of = {
                    apiVersion = "sql.gcp.m.upbound.io/v1beta1"
                    kind = "DatabaseInstance"
                    resourceRef = {name = str(vars["databaseInstanceName"] if "databaseInstanceName" in vars else "")}
                }
                by = {
                    apiVersion = "sql.gcp.m.upbound.io/v1beta1"
                    kind = "User"
                    resourceRef = {name = str(vars["databaseUserObjectName"] if "databaseUserObjectName" in vars else "{}-db-user".format(str(vars["baseName"] if "baseName" in vars else "")))}
                }
            }
        }
    ]

    _items
}

get_items = _get_items_impl

_vars = {
    "baseName": cv.baseName
    "database": cv.databaseSpec
    "databaseIamUser": cv.databaseIamUser
    "databaseInstanceName": cv.databaseInstanceName
    "databaseName": cv.databaseName
    "databaseObjectName": cv.databaseObjectName
    "databaseUserObjectName": cv.databaseUserObjectName
    "env": cv.env
    "labels": cv.labels
    "managementPolicies": cv.managementPolicies
    "projectId": cv.env["projectId"] if "projectId" in cv.env else ""
    "region": cv.region
}

if option("combined", "false") != "true":
    items = {"items": get_items(cv.obs, _vars)}
