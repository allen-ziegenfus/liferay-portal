import compositions.managed_service_details as msd
import compositions.sql as sql
import compositions.storage as storage
import compositions.overlay as overlay
import compositions.security as security
import compositions.elasticsearch as es
import crypto

test_arz_dev2025_resource_names = lambda {
    _projectId = "arz"
    _environmentId = "dev2025"
    _projectNumber = "1010819446150"
    _projectIdFull = _projectId + "-" + _environmentId
    _uidHash = crypto.sha256(_projectNumber + "-" + _projectIdFull)[:6:]
    _baseName = _projectIdFull[:18:] + "-" + _uidHash
    _meta_name = "arz-dev2025-infra"
    _gsaEmail = "arz-dev2025-infra-sa@arz.iam.gserviceaccount.com"

    _vars: {str:any} = {
        "backup": {"enabled": False}
        "baseName": _baseName
        "cmkEnabled": False
        "cmkKeyName": ""
        "databaseIamUser": "arz-dev2025-infra-sa@arz.iam"
        "databaseInstanceName": "arz-dev2025-infra-db-instance"
        "databaseName": "liferay_db"
        "databasePort": "5432"
        "databaseSpec": {
            "databaseVersion": "POSTGRES_18"
            "deletionProtection": True
            "instanceType": "db-custom-1-3840"
            "queryInsightsEnabled": True
            "storageGB": 20
        }
        "env": {
            "projectId": "arz"
            "projectNumber": _projectNumber
            "deploymentName": "liferay-portal-poc"
            "vpcName": "liferay-portal-poc-vpc"
        }
        "forceDestroy": False
        "gsaEmail": _gsaEmail
        "gsaName": "arz-dev2025-infra-sa"
        "instanceConnectionName": "arz:us-central1:arz-dev2025-infra-db-instance"
        "jobName": _meta_name + "-db-grant"
        "labels": {
            "app": "liferay"
            "deployment-name": "liferay-portal-poc"
            "environment-id": _environmentId
            "project-id": _projectId
        }
        "managementPolicies": ["*"]
        "managementPolicy": "Default"
        "metadata": {"name": _meta_name}
        "namespace": "liferay-arz-dev2025"
        "overlay": {"enabled": True, "region": "us-south1", "data": {}}
        "overlayEnabled": True
        "region": "us-central1"
        "searchName": _meta_name + "-es"
        "searchNamespace": "liferay-arz-dev2025-elasticsearch"
        "searchSecretName": _meta_name + "-es-es-elastic-user"
        "storage_spec": {"enableVersioning": True}
    }

    _obs = {
        "resources": {
            "liferay-db-grant-job": {
                "resource": {
                    "status": {
                        "conditions": [{"type": "Ready", "status": "True"}]
                    }
                }
            },
            "elasticsearch-observer": {
                "resource": {"status": {"atProvider": {"manifest": {"status": {"health": "green"}}}}}
            },
            "elasticsearch-secret-observer": {
                "resource": {"status": {"atProvider": {"manifest": {"data": {"elastic": "dGVzdA=="}}}}}
            }
        }
    }

    _find_by_anno = lambda items: [any], anno: str -> any {
        _matches = [i for i in items if i?.metadata?.annotations?["crossplane.io/composition-resource-name"] == anno]
        _matches[0] if len(_matches) > 0 else None
    }

    _sec_items = security.get_items(_obs, _vars)
    assert _find_by_anno(_sec_items, "liferay-sql-instance-user-role") != None
    assert _find_by_anno(_sec_items, "liferay-sql-client-role") != None
    assert _find_by_anno(_sec_items, "liferay-wi-binding") != None
    assert _find_by_anno(_sec_items, "liferay-gsa").metadata.name == "arz-dev2025-infra-sa"

    _msd_items = msd.get_items(_obs, _vars)
    assert _find_by_anno(_msd_items, "managed-service-details-configmap") != None

    _sql_items = sql.get_items(_obs, _vars)
    assert _sql_items[0].metadata.name == "arz-dev2025-infra-db-instance"
    assert _sql_items[1].metadata.name == "liferay_db"
    assert _sql_items[2].metadata.name == "arz-dev2025-infra-sa@arz.iam"

    _storage_items = storage.get_items(_obs, _vars)
    assert _storage_items[0].metadata.name == "arz-dev2025-00d245-dl"
    assert _find_by_anno(_storage_items, "liferay-gcs-iam") != None
    
    _overlay_items = overlay.get_items(_obs, _vars)
    assert len(_overlay_items) == 3, "Should have 3 overlay items"
    assert _overlay_items[0].metadata.name == "arz-dev2025-00d245-overlay"
    assert _find_by_anno(_overlay_items, "overlay-iam") != None
    assert _overlay_items[2].metadata.name == "arz-dev2025-00d245-overlay-config"
    
    _es_items = es.get_items(_obs, _vars)
    assert _es_items[0].metadata.name == "arz-dev2025-infra-es-observer"
    assert _es_items[1].metadata.name == "arz-dev2025-infra-es-es-elastic-user-observer"
}
