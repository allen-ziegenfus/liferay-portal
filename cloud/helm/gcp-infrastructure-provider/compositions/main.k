import .models
import context_variables as cv
import .init
import .security
import .sql
import .storage
import .overlay
import .k8s
import .elasticsearch
import .backup
import .managed_service_details

_items = []
_items += init.get_items(cv.obs, cv._vars)
_items += security.get_items(cv.obs, cv._vars)
_items += sql.get_items(cv.obs, cv._vars)
_items += storage.get_items(cv.obs, cv._vars)
_items += overlay.get_items(cv.obs, cv._vars)
_items += k8s.get_items(cv.obs, cv._vars)
_items += elasticsearch.get_items(cv.obs, cv._vars)
_items += backup.get_items(cv.obs, cv._vars)
_items += managed_service_details.get_items(cv.obs, cv._vars)

items = {"items": _items}
