import compositions.overlay as overlay

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

test_overlay_created_when_enabled = lambda {
    _items = overlay.get_items({}, _vars)
    assert len(_items) == 1, "Overlay should be created when enabled"
    assert _items[0].metadata.annotations["crossplane.io/composition-resource-name"] == "liferay-overlay-cm"
}

test_overlay_not_created_when_disabled = lambda {
    _vars_disabled = _vars | {
        overlay = {
            enabled = False
        }
    }
    _items = overlay.get_items({}, _vars_disabled)
    assert len(_items) == 0, "Overlay should NOT be created when disabled"
}

test_overlay_not_created_when_missing = lambda {
    _vars_missing = _vars | {
        overlay = None
    }
    _items = overlay.get_items({}, _vars_missing)
    assert len(_items) == 0, "Overlay should NOT be created when overlay spec is None"
}
