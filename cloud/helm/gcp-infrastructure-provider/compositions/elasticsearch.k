import .context_variables as cv
import crossplane_provider_kubernetes.v1alpha1 as kubernetes
import k8s.api.core.v1 as k8s_core

get_items = lambda obs: any, vars: {str:any} -> [any] {
    _res = obs?.resources or {}

    _es_status = _res?["elasticsearch-observer"]?.resource?.status?.atProvider?.manifest?.status or {}
    _sec_data = _res?["elasticsearch-secret-observer"]?.resource?.status?.atProvider?.manifest?.data or {}

    _health = _es_status?.health or ""
    _password = _sec_data?.elastic or ""

    _is_ready = _health in ["green", "yellow"] and _password

    _meta = vars?.metadata or {}
    _name = str(_meta?.name or "")

    _items = [
        kubernetes.Object {
            metadata = {
                annotations = {"crossplane.io/composition-resource-name": "elasticsearch-observer"}
                name = "{}-es-observer".format(_name)
            }
            spec = {
                forProvider = {
                    manifest = {
                        "apiVersion": "elasticsearch.k8s.elastic.co/v1"
                        "kind": "Elasticsearch"
                        "metadata": {
                            "name": str(vars.get("searchName") or "")
                            "namespace": str(vars.get("searchNamespace") or "")
                        }
                    }
                }
                managementPolicy = "Observe"
            }
        }
        kubernetes.Object {
            metadata = {
                annotations = {"crossplane.io/composition-resource-name": "elasticsearch-secret-observer"}
                name = "{}-es-es-elastic-user-observer".format(_name)
            }
            spec = {
                forProvider = {
                    manifest = k8s_core.Secret {
                        metadata = {
                            name = str(vars.get("searchSecretName") or "")
                            namespace = str(vars.get("searchNamespace") or "")
                        }
                    }
                }
                managementPolicy = "Observe"
            }
        }
    ]

    if _is_ready:
        _items += [kubernetes.Object {
            metadata = {
                annotations = {
                    "crossplane.io/external-name": "elasticsearch-connection-details"
                    "crossplane.io/composition-resource-name": "elasticsearch-connection-details-secret"
                }
                labels = vars.get("labels") or {}
                name = "{}-elasticsearch-connection-details-secret".format(_name)
            }
            spec = {
                forProvider = {
                    manifest = k8s_core.Secret {
                        data = {"ELASTICSEARCH_PASSWORD": _password}
                        metadata = {
                            labels = vars.get("labels") or {}
                            name = "elasticsearch-connection-details"
                            namespace = str(vars.get("namespace") or "")
                        }
                        stringData = {
                            "ELASTICSEARCH_URL": "http://{}-es-http.{}.svc:9200".format(str(vars.get("searchName") or ""), str(vars.get("searchNamespace") or ""))
                            "ELASTICSEARCH_USERNAME": "elastic"
                        }
                        type = "Opaque"
                    }
                }
                managementPolicy = str(vars.get("managementPolicy") or "Default")
            }
        }]

    _items
}

_vars = {
    "labels": cv.labels
    "managementPolicy": cv.managementPolicy
    "metadata": cv.metadata
    "namespace": cv.namespace
    "searchName": cv.searchName
    "searchNamespace": cv.searchNamespace
    "searchSecretName": cv.searchSecretName
}

items = {"items": get_items(cv.obs, _vars) if not option("combined") or option("combined") == "false" else []}
