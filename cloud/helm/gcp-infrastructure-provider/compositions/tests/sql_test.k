import compositions.sql as sql

test_sql_orphan_policy = lambda {
    _vars: {str:any} = {
        "cmkEnabled": True
        "cmkKeyName": "projects/p1/locations/global/keyRings/kr1/cryptoKeys/k1"
        "databaseIamUser": "test-sa@p1.iam"
        "databaseInstanceName": "test-db-instance"
        "databaseName": "lportal"
        "databaseSpec": {
            "databaseVersion": "POSTGRES_15"
            "rootPasswordSecretName": "root-pwd"
            "storageGB": 50
        }
        "env": {"vpcName": "test-vpc", "projectId": "p1"}
        "forceDestroy": False
        "labels": {"app": "liferay"}
        "managementPolicies": ["Create", "Observe", "Update"]
        "metadata": {"name": "test-infra"}
        "namespace": "test-ns"
        "projectId": "p1"
        "region": "us-east1"
    }
    _items = sql.get_items({}, _vars)
    assert len(_items) == 5
    
    _db_instance = _items[0]
    assert _db_instance.spec.forProvider.deletionProtection == True
    assert _db_instance.spec.forProvider.databaseVersion == "POSTGRES_15"
    assert _db_instance.spec.managementPolicies == ["Create", "Observe", "Update"]
}
