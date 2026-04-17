import compositions.overlay as overlay

_vars: {str:any} = {
    "baseName": "test-base"
    "gsaEmail": "test-sa@test.iam.gserviceaccount.com"
    "labels": {"app": "liferay"}
    "managementPolicies": ["*"]
    "namespace": "test-ns"
    "overlayEnabled": True
    "region": "us-central1"
}

test_overlay_created_when_enabled = lambda {
    _items = overlay.get_items({}, _vars)
    assert len(_items) == 3, "Overlay should be created when enabled (3 items), got {}".format(len(_items))
    assert _items[0].metadata.annotations["crossplane.io/composition-resource-name"] == "overlay-bucket"
    assert _items[1].metadata.annotations["crossplane.io/composition-resource-name"] == "overlay-iam"
    assert _items[2].metadata.annotations["crossplane.io/composition-resource-name"] == "overlay-configmap"
}

test_overlay_not_created_when_disabled = lambda {
    _vars_disabled = {**_vars, overlayEnabled = False}
    _items = overlay.get_items({}, _vars_disabled)
    assert len(_items) == 0, "Overlay should NOT be created when disabled"
}

test_overlay_not_created_when_missing = lambda {
    _vars_missing = {**_vars, overlayEnabled = None}
    _items = overlay.get_items({}, _vars_missing)
    assert len(_items) == 0, "Overlay should NOT be created when missing"
}
