import .context_variables as cv
import crossplane_provider_kubernetes.v1alpha1 as kubernetes

_elasticsearch_items: [any] = [kubernetes.Object {
    metadata = {
        annotations = {"crossplane.io/composition-resource-name": "elasticsearch-observer"}
        name = "{}-observer".format(cv.searchName)
    }
    spec = {
        forProvider = {
            manifest = {
                "apiVersion": "elasticsearch.k8s.elastic.co/v1"
                "kind": "Elasticsearch"
                "metadata": {
                    "name": cv.searchName
                    "namespace": cv.searchNamespace
                }
            }
        }
        managementPolicy = "Observe"
    }
}]

_elasticsearch_items += [kubernetes.Object {
    metadata = {
        annotations = {"crossplane.io/composition-resource-name": "elasticsearch-secret-observer"}
        name = "{}-observer".format(cv.searchSecretName)
    }
    spec = {
        forProvider = {
            manifest = {
                "apiVersion": "v1"
                "kind": "Secret"
                "metadata": {
                    "name": cv.searchSecretName
                    "namespace": cv.searchNamespace
                }
            }
        }
        managementPolicy = "Observe"
    }
}]

_obs_res = cv.obs["resources"] if "resources" in cv.obs else {}

_es_obs_entry = _obs_res["elasticsearch-observer"] if "elasticsearch-observer" in _obs_res else {}
_es_obj = _es_obs_entry["resource"] if "resource" in _es_obs_entry else {}
_es_status_raw = _es_obj["status"] if "status" in _es_obj else {}
_es_at_provider = _es_status_raw["atProvider"] if "atProvider" in _es_status_raw else {}
_es_manifest_status = _es_at_provider["manifest"]["status"] if "manifest" in _es_at_provider and "status" in _es_at_provider["manifest"] else {}
_es_health = _es_manifest_status["health"] if "health" in _es_manifest_status else ""
_is_search_ready = _es_health in ["green", "yellow"]

_sec_obs_entry = _obs_res["elasticsearch-secret-observer"] if "elasticsearch-secret-observer" in _obs_res else {}
_sec_obj = _sec_obs_entry["resource"] if "resource" in _sec_obs_entry else {}
_sec_status_raw = _sec_obj["status"] if "status" in _sec_obj else {}
_sec_at_provider = _sec_status_raw["atProvider"] if "atProvider" in _sec_status_raw else {}
_sec_manifest_data = _sec_at_provider["manifest"]["data"] if "manifest" in _sec_at_provider and "data" in _sec_at_provider["manifest"] else {}
_es_password = _sec_manifest_data["elastic"] if "elastic" in _sec_manifest_data else ""

if _is_search_ready and _es_password:
    _elasticsearch_items += [kubernetes.Object {
        metadata = {
            annotations = {
                "crossplane.io/external-name": "elasticsearch-connection-details"
                "crossplane.io/composition-resource-name": "elasticsearch-connection-details-secret"
            }
            labels = cv.labels
            name = "{}-elasticsearch-connection-details-secret".format(cv.metadata["name"] if "name" in cv.metadata else "")
        }
        spec = {
            forProvider = {
                manifest = {
                    "apiVersion": "v1"
                    "data": {"ELASTICSEARCH_PASSWORD": _es_password}
                    "kind": "Secret"
                    "metadata": {
                        "labels": cv.labels
                        "name": "elasticsearch-connection-details"
                        "namespace": cv.namespace
                    }
                    "stringData": {
                        "ELASTICSEARCH_URL": "http://{}-es-http.{}.svc:9200".format(cv.searchName, cv.searchNamespace)
                        "ELASTICSEARCH_USERNAME": "elastic"
                    }
                    "type": "Opaque"
                }
            }
            managementPolicy = cv.managementPolicy
        }
    }]

if not option("combined") or option("combined") == "false":
    items = {"items": _elasticsearch_items}

