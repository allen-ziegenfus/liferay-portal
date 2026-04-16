import compositions.managed_service_details as msd

_vars = {
    "baseName": "test-base"
    "databaseIamUser": "test-user@test.iam"
    "databasePort": "5432"
    "instanceConnectionName": "test-instance"
    "labels": {"app": "liferay"}
    "managementPolicy": "Default"
    "namespace": "test-ns"
}

test_secret_created_when_ready = lambda {
    _obs = {
        "resources": {
            "liferay-db-grant-job": {
                "resource": {
                    "status": {
                        "conditions": [{"type": "Ready", "status": "True"}]
                    }
                }
            }
        }
    }
    _items = msd.get_items(_obs, _vars)
    assert len(_items) == 1, "Secret should be created when job is ready"
    assert _items[0].metadata.annotations["crossplane.io/composition-resource-name"] == "managed-service-details-secret"
}

test_secret_not_created_when_not_ready = lambda {
    _obs = {
        "resources": {
            "liferay-db-grant-job": {
                "resource": {
                    "status": {
                        "conditions": [{"type": "Ready", "status": "False"}]
                    }
                }
            }
        }
    }
    _items = msd.get_items(_obs, _vars)
    assert len(_items) == 0, "Secret should NOT be created when job status is False"
}

test_secret_not_created_when_missing = lambda {
    _obs = {}
    _items = msd.get_items(_obs, _vars)
    assert len(_items) == 0, "Secret should NOT be created when observations are missing"
}
