import .context_variables as cv
import crypto

items = {"items": [{
    "apiVersion": "apiextensions.crossplane.io/v1alpha1"
    "kind": "Context"
    "data": {
        "backup": cv.backup
        "backupTargetLabels": cv.backupTargetLabels
        "baseName": cv.baseName
        "cmkEnabled": cv.cmkEnabled
        "cmkKeyName": cv.cmkKeyName
        "databaseIamUser": cv.databaseIamUser
        "databaseInstanceName": cv.databaseInstanceName
        "databaseName": cv.databaseName
        "databasePort": cv.databasePort
        "databaseSpec": cv.databaseSpec
        "elasticsearchHealth": ""
        "environmentId": cv.environmentId
        "forceDestroy": cv.forceDestroy
        "gsaEmail": cv.gsaEmail
        "gsaName": cv.gsaName
        "hash": crypto.sha256("{}-{}".format(cv.databaseName, cv.env["projectId"] if "projectId" in cv.env else ""))[:7:]
        "instanceConnectionName": cv.instanceConnectionName
        "isReady": False
        "isSearchReady": False
        "jobName": cv.jobName
        "labels": cv.labels
        "managementPolicies": cv.managementPolicies
        "managementPoliciesNoUpdate": cv.managementPoliciesNoUpdate
        "managementPoliciesOnce": cv.managementPoliciesOnce
        "namespace": cv.namespace
        "overlay": cv.overlay
        "projectId": cv.projectId
        "projectIdFull": cv.projectIdFull
        "region": cv.region
        "searchName": cv.searchName
        "searchNamespace": cv.searchNamespace
        "searchSecretName": cv.searchSecretName
        "storage": cv.storage_spec
        "uidHash": crypto.sha256("{}-{}".format(cv.env["projectNumber"] if "projectNumber" in cv.env else "", cv.projectIdFull))[:6:]
    }
}]}
