import compositions.overlay as overlay

test_overlay_created_when_enabled = lambda {
    _vars: {str:any} = {
        "labels": {"app": "liferay"}
        "managementPolicy": "Default"
        "metadata": {"name": "test-liferay"}
        "namespace": "test-ns"
        "overlay": {
            "enabled": True
            "data": {"foo": "bar"}
        }
    }
    _items = overlay.get_items({}, _vars)
    assert len(_items) == 3, "Overlay should be created when enabled (3 items)"
    assert _items[2].metadata.annotations["crossplane.io/composition-resource-name"] == "liferay-overlay-cm"
}

test_overlay_not_created_when_disabled = lambda {
    _vars: {str:any} = {
        "labels": {"app": "liferay"}
        "managementPolicy": "Default"
        "metadata": {"name": "test-liferay"}
        "namespace": "test-ns"
        "overlay": {
            "enabled": False
        }
    }
    _items = overlay.get_items({}, _vars)
    assert len(_items) == 0, "Overlay should NOT be created when disabled"
}

test_overlay_not_created_when_missing = lambda {
    _vars: {str:any} = {
        "labels": {"app": "liferay"}
        "managementPolicy": "Default"
        "metadata": {"name": "test-liferay"}
        "namespace": "test-ns"
        "overlay": None
    }
    _items = overlay.get_items({}, _vars)
    assert len(_items) == 0, "Overlay should NOT be created when overlay spec is None"
}
