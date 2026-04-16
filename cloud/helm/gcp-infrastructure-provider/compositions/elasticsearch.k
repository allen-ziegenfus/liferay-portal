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
    _name = _meta?.name or ""

    _items = [
        kubernetes.Object {
            metadata = {
                annotations = {"crossplane.io/composition-resource-name": "elasticsearch-observer"}
                name = "{}-observer".format(vars["searchName"])
            }
            spec = {
                forProvider = {
                    manifest = {
                        "apiVersion": "elasticsearch.k8s.elastic.co/v1"
                        "kind": "Elasticsearch"
                        "metadata": {
                            "name": vars["searchName"]
                            "namespace": vars["searchNamespace"]
                        }
                    }
                }
                managementPolicy = "Observe"
            }
        },
        kubernetes.Object {
            metadata = {
                annotations = {"crossplane.io/composition-resource-name": "elasticsearch-secret-observer"}
                name = "{}-observer".format(vars["searchSecretName"])
            }
            spec = {
                forProvider = {
                    manifest = k8s_core.Secret {
                        metadata = {
                            name = vars["searchSecretName"]
                            namespace = vars["searchNamespace"]
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
                labels = vars["labels"]
                name = "{}-elasticsearch-connection-details-secret".format(_name)
            }
            spec = {
                forProvider = {
                    manifest = k8s_core.Secret {
                        data = {"ELASTICSEARCH_PASSWORD": _password}
                        metadata = {
                            labels = vars["labels"]
                            name = "elasticsearch-connection-details"
                            namespace = vars["namespace"]
                        }
                        stringData = {
                            "ELASTICSEARCH_URL": "http://{}-es-http.{}.svc:9200".format(vars["searchName"], vars["searchNamespace"])
                            "ELASTICSEARCH_USERNAME": "elastic"
                        }
                        type = "Opaque"
                    }
                }
                managementPolicy = vars["managementPolicy"]
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
