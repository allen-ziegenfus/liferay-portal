import .context_variables as cv
import crossplane_provider_kubernetes.v1alpha1 as kubernetes
import k8s.api.batch.v1 as k8s_batch
import k8s.api.core.v1 as k8s_core

_liferay_sa = k8s_core.ServiceAccount {
    metadata = {
        annotations = {"iam.gke.io/gcp-service-account": cv.gsaEmail}
        labels = cv.labels
        name = "liferay-default"
        namespace = cv.namespace
    }
}

_k8s_items: [any] = [
    kubernetes.Object {
        metadata = {
            annotations = {"gotemplating.fn.crossplane.io/composition-resource-name": "liferay-ksa"}
            labels = cv.labels
            name = "{}-ksa".format(cv.metadata["name"] if "name" in cv.metadata else "")
        }
        spec = {
            forProvider = {"manifest": _liferay_sa}
            managementPolicy = cv.managementPolicy
        }
    }
]

_liferay_job = k8s_batch.Job {
    metadata = {
        labels = cv.labels
        name = cv.jobName
        namespace = cv.namespace
    }
    spec = {
        template = {
            spec = {
                containers = [{
                    args = [
                        "set -e\nuntil pg_isready -h 127.0.0.1 -p {} -U postgres; do sleep 2; done\npsql -h 127.0.0.1 -v \"ON_ERROR_STOP=1\" -U postgres -d {} <<EOF\nGRANT ALL PRIVILEGES ON DATABASE \"{}\" TO \"{}\";\nGRANT ALL ON ALL TABLES IN SCHEMA public TO \"{}\";\nGRANT cloudsqlsuperuser TO \"{}\";\nEOF\n".format(cv.databasePort, cv.databaseName, cv.databaseName, cv.databaseIamUser, cv.databaseIamUser, cv.databaseIamUser)
                    ]
                    command = ["/bin/sh", "-c"]
                    env = [{
                        name = "PGPASSWORD"
                        valueFrom = {
                            "secretKeyRef": {"key": "password", "name": cv.databaseSpec["rootPasswordSecretName"] if "rootPasswordSecretName" in cv.databaseSpec else ""}
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
                        "--port={}".format(cv.databasePort)
                        "--private-ip"
                        "--structured-logs"
                        cv.instanceConnectionName
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
    metadata = {
        annotations = {"gotemplating.fn.crossplane.io/composition-resource-name": "liferay-db-grant-job"}
        labels = cv.labels
        name = cv.jobName
    }
    spec = {
        forProvider = {"manifest": _liferay_job}
        managementPolicy = cv.managementPolicy
    }
}]

if not option("combined") or option("combined") == "false":
    items = {"items": _k8s_items}

