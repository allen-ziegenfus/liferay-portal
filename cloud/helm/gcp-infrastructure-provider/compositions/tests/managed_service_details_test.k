import compositions.managed_service_details as msd

_vars: {str:any} = {
    "baseName": "test-base"
    "gsaEmail": "test-sa@test.iam.gserviceaccount.com"
    "labels": {"app": "liferay"}
    "managementPolicies": ["*"]
    "metadata": {"name": "test-infra"}
    "namespace": "test-ns"
}

test_secret_created_when_ready = lambda {
    _obs = {}
    _items = msd.get_items(_obs, _vars)
    assert len(_items) == 1, "ConfigMap should be created"
    assert _items[0].metadata.annotations["crossplane.io/composition-resource-name"] == "managed-service-details-secret"
}
