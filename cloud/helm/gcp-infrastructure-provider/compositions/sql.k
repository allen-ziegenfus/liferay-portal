import .context_variables as cv
import .models.v1beta1.sql_gcpm_upbound_io_v1beta1_database as sql_db
import .models.v1beta1.sql_gcpm_upbound_io_v1beta1_database_instance as sql_instance
import .models.v1beta1.sql_gcpm_upbound_io_v1beta1_user as sql_user

get_items = lambda obs: any, vars: {str:any} -> [any] {
    _db_spec = vars["database"] if "database" in vars else {}
    _env = vars["env"] if "env" in vars else {}
    _labels = vars["labels"] if "labels" in vars else {}
    _managementPolicies = vars["managementPolicies"] if "managementPolicies" in vars else ["*"]

    _items: [any] = [
        sql_instance.DatabaseInstance {
            metadata = {
                annotations = {"crossplane.io/composition-resource-name": "liferay-db-instance"}
                labels = _labels
                name = str(vars["databaseInstanceName"] if "databaseInstanceName" in vars else "")
            }
            spec = {
                forProvider = {
                    databaseVersion = "POSTGRES_15"
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
            metadata = {
                annotations = {"crossplane.io/composition-resource-name": "liferay-database"}
                labels = _labels
                name = str(vars["databaseName"] if "databaseName" in vars else "")
            }
            spec = {
                forProvider = {
                    instanceRef = {
                        name = str(vars["databaseInstanceName"] if "databaseInstanceName" in vars else "")
                    }
                }
                managementPolicies = _managementPolicies
            }
        }
        sql_user.User {
            metadata = {
                annotations = {"crossplane.io/composition-resource-name": "liferay-db-iam-user"}
                labels = _labels
                name = str(vars["databaseIamUser"] if "databaseIamUser" in vars else "")
            }
            spec = {
                forProvider = {
                    instanceRef = {
                        name = str(vars["databaseInstanceName"] if "databaseInstanceName" in vars else "")
                    }
                    $type = "CLOUD_IAM_USER"
                }
                managementPolicies = _managementPolicies
            }
        }
    ]

    _items
}

_vars = {
    "database": cv.databaseSpec
    "databaseIamUser": cv.databaseIamUser
    "databaseInstanceName": cv.databaseInstanceName
    "databaseName": cv.databaseName
    "env": cv.env
    "labels": cv.labels
    "managementPolicies": cv.managementPolicies
    "projectId": cv.env["projectId"] if "projectId" in cv.env else ""
    "region": cv.region
}

if option("combined", "false") != "true":
    items = {"items": get_items(cv.obs, _vars)}
