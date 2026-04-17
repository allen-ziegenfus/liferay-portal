import context_variables as cv
import models.v1alpha1.kubernetesm_crossplane_io_v1alpha1_object as kubernetes
import k8s.api.batch.v1 as k8s_batch
import k8s.api.core.v1 as k8s_core

get_items = lambda obs: any, vars: {str:any} -> [any] {
    _db_spec = (vars["databaseSpec"] if "databaseSpec" in vars else {})
    _meta = (vars["metadata"] if "metadata" in vars else {})

    _liferay_sa = k8s_core.ServiceAccount {
            apiVersion = "v1"
            kind = "ServiceAccount"
        metadata = {
            annotations = {"iam.gke.io/gcp-service-account": vars["gsaEmail"]}
            labels = vars["labels"]
            name = "liferay-default"
            namespace = vars["namespace"]
        }
    }

    _k8s_items: [any] = [
        kubernetes.Object {
            apiVersion = "kubernetes.m.crossplane.io/v1alpha1"
            kind = "Object"
            metadata = {
                annotations = {"crossplane.io/composition-resource-name": "liferay-ksa"}
                labels = vars["labels"]
                name = "{}-ksa".format((_meta["name"] if "name" in _meta else ""))
            }
            spec = {
                forProvider = {"manifest": _liferay_sa}
                managementPolicies = vars["managementPolicies"] if "managementPolicies" in vars else ["*"]
            }
        }
    ]

    _liferay_job = k8s_batch.Job {
            apiVersion = "batch/v1"
            kind = "Job"
        metadata = {
            labels = vars["labels"]
            name = vars["jobName"]
            namespace = vars["namespace"]
        }
        spec = {
            template = {
                spec = {
                    containers = [{
                        args = [
                            """\
set -e
until pg_isready -h 127.0.0.1 -p {port} -U postgres; do sleep 2; done
psql -h 127.0.0.1 -v "ON_ERROR_STOP=1" -U postgres -d {db} <<EOF
GRANT ALL PRIVILEGES ON DATABASE "{db}" TO "{user}";
GRANT ALL ON ALL TABLES IN SCHEMA public TO "{user}";
GRANT cloudsqlsuperuser TO "{user}";
EOF
""".format(port=vars["databasePort"], db=vars["databaseName"], user=vars["databaseIamUser"])
                        ]
                        command = ["/bin/sh", "-c"]
                        env = [{
                            name = "PGPASSWORD"
                            valueFrom = {
                                "secretKeyRef": {"key": "password", "name": (_db_spec["rootPasswordSecretName"] if "rootPasswordSecretName" in _db_spec else "")}
                            }
                        }]
                        image = "postgres:18-alpine"
                        name = "sql-runner"
                        resources = {
                            limits = {"cpu": "200m", "memory": "256Mi"}
                            requests = {"cpu": "100m", "memory": "128Mi"}
                        }
                        securityContext = {
                            allowPrivilegeEscalation = False
                            capabilities = {"drop": ["ALL"]}
                            runAsNonRoot = True
                            runAsUser = 1000
                            seccompProfile = {"type": "RuntimeDefault"}
                        }
                    }]
                    initContainers = [{
                        args = [
                            "--auto-iam-authn"
                            "--port={}".format(vars["databasePort"])
                            "--private-ip"
                            "--structured-logs"
                            vars["instanceConnectionName"]
                        ]
                        image = "gcr.io/cloud-sql-connectors/cloud-sql-proxy:2.14.1"
                        name = "cloud-sql-proxy"
                        resources = {
                            limits = {"cpu": "200m", "memory": "256Mi"}
                            requests = {"cpu": "100m", "memory": "128Mi"}
                        }
                        restartPolicy = "Always"
                        securityContext = {
                            allowPrivilegeEscalation = False
                            capabilities = {"drop": ["ALL"]}
                            runAsNonRoot = True
                            runAsUser = 65532
                            seccompProfile = {"type": "RuntimeDefault"}
                        }
                    }]
                    restartPolicy = "OnFailure"
                    securityContext = {
                        fsGroup = 1000
                        runAsNonRoot = True
                        seccompProfile = {"type": "RuntimeDefault"}
                    }
                    serviceAccountName = "liferay-default"
                    volumes = [{"emptyDir": {}, "name": "term-log"}]
                }
            }
        }
    }

    _k8s_items += [kubernetes.Object {
            apiVersion = "kubernetes.m.crossplane.io/v1alpha1"
            kind = "Object"
        metadata = {
            annotations = {"crossplane.io/composition-resource-name": "liferay-db-grant-job"}
            labels = vars["labels"]
            name = vars["jobName"]
        }
        spec = {
            forProvider = {"manifest": _liferay_job}
            managementPolicies = vars["managementPoliciesOnce"] if "managementPoliciesOnce" in vars else ["Create", "Observe", "Delete"]
        }
    }]

    _k8s_items
}

_vars = {
    "databaseIamUser": cv.databaseIamUser
    "databaseName": cv.databaseName
    "databasePort": cv.databasePort
    "databaseSpec": cv.databaseSpec
    "gsaEmail": cv.gsaEmail
    "instanceConnectionName": cv.instanceConnectionName
    "jobName": cv.jobName
    "labels": cv.labels
    "managementPolicies": cv.managementPolicies
    "managementPolicy": cv.managementPolicy
    "metadata": cv.metadata
    "namespace": cv.namespace
}

if not option("combined") or option("combined") == "false":
    items = {"items": get_items(cv.obs, _vars)}
