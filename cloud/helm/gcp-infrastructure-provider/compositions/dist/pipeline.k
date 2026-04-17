import crypto
import yaml
import json
import k8s.api.core.v1 as k8s_core
import k8s.api.batch.v1 as k8s_batch
import k8s.api.rbac.v1 as k8s_rbac
import k8s.apimachinery.pkg.apis.meta.v1 as v1

# --- MODELS ---



schema ProjectIAMMember:
    r"""
    ProjectIAMMember is the Schema for the ProjectIAMMembers API. <no value>

    Attributes
    ----------
    apiVersion : str, default is "cloudplatform.gcp.m.upbound.io/v1beta1", required
        APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
    kind : str, default is "ProjectIAMMember", required
        Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
    metadata : v1.ObjectMeta, default is Undefined, optional
        metadata
    spec : CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberSpec, default is Undefined, required
        spec
    status : CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberStatus, default is Undefined, optional
        status
    """


    apiVersion: "cloudplatform.gcp.m.upbound.io/v1beta1" = "cloudplatform.gcp.m.upbound.io/v1beta1"

    kind: "ProjectIAMMember" = "ProjectIAMMember"

    metadata?: v1.ObjectMeta

    spec: CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberSpec

    status?: CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberStatus


schema CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberSpec:
    r"""
    ProjectIAMMemberSpec defines the desired state of ProjectIAMMember

    Attributes
    ----------
    managementPolicies : [str], default is ["*"], optional
        THIS IS A BETA FIELD. It is on by default but can be opted out
        through a Crossplane feature flag.
        ManagementPolicies specify the array of actions Crossplane is allowed to
        take on the managed and external resources.
        See the design doc for more information: https://github.com/crossplane/crossplane/blob/499895a25d1a1a0ba1604944ef98ac7a1a71f197/design/design-doc-observe-only-resources.md?plain=1#L223
        and this one: https://github.com/crossplane/crossplane/blob/444267e84783136daa93568b364a5f01228cacbe/design/one-pager-ignore-changes.md
    forProvider : CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberSpecForProvider, default is Undefined, required
        for provider
    initProvider : CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberSpecInitProvider, default is Undefined, optional
        init provider
    providerConfigRef : CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberSpecProviderConfigRef, default is Undefined, optional
        provider config ref
    writeConnectionSecretToRef : CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberSpecWriteConnectionSecretToRef, default is Undefined, optional
        write connection secret to ref
    """


    managementPolicies?: [str] = ["*"]

    forProvider: CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberSpecForProvider

    initProvider?: CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberSpecInitProvider

    providerConfigRef?: CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberSpecProviderConfigRef

    writeConnectionSecretToRef?: CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberSpecWriteConnectionSecretToRef


schema CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberSpecForProvider:
    r"""
    cloudplatform gcpm upbound io v1beta1 project i a m member spec for provider

    Attributes
    ----------
    member : str, default is Undefined, optional
        member
    project : str, default is Undefined, optional
        project
    role : str, default is Undefined, optional
        role
    condition : CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberSpecForProviderCondition, default is Undefined, optional
        condition
    projectRef : CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberSpecForProviderProjectRef, default is Undefined, optional
        project ref
    projectSelector : CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberSpecForProviderProjectSelector, default is Undefined, optional
        project selector
    """


    member?: str

    project?: str

    role?: str

    condition?: CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberSpecForProviderCondition

    projectRef?: CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberSpecForProviderProjectRef

    projectSelector?: CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberSpecForProviderProjectSelector


schema CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberSpecForProviderCondition:
    r"""
    cloudplatform gcpm upbound io v1beta1 project i a m member spec for provider condition

    Attributes
    ----------
    description : str, default is Undefined, optional
        description
    expression : str, default is Undefined, optional
        expression
    title : str, default is Undefined, optional
        title
    """


    description?: str

    expression?: str

    title?: str


schema CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberSpecForProviderProjectRef:
    r"""
    Reference to a Project in cloudplatform to populate project.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberSpecForProviderProjectRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberSpecForProviderProjectRefPolicy


schema CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberSpecForProviderProjectRefPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"


schema CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberSpecForProviderProjectSelector:
    r"""
    Selector for a Project in cloudplatform to populate project.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberSpecForProviderProjectSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberSpecForProviderProjectSelectorPolicy


schema CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberSpecForProviderProjectSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"


schema CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberSpecInitProvider:
    r"""
    THIS IS A BETA FIELD. It will be honored
    unless the Management Policies feature flag is disabled.
    InitProvider holds the same fields as ForProvider, with the exception
    of Identifier and other resource reference fields. The fields that are
    in InitProvider are merged into ForProvider when the resource is created.
    The same fields are also added to the terraform ignore_changes hook, to
    avoid updating them after creation. This is useful for fields that are
    required on creation, but we do not desire to update them after creation,
    for example because of an external controller is managing them, like an
    autoscaler.

    Attributes
    ----------
    member : str, default is Undefined, optional
        member
    project : str, default is Undefined, optional
        project
    role : str, default is Undefined, optional
        role
    condition : CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberSpecInitProviderCondition, default is Undefined, optional
        condition
    projectRef : CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberSpecInitProviderProjectRef, default is Undefined, optional
        project ref
    projectSelector : CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberSpecInitProviderProjectSelector, default is Undefined, optional
        project selector
    """


    member?: str

    project?: str

    role?: str

    condition?: CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberSpecInitProviderCondition

    projectRef?: CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberSpecInitProviderProjectRef

    projectSelector?: CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberSpecInitProviderProjectSelector


schema CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberSpecInitProviderCondition:
    r"""
    cloudplatform gcpm upbound io v1beta1 project i a m member spec init provider condition

    Attributes
    ----------
    description : str, default is Undefined, optional
        description
    expression : str, default is Undefined, optional
        expression
    title : str, default is Undefined, optional
        title
    """


    description?: str

    expression?: str

    title?: str


schema CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberSpecInitProviderProjectRef:
    r"""
    Reference to a Project in cloudplatform to populate project.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberSpecInitProviderProjectRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberSpecInitProviderProjectRefPolicy


schema CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberSpecInitProviderProjectRefPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"


schema CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberSpecInitProviderProjectSelector:
    r"""
    Selector for a Project in cloudplatform to populate project.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberSpecInitProviderProjectSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberSpecInitProviderProjectSelectorPolicy


schema CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberSpecInitProviderProjectSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"


schema CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberSpecProviderConfigRef:
    r"""
    ProviderConfigReference specifies how the provider that will be used to
    create, observe, update, and delete this managed resource should be
    configured.

    Attributes
    ----------
    kind : str, default is Undefined, required
        Kind of the referenced object.
    name : str, default is Undefined, required
        Name of the referenced object.
    """


    kind: str

    name: str


schema CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberSpecWriteConnectionSecretToRef:
    r"""
    WriteConnectionSecretToReference specifies the namespace and name of a
    Secret to which any connection details for this managed resource should
    be written. Connection details frequently include the endpoint, username,
    and password required to connect to the managed resource.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the secret.
    """


    name: str


schema CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberStatus:
    r"""
    ProjectIAMMemberStatus defines the observed state of ProjectIAMMember.

    Attributes
    ----------
    conditions : [CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberStatusConditionsItems0], default is Undefined, optional
        Conditions of the resource.
    observedGeneration : int, default is Undefined, optional
        ObservedGeneration is the latest metadata.generation
        which resulted in either a ready state, or stalled due to error
        it can not recover from without human intervention.
    atProvider : CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberStatusAtProvider, default is Undefined, optional
        at provider
    """


    conditions?: [CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberStatusConditionsItems0]

    observedGeneration?: int

    atProvider?: CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberStatusAtProvider


schema CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberStatusAtProvider:
    r"""
    cloudplatform gcpm upbound io v1beta1 project i a m member status at provider

    Attributes
    ----------
    etag : str, default is Undefined, optional
        etag
    id : str, default is Undefined, optional
        id
    member : str, default is Undefined, optional
        member
    project : str, default is Undefined, optional
        project
    role : str, default is Undefined, optional
        role
    condition : CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberStatusAtProviderCondition, default is Undefined, optional
        condition
    """


    etag?: str

    id?: str

    member?: str

    project?: str

    role?: str

    condition?: CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberStatusAtProviderCondition


schema CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberStatusAtProviderCondition:
    r"""
    cloudplatform gcpm upbound io v1beta1 project i a m member status at provider condition

    Attributes
    ----------
    description : str, default is Undefined, optional
        description
    expression : str, default is Undefined, optional
        expression
    title : str, default is Undefined, optional
        title
    """


    description?: str

    expression?: str

    title?: str


schema CloudplatformGcpmUpboundIoV1beta1ProjectIAMMemberStatusConditionsItems0:
    r"""
    A Condition that may apply to a resource.

    Attributes
    ----------
    lastTransitionTime : str, default is Undefined, required
        LastTransitionTime is the last time this condition transitioned from one
        status to another.
    message : str, default is Undefined, optional
        A Message containing details about this condition's last transition from
        one status to another, if any.
    observedGeneration : int, default is Undefined, optional
        ObservedGeneration represents the .metadata.generation that the condition was set based upon.
        For instance, if .metadata.generation is currently 12, but the .status.conditions[x].observedGeneration is 9, the condition is out of date
        with respect to the current state of the instance.
    reason : str, default is Undefined, required
        A Reason for this condition's last transition from one status to another.
    status : str, default is Undefined, required
        Status of this condition; is it currently True, False, or Unknown?
    $type : str, default is Undefined, required
        Type of this condition. At most one of each condition type may apply to
        a resource at any point in time.
    """


    lastTransitionTime: str

    message?: str

    observedGeneration?: int

    reason: str

    status: str

    $type: str






schema ServiceAccount:
    r"""
    ServiceAccount is the Schema for the ServiceAccounts API. Allows management of a Google Cloud Platform service account.

    Attributes
    ----------
    apiVersion : str, default is "cloudplatform.gcp.m.upbound.io/v1beta1", required
        APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
    kind : str, default is "ServiceAccount", required
        Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
    metadata : v1.ObjectMeta, default is Undefined, optional
        metadata
    spec : CloudplatformGcpmUpboundIoV1beta1ServiceAccountSpec, default is Undefined, required
        spec
    status : CloudplatformGcpmUpboundIoV1beta1ServiceAccountStatus, default is Undefined, optional
        status
    """


    apiVersion: "cloudplatform.gcp.m.upbound.io/v1beta1" = "cloudplatform.gcp.m.upbound.io/v1beta1"

    kind: "ServiceAccount" = "ServiceAccount"

    metadata?: v1.ObjectMeta

    spec: CloudplatformGcpmUpboundIoV1beta1ServiceAccountSpec

    status?: CloudplatformGcpmUpboundIoV1beta1ServiceAccountStatus


schema CloudplatformGcpmUpboundIoV1beta1ServiceAccountSpec:
    r"""
    ServiceAccountSpec defines the desired state of ServiceAccount

    Attributes
    ----------
    managementPolicies : [str], default is ["*"], optional
        THIS IS A BETA FIELD. It is on by default but can be opted out
        through a Crossplane feature flag.
        ManagementPolicies specify the array of actions Crossplane is allowed to
        take on the managed and external resources.
        See the design doc for more information: https://github.com/crossplane/crossplane/blob/499895a25d1a1a0ba1604944ef98ac7a1a71f197/design/design-doc-observe-only-resources.md?plain=1#L223
        and this one: https://github.com/crossplane/crossplane/blob/444267e84783136daa93568b364a5f01228cacbe/design/one-pager-ignore-changes.md
    forProvider : CloudplatformGcpmUpboundIoV1beta1ServiceAccountSpecForProvider, default is Undefined, required
        for provider
    initProvider : CloudplatformGcpmUpboundIoV1beta1ServiceAccountSpecInitProvider, default is Undefined, optional
        init provider
    providerConfigRef : CloudplatformGcpmUpboundIoV1beta1ServiceAccountSpecProviderConfigRef, default is Undefined, optional
        provider config ref
    writeConnectionSecretToRef : CloudplatformGcpmUpboundIoV1beta1ServiceAccountSpecWriteConnectionSecretToRef, default is Undefined, optional
        write connection secret to ref
    """


    managementPolicies?: [str] = ["*"]

    forProvider: CloudplatformGcpmUpboundIoV1beta1ServiceAccountSpecForProvider

    initProvider?: CloudplatformGcpmUpboundIoV1beta1ServiceAccountSpecInitProvider

    providerConfigRef?: CloudplatformGcpmUpboundIoV1beta1ServiceAccountSpecProviderConfigRef

    writeConnectionSecretToRef?: CloudplatformGcpmUpboundIoV1beta1ServiceAccountSpecWriteConnectionSecretToRef


schema CloudplatformGcpmUpboundIoV1beta1ServiceAccountSpecForProvider:
    r"""
    cloudplatform gcpm upbound io v1beta1 service account spec for provider

    Attributes
    ----------
    createIgnoreAlreadyExists : bool, default is Undefined, optional
        If set to true, skip service account creation if a service account with the same email already exists.
    description : str, default is Undefined, optional
        A text description of the service account.
        Must be less than or equal to 256 UTF-8 bytes.
    disabled : bool, default is Undefined, optional
        Whether a service account is disabled or not. Defaults to false. This field has no effect during creation.
        Must be set after creation to disable a service account.
    displayName : str, default is Undefined, optional
        The display name for the service account.
        Can be updated without creating a new resource.
    project : str, default is Undefined, optional
        The ID of the project that the service account will be created in.
        Defaults to the provider project configuration.
    """


    createIgnoreAlreadyExists?: bool

    description?: str

    disabled?: bool

    displayName?: str

    project?: str


schema CloudplatformGcpmUpboundIoV1beta1ServiceAccountSpecInitProvider:
    r"""
    THIS IS A BETA FIELD. It will be honored
    unless the Management Policies feature flag is disabled.
    InitProvider holds the same fields as ForProvider, with the exception
    of Identifier and other resource reference fields. The fields that are
    in InitProvider are merged into ForProvider when the resource is created.
    The same fields are also added to the terraform ignore_changes hook, to
    avoid updating them after creation. This is useful for fields that are
    required on creation, but we do not desire to update them after creation,
    for example because of an external controller is managing them, like an
    autoscaler.

    Attributes
    ----------
    createIgnoreAlreadyExists : bool, default is Undefined, optional
        If set to true, skip service account creation if a service account with the same email already exists.
    description : str, default is Undefined, optional
        A text description of the service account.
        Must be less than or equal to 256 UTF-8 bytes.
    disabled : bool, default is Undefined, optional
        Whether a service account is disabled or not. Defaults to false. This field has no effect during creation.
        Must be set after creation to disable a service account.
    displayName : str, default is Undefined, optional
        The display name for the service account.
        Can be updated without creating a new resource.
    project : str, default is Undefined, optional
        The ID of the project that the service account will be created in.
        Defaults to the provider project configuration.
    """


    createIgnoreAlreadyExists?: bool

    description?: str

    disabled?: bool

    displayName?: str

    project?: str


schema CloudplatformGcpmUpboundIoV1beta1ServiceAccountSpecProviderConfigRef:
    r"""
    ProviderConfigReference specifies how the provider that will be used to
    create, observe, update, and delete this managed resource should be
    configured.

    Attributes
    ----------
    kind : str, default is Undefined, required
        Kind of the referenced object.
    name : str, default is Undefined, required
        Name of the referenced object.
    """


    kind: str

    name: str


schema CloudplatformGcpmUpboundIoV1beta1ServiceAccountSpecWriteConnectionSecretToRef:
    r"""
    WriteConnectionSecretToReference specifies the namespace and name of a
    Secret to which any connection details for this managed resource should
    be written. Connection details frequently include the endpoint, username,
    and password required to connect to the managed resource.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the secret.
    """


    name: str


schema CloudplatformGcpmUpboundIoV1beta1ServiceAccountStatus:
    r"""
    ServiceAccountStatus defines the observed state of ServiceAccount.

    Attributes
    ----------
    conditions : [CloudplatformGcpmUpboundIoV1beta1ServiceAccountStatusConditionsItems0], default is Undefined, optional
        Conditions of the resource.
    observedGeneration : int, default is Undefined, optional
        ObservedGeneration is the latest metadata.generation
        which resulted in either a ready state, or stalled due to error
        it can not recover from without human intervention.
    atProvider : CloudplatformGcpmUpboundIoV1beta1ServiceAccountStatusAtProvider, default is Undefined, optional
        at provider
    """


    conditions?: [CloudplatformGcpmUpboundIoV1beta1ServiceAccountStatusConditionsItems0]

    observedGeneration?: int

    atProvider?: CloudplatformGcpmUpboundIoV1beta1ServiceAccountStatusAtProvider


schema CloudplatformGcpmUpboundIoV1beta1ServiceAccountStatusAtProvider:
    r"""
    cloudplatform gcpm upbound io v1beta1 service account status at provider

    Attributes
    ----------
    createIgnoreAlreadyExists : bool, default is Undefined, optional
        If set to true, skip service account creation if a service account with the same email already exists.
    description : str, default is Undefined, optional
        A text description of the service account.
        Must be less than or equal to 256 UTF-8 bytes.
    disabled : bool, default is Undefined, optional
        Whether a service account is disabled or not. Defaults to false. This field has no effect during creation.
        Must be set after creation to disable a service account.
    displayName : str, default is Undefined, optional
        The display name for the service account.
        Can be updated without creating a new resource.
    email : str, default is Undefined, optional
        The e-mail address of the service account. This value
        should be referenced from any google_iam_policy data sources
        that would grant the service account privileges.
    id : str, default is Undefined, optional
        an identifier for the resource with format projects/{{project}}/serviceAccounts/{{email}}
    member : str, default is Undefined, optional
        The Identity of the service account in the form serviceAccount:{email}. This value is often used to refer to the service account in order to grant IAM permissions.
    name : str, default is Undefined, optional
        The fully-qualified name of the service account.
    project : str, default is Undefined, optional
        The ID of the project that the service account will be created in.
        Defaults to the provider project configuration.
    uniqueId : str, default is Undefined, optional
        The unique id of the service account.
    """


    createIgnoreAlreadyExists?: bool

    description?: str

    disabled?: bool

    displayName?: str

    email?: str

    id?: str

    member?: str

    name?: str

    project?: str

    uniqueId?: str


schema CloudplatformGcpmUpboundIoV1beta1ServiceAccountStatusConditionsItems0:
    r"""
    A Condition that may apply to a resource.

    Attributes
    ----------
    lastTransitionTime : str, default is Undefined, required
        LastTransitionTime is the last time this condition transitioned from one
        status to another.
    message : str, default is Undefined, optional
        A Message containing details about this condition's last transition from
        one status to another, if any.
    observedGeneration : int, default is Undefined, optional
        ObservedGeneration represents the .metadata.generation that the condition was set based upon.
        For instance, if .metadata.generation is currently 12, but the .status.conditions[x].observedGeneration is 9, the condition is out of date
        with respect to the current state of the instance.
    reason : str, default is Undefined, required
        A Reason for this condition's last transition from one status to another.
    status : str, default is Undefined, required
        Status of this condition; is it currently True, False, or Unknown?
    $type : str, default is Undefined, required
        Type of this condition. At most one of each condition type may apply to
        a resource at any point in time.
    """


    lastTransitionTime: str

    message?: str

    observedGeneration?: int

    reason: str

    status: str

    $type: str






schema ServiceAccountIAMMember:
    r"""
    ServiceAccountIAMMember is the Schema for the ServiceAccountIAMMembers API. <no value>

    Attributes
    ----------
    apiVersion : str, default is "cloudplatform.gcp.m.upbound.io/v1beta1", required
        APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
    kind : str, default is "ServiceAccountIAMMember", required
        Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
    metadata : v1.ObjectMeta, default is Undefined, optional
        metadata
    spec : CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberSpec, default is Undefined, required
        spec
    status : CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberStatus, default is Undefined, optional
        status
    """


    apiVersion: "cloudplatform.gcp.m.upbound.io/v1beta1" = "cloudplatform.gcp.m.upbound.io/v1beta1"

    kind: "ServiceAccountIAMMember" = "ServiceAccountIAMMember"

    metadata?: v1.ObjectMeta

    spec: CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberSpec

    status?: CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberStatus


schema CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberSpec:
    r"""
    ServiceAccountIAMMemberSpec defines the desired state of ServiceAccountIAMMember

    Attributes
    ----------
    managementPolicies : [str], default is ["*"], optional
        THIS IS A BETA FIELD. It is on by default but can be opted out
        through a Crossplane feature flag.
        ManagementPolicies specify the array of actions Crossplane is allowed to
        take on the managed and external resources.
        See the design doc for more information: https://github.com/crossplane/crossplane/blob/499895a25d1a1a0ba1604944ef98ac7a1a71f197/design/design-doc-observe-only-resources.md?plain=1#L223
        and this one: https://github.com/crossplane/crossplane/blob/444267e84783136daa93568b364a5f01228cacbe/design/one-pager-ignore-changes.md
    forProvider : CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberSpecForProvider, default is Undefined, required
        for provider
    initProvider : CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberSpecInitProvider, default is Undefined, optional
        init provider
    providerConfigRef : CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberSpecProviderConfigRef, default is Undefined, optional
        provider config ref
    writeConnectionSecretToRef : CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberSpecWriteConnectionSecretToRef, default is Undefined, optional
        write connection secret to ref
    """


    managementPolicies?: [str] = ["*"]

    forProvider: CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberSpecForProvider

    initProvider?: CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberSpecInitProvider

    providerConfigRef?: CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberSpecProviderConfigRef

    writeConnectionSecretToRef?: CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberSpecWriteConnectionSecretToRef


schema CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberSpecForProvider:
    r"""
    cloudplatform gcpm upbound io v1beta1 service account i a m member spec for provider

    Attributes
    ----------
    member : str, default is Undefined, optional
        member
    role : str, default is Undefined, optional
        role
    serviceAccountId : str, default is Undefined, optional
        service account Id
    condition : CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberSpecForProviderCondition, default is Undefined, optional
        condition
    serviceAccountIdRef : CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberSpecForProviderServiceAccountIDRef, default is Undefined, optional
        service account Id ref
    serviceAccountIdSelector : CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberSpecForProviderServiceAccountIDSelector, default is Undefined, optional
        service account Id selector
    """


    member?: str

    role?: str

    serviceAccountId?: str

    condition?: CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberSpecForProviderCondition

    serviceAccountIdRef?: CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberSpecForProviderServiceAccountIDRef

    serviceAccountIdSelector?: CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberSpecForProviderServiceAccountIDSelector


schema CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberSpecForProviderCondition:
    r"""
    cloudplatform gcpm upbound io v1beta1 service account i a m member spec for provider condition

    Attributes
    ----------
    description : str, default is Undefined, optional
        description
    expression : str, default is Undefined, optional
        expression
    title : str, default is Undefined, optional
        title
    """


    description?: str

    expression?: str

    title?: str


schema CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberSpecForProviderServiceAccountIDRef:
    r"""
    Reference to a ServiceAccount in cloudplatform to populate serviceAccountId.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberSpecForProviderServiceAccountIDRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberSpecForProviderServiceAccountIDRefPolicy


schema CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberSpecForProviderServiceAccountIDRefPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"


schema CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberSpecForProviderServiceAccountIDSelector:
    r"""
    Selector for a ServiceAccount in cloudplatform to populate serviceAccountId.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberSpecForProviderServiceAccountIDSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberSpecForProviderServiceAccountIDSelectorPolicy


schema CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberSpecForProviderServiceAccountIDSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"


schema CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberSpecInitProvider:
    r"""
    THIS IS A BETA FIELD. It will be honored
    unless the Management Policies feature flag is disabled.
    InitProvider holds the same fields as ForProvider, with the exception
    of Identifier and other resource reference fields. The fields that are
    in InitProvider are merged into ForProvider when the resource is created.
    The same fields are also added to the terraform ignore_changes hook, to
    avoid updating them after creation. This is useful for fields that are
    required on creation, but we do not desire to update them after creation,
    for example because of an external controller is managing them, like an
    autoscaler.

    Attributes
    ----------
    member : str, default is Undefined, optional
        member
    role : str, default is Undefined, optional
        role
    serviceAccountId : str, default is Undefined, optional
        service account Id
    condition : CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberSpecInitProviderCondition, default is Undefined, optional
        condition
    serviceAccountIdRef : CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberSpecInitProviderServiceAccountIDRef, default is Undefined, optional
        service account Id ref
    serviceAccountIdSelector : CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberSpecInitProviderServiceAccountIDSelector, default is Undefined, optional
        service account Id selector
    """


    member?: str

    role?: str

    serviceAccountId?: str

    condition?: CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberSpecInitProviderCondition

    serviceAccountIdRef?: CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberSpecInitProviderServiceAccountIDRef

    serviceAccountIdSelector?: CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberSpecInitProviderServiceAccountIDSelector


schema CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberSpecInitProviderCondition:
    r"""
    cloudplatform gcpm upbound io v1beta1 service account i a m member spec init provider condition

    Attributes
    ----------
    description : str, default is Undefined, optional
        description
    expression : str, default is Undefined, optional
        expression
    title : str, default is Undefined, optional
        title
    """


    description?: str

    expression?: str

    title?: str


schema CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberSpecInitProviderServiceAccountIDRef:
    r"""
    Reference to a ServiceAccount in cloudplatform to populate serviceAccountId.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberSpecInitProviderServiceAccountIDRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberSpecInitProviderServiceAccountIDRefPolicy


schema CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberSpecInitProviderServiceAccountIDRefPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"


schema CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberSpecInitProviderServiceAccountIDSelector:
    r"""
    Selector for a ServiceAccount in cloudplatform to populate serviceAccountId.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberSpecInitProviderServiceAccountIDSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberSpecInitProviderServiceAccountIDSelectorPolicy


schema CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberSpecInitProviderServiceAccountIDSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"


schema CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberSpecProviderConfigRef:
    r"""
    ProviderConfigReference specifies how the provider that will be used to
    create, observe, update, and delete this managed resource should be
    configured.

    Attributes
    ----------
    kind : str, default is Undefined, required
        Kind of the referenced object.
    name : str, default is Undefined, required
        Name of the referenced object.
    """


    kind: str

    name: str


schema CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberSpecWriteConnectionSecretToRef:
    r"""
    WriteConnectionSecretToReference specifies the namespace and name of a
    Secret to which any connection details for this managed resource should
    be written. Connection details frequently include the endpoint, username,
    and password required to connect to the managed resource.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the secret.
    """


    name: str


schema CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberStatus:
    r"""
    ServiceAccountIAMMemberStatus defines the observed state of ServiceAccountIAMMember.

    Attributes
    ----------
    conditions : [CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberStatusConditionsItems0], default is Undefined, optional
        Conditions of the resource.
    observedGeneration : int, default is Undefined, optional
        ObservedGeneration is the latest metadata.generation
        which resulted in either a ready state, or stalled due to error
        it can not recover from without human intervention.
    atProvider : CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberStatusAtProvider, default is Undefined, optional
        at provider
    """


    conditions?: [CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberStatusConditionsItems0]

    observedGeneration?: int

    atProvider?: CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberStatusAtProvider


schema CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberStatusAtProvider:
    r"""
    cloudplatform gcpm upbound io v1beta1 service account i a m member status at provider

    Attributes
    ----------
    etag : str, default is Undefined, optional
        etag
    id : str, default is Undefined, optional
        id
    member : str, default is Undefined, optional
        member
    role : str, default is Undefined, optional
        role
    serviceAccountId : str, default is Undefined, optional
        service account Id
    condition : CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberStatusAtProviderCondition, default is Undefined, optional
        condition
    """


    etag?: str

    id?: str

    member?: str

    role?: str

    serviceAccountId?: str

    condition?: CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberStatusAtProviderCondition


schema CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberStatusAtProviderCondition:
    r"""
    cloudplatform gcpm upbound io v1beta1 service account i a m member status at provider condition

    Attributes
    ----------
    description : str, default is Undefined, optional
        description
    expression : str, default is Undefined, optional
        expression
    title : str, default is Undefined, optional
        title
    """


    description?: str

    expression?: str

    title?: str


schema CloudplatformGcpmUpboundIoV1beta1ServiceAccountIAMMemberStatusConditionsItems0:
    r"""
    A Condition that may apply to a resource.

    Attributes
    ----------
    lastTransitionTime : str, default is Undefined, required
        LastTransitionTime is the last time this condition transitioned from one
        status to another.
    message : str, default is Undefined, optional
        A Message containing details about this condition's last transition from
        one status to another, if any.
    observedGeneration : int, default is Undefined, optional
        ObservedGeneration represents the .metadata.generation that the condition was set based upon.
        For instance, if .metadata.generation is currently 12, but the .status.conditions[x].observedGeneration is 9, the condition is out of date
        with respect to the current state of the instance.
    reason : str, default is Undefined, required
        A Reason for this condition's last transition from one status to another.
    status : str, default is Undefined, required
        Status of this condition; is it currently True, False, or Unknown?
    $type : str, default is Undefined, required
        Type of this condition. At most one of each condition type may apply to
        a resource at any point in time.
    """


    lastTransitionTime: str

    message?: str

    observedGeneration?: int

    reason: str

    status: str

    $type: str






schema CryptoKey:
    r"""
    CryptoKey is the Schema for the CryptoKeys API. A

    Attributes
    ----------
    apiVersion : str, default is "kms.gcp.m.upbound.io/v1beta1", required
        APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
    kind : str, default is "CryptoKey", required
        Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
    metadata : v1.ObjectMeta, default is Undefined, optional
        metadata
    spec : KmsGcpmUpboundIoV1beta1CryptoKeySpec, default is Undefined, required
        spec
    status : KmsGcpmUpboundIoV1beta1CryptoKeyStatus, default is Undefined, optional
        status
    """


    apiVersion: "kms.gcp.m.upbound.io/v1beta1" = "kms.gcp.m.upbound.io/v1beta1"

    kind: "CryptoKey" = "CryptoKey"

    metadata?: v1.ObjectMeta

    spec: KmsGcpmUpboundIoV1beta1CryptoKeySpec

    status?: KmsGcpmUpboundIoV1beta1CryptoKeyStatus


schema KmsGcpmUpboundIoV1beta1CryptoKeySpec:
    r"""
    CryptoKeySpec defines the desired state of CryptoKey

    Attributes
    ----------
    managementPolicies : [str], default is ["*"], optional
        THIS IS A BETA FIELD. It is on by default but can be opted out
        through a Crossplane feature flag.
        ManagementPolicies specify the array of actions Crossplane is allowed to
        take on the managed and external resources.
        See the design doc for more information: https://github.com/crossplane/crossplane/blob/499895a25d1a1a0ba1604944ef98ac7a1a71f197/design/design-doc-observe-only-resources.md?plain=1#L223
        and this one: https://github.com/crossplane/crossplane/blob/444267e84783136daa93568b364a5f01228cacbe/design/one-pager-ignore-changes.md
    forProvider : KmsGcpmUpboundIoV1beta1CryptoKeySpecForProvider, default is Undefined, required
        for provider
    initProvider : KmsGcpmUpboundIoV1beta1CryptoKeySpecInitProvider, default is Undefined, optional
        init provider
    providerConfigRef : KmsGcpmUpboundIoV1beta1CryptoKeySpecProviderConfigRef, default is Undefined, optional
        provider config ref
    writeConnectionSecretToRef : KmsGcpmUpboundIoV1beta1CryptoKeySpecWriteConnectionSecretToRef, default is Undefined, optional
        write connection secret to ref
    """


    managementPolicies?: [str] = ["*"]

    forProvider: KmsGcpmUpboundIoV1beta1CryptoKeySpecForProvider

    initProvider?: KmsGcpmUpboundIoV1beta1CryptoKeySpecInitProvider

    providerConfigRef?: KmsGcpmUpboundIoV1beta1CryptoKeySpecProviderConfigRef

    writeConnectionSecretToRef?: KmsGcpmUpboundIoV1beta1CryptoKeySpecWriteConnectionSecretToRef


schema KmsGcpmUpboundIoV1beta1CryptoKeySpecForProvider:
    r"""
    kms gcpm upbound io v1beta1 crypto key spec for provider

    Attributes
    ----------
    cryptoKeyBackend : str, default is Undefined, optional
        The resource name of the backend environment associated with all CryptoKeyVersions within this CryptoKey.
        The resource name is in the format "projects//locations//ekmConnections/*" and only applies to "EXTERNAL_VPC" keys.
    destroyScheduledDuration : str, default is Undefined, optional
        The period of time that versions of this key spend in the DESTROY_SCHEDULED state before transitioning to DESTROYED.
        If not specified at creation time, the default duration is 30 days.
    importOnly : bool, default is Undefined, optional
        Whether this key may contain imported versions only.
    keyRing : str, default is Undefined, optional
        The KeyRing that this key belongs to.
        Format: 'projects/{{project}}/locations/{{location}}/keyRings/{{keyRing}}'.
    labels : {str:str}, default is Undefined, optional
        Labels with user-defined metadata to apply to this resource.
    purpose : str, default is Undefined, optional
        The immutable purpose of this CryptoKey. See the
        purpose reference
        for possible inputs.
        Default value is "ENCRYPT_DECRYPT".
    rotationPeriod : str, default is Undefined, optional
        Every time this period passes, generate a new CryptoKeyVersion and set it as the primary.
        The first rotation will take place after the specified period. The rotation period has
        the format of a decimal number with up to 9 fractional digits, followed by the
        letter s (seconds). It must be greater than a day (ie, 86400).
    skipInitialVersionCreation : bool, default is Undefined, optional
        If set to true, the request will create a CryptoKey without any CryptoKeyVersions.
        You must use the google_kms_crypto_key_version resource to create a new CryptoKeyVersion
        or google_kms_key_ring_import_job resource to import the CryptoKeyVersion.
    keyRingRef : KmsGcpmUpboundIoV1beta1CryptoKeySpecForProviderKeyRingRef, default is Undefined, optional
        key ring ref
    keyRingSelector : KmsGcpmUpboundIoV1beta1CryptoKeySpecForProviderKeyRingSelector, default is Undefined, optional
        key ring selector
    versionTemplate : KmsGcpmUpboundIoV1beta1CryptoKeySpecForProviderVersionTemplate, default is Undefined, optional
        version template
    """


    cryptoKeyBackend?: str

    destroyScheduledDuration?: str

    importOnly?: bool

    keyRing?: str

    labels?: {str:str}

    purpose?: str

    rotationPeriod?: str

    skipInitialVersionCreation?: bool

    keyRingRef?: KmsGcpmUpboundIoV1beta1CryptoKeySpecForProviderKeyRingRef

    keyRingSelector?: KmsGcpmUpboundIoV1beta1CryptoKeySpecForProviderKeyRingSelector

    versionTemplate?: KmsGcpmUpboundIoV1beta1CryptoKeySpecForProviderVersionTemplate


schema KmsGcpmUpboundIoV1beta1CryptoKeySpecForProviderKeyRingRef:
    r"""
    Reference to a KeyRing in kms to populate keyRing.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : KmsGcpmUpboundIoV1beta1CryptoKeySpecForProviderKeyRingRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: KmsGcpmUpboundIoV1beta1CryptoKeySpecForProviderKeyRingRefPolicy


schema KmsGcpmUpboundIoV1beta1CryptoKeySpecForProviderKeyRingRefPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"


schema KmsGcpmUpboundIoV1beta1CryptoKeySpecForProviderKeyRingSelector:
    r"""
    Selector for a KeyRing in kms to populate keyRing.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : KmsGcpmUpboundIoV1beta1CryptoKeySpecForProviderKeyRingSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: KmsGcpmUpboundIoV1beta1CryptoKeySpecForProviderKeyRingSelectorPolicy


schema KmsGcpmUpboundIoV1beta1CryptoKeySpecForProviderKeyRingSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"


schema KmsGcpmUpboundIoV1beta1CryptoKeySpecForProviderVersionTemplate:
    r"""
    A template describing settings for new crypto key versions.
    Structure is documented below.

    Attributes
    ----------
    algorithm : str, default is Undefined, optional
        The algorithm to use when creating a version based on this template.
        See the algorithm reference for possible inputs.
    protectionLevel : str, default is Undefined, optional
        The protection level to use when creating a version based on this template. Possible values include "SOFTWARE", "HSM", "EXTERNAL", "EXTERNAL_VPC". Defaults to "SOFTWARE".
    """


    algorithm?: str

    protectionLevel?: str


schema KmsGcpmUpboundIoV1beta1CryptoKeySpecInitProvider:
    r"""
    THIS IS A BETA FIELD. It will be honored
    unless the Management Policies feature flag is disabled.
    InitProvider holds the same fields as ForProvider, with the exception
    of Identifier and other resource reference fields. The fields that are
    in InitProvider are merged into ForProvider when the resource is created.
    The same fields are also added to the terraform ignore_changes hook, to
    avoid updating them after creation. This is useful for fields that are
    required on creation, but we do not desire to update them after creation,
    for example because of an external controller is managing them, like an
    autoscaler.

    Attributes
    ----------
    cryptoKeyBackend : str, default is Undefined, optional
        The resource name of the backend environment associated with all CryptoKeyVersions within this CryptoKey.
        The resource name is in the format "projects//locations//ekmConnections/*" and only applies to "EXTERNAL_VPC" keys.
    destroyScheduledDuration : str, default is Undefined, optional
        The period of time that versions of this key spend in the DESTROY_SCHEDULED state before transitioning to DESTROYED.
        If not specified at creation time, the default duration is 30 days.
    importOnly : bool, default is Undefined, optional
        Whether this key may contain imported versions only.
    labels : {str:str}, default is Undefined, optional
        Labels with user-defined metadata to apply to this resource.
    purpose : str, default is Undefined, optional
        The immutable purpose of this CryptoKey. See the
        purpose reference
        for possible inputs.
        Default value is "ENCRYPT_DECRYPT".
    rotationPeriod : str, default is Undefined, optional
        Every time this period passes, generate a new CryptoKeyVersion and set it as the primary.
        The first rotation will take place after the specified period. The rotation period has
        the format of a decimal number with up to 9 fractional digits, followed by the
        letter s (seconds). It must be greater than a day (ie, 86400).
    skipInitialVersionCreation : bool, default is Undefined, optional
        If set to true, the request will create a CryptoKey without any CryptoKeyVersions.
        You must use the google_kms_crypto_key_version resource to create a new CryptoKeyVersion
        or google_kms_key_ring_import_job resource to import the CryptoKeyVersion.
    versionTemplate : KmsGcpmUpboundIoV1beta1CryptoKeySpecInitProviderVersionTemplate, default is Undefined, optional
        version template
    """


    cryptoKeyBackend?: str

    destroyScheduledDuration?: str

    importOnly?: bool

    labels?: {str:str}

    purpose?: str

    rotationPeriod?: str

    skipInitialVersionCreation?: bool

    versionTemplate?: KmsGcpmUpboundIoV1beta1CryptoKeySpecInitProviderVersionTemplate


schema KmsGcpmUpboundIoV1beta1CryptoKeySpecInitProviderVersionTemplate:
    r"""
    A template describing settings for new crypto key versions.
    Structure is documented below.

    Attributes
    ----------
    algorithm : str, default is Undefined, optional
        The algorithm to use when creating a version based on this template.
        See the algorithm reference for possible inputs.
    protectionLevel : str, default is Undefined, optional
        The protection level to use when creating a version based on this template. Possible values include "SOFTWARE", "HSM", "EXTERNAL", "EXTERNAL_VPC". Defaults to "SOFTWARE".
    """


    algorithm?: str

    protectionLevel?: str


schema KmsGcpmUpboundIoV1beta1CryptoKeySpecProviderConfigRef:
    r"""
    ProviderConfigReference specifies how the provider that will be used to
    create, observe, update, and delete this managed resource should be
    configured.

    Attributes
    ----------
    kind : str, default is Undefined, required
        Kind of the referenced object.
    name : str, default is Undefined, required
        Name of the referenced object.
    """


    kind: str

    name: str


schema KmsGcpmUpboundIoV1beta1CryptoKeySpecWriteConnectionSecretToRef:
    r"""
    WriteConnectionSecretToReference specifies the namespace and name of a
    Secret to which any connection details for this managed resource should
    be written. Connection details frequently include the endpoint, username,
    and password required to connect to the managed resource.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the secret.
    """


    name: str


schema KmsGcpmUpboundIoV1beta1CryptoKeyStatus:
    r"""
    CryptoKeyStatus defines the observed state of CryptoKey.

    Attributes
    ----------
    conditions : [KmsGcpmUpboundIoV1beta1CryptoKeyStatusConditionsItems0], default is Undefined, optional
        Conditions of the resource.
    observedGeneration : int, default is Undefined, optional
        ObservedGeneration is the latest metadata.generation
        which resulted in either a ready state, or stalled due to error
        it can not recover from without human intervention.
    atProvider : KmsGcpmUpboundIoV1beta1CryptoKeyStatusAtProvider, default is Undefined, optional
        at provider
    """


    conditions?: [KmsGcpmUpboundIoV1beta1CryptoKeyStatusConditionsItems0]

    observedGeneration?: int

    atProvider?: KmsGcpmUpboundIoV1beta1CryptoKeyStatusAtProvider


schema KmsGcpmUpboundIoV1beta1CryptoKeyStatusAtProvider:
    r"""
    kms gcpm upbound io v1beta1 crypto key status at provider

    Attributes
    ----------
    cryptoKeyBackend : str, default is Undefined, optional
        The resource name of the backend environment associated with all CryptoKeyVersions within this CryptoKey.
        The resource name is in the format "projects//locations//ekmConnections/*" and only applies to "EXTERNAL_VPC" keys.
    destroyScheduledDuration : str, default is Undefined, optional
        The period of time that versions of this key spend in the DESTROY_SCHEDULED state before transitioning to DESTROYED.
        If not specified at creation time, the default duration is 30 days.
    effectiveLabels : {str:str}, default is Undefined, optional
        for all of the labels present on the resource.
    id : str, default is Undefined, optional
        an identifier for the resource with format {{key_ring}}/cryptoKeys/{{name}}
    importOnly : bool, default is Undefined, optional
        Whether this key may contain imported versions only.
    keyRing : str, default is Undefined, optional
        The KeyRing that this key belongs to.
        Format: 'projects/{{project}}/locations/{{location}}/keyRings/{{keyRing}}'.
    labels : {str:str}, default is Undefined, optional
        Labels with user-defined metadata to apply to this resource.
    primary : [KmsGcpmUpboundIoV1beta1CryptoKeyStatusAtProviderPrimaryItems0], default is Undefined, optional
        A copy of the primary CryptoKeyVersion that will be used by cryptoKeys.encrypt when this CryptoKey is given in EncryptRequest.name.
        Keys with purpose ENCRYPT_DECRYPT may have a primary. For other keys, this field will be unset.
        Structure is documented below.
    purpose : str, default is Undefined, optional
        The immutable purpose of this CryptoKey. See the
        purpose reference
        for possible inputs.
        Default value is "ENCRYPT_DECRYPT".
    rotationPeriod : str, default is Undefined, optional
        Every time this period passes, generate a new CryptoKeyVersion and set it as the primary.
        The first rotation will take place after the specified period. The rotation period has
        the format of a decimal number with up to 9 fractional digits, followed by the
        letter s (seconds). It must be greater than a day (ie, 86400).
    skipInitialVersionCreation : bool, default is Undefined, optional
        If set to true, the request will create a CryptoKey without any CryptoKeyVersions.
        You must use the google_kms_crypto_key_version resource to create a new CryptoKeyVersion
        or google_kms_key_ring_import_job resource to import the CryptoKeyVersion.
    terraformLabels : {str:str}, default is Undefined, optional
        The combination of labels configured directly on the resource
        and default labels configured on the provider.
    versionTemplate : KmsGcpmUpboundIoV1beta1CryptoKeyStatusAtProviderVersionTemplate, default is Undefined, optional
        version template
    """


    cryptoKeyBackend?: str

    destroyScheduledDuration?: str

    effectiveLabels?: {str:str}

    id?: str

    importOnly?: bool

    keyRing?: str

    labels?: {str:str}

    primary?: [KmsGcpmUpboundIoV1beta1CryptoKeyStatusAtProviderPrimaryItems0]

    purpose?: str

    rotationPeriod?: str

    skipInitialVersionCreation?: bool

    terraformLabels?: {str:str}

    versionTemplate?: KmsGcpmUpboundIoV1beta1CryptoKeyStatusAtProviderVersionTemplate


schema KmsGcpmUpboundIoV1beta1CryptoKeyStatusAtProviderPrimaryItems0:
    r"""
    kms gcpm upbound io v1beta1 crypto key status at provider primary items0

    Attributes
    ----------
    name : str, default is Undefined, optional
        (Output)
        The resource name for this CryptoKeyVersion.
    state : str, default is Undefined, optional
        (Output)
        The current state of the CryptoKeyVersion.
    """


    name?: str

    state?: str


schema KmsGcpmUpboundIoV1beta1CryptoKeyStatusAtProviderVersionTemplate:
    r"""
    A template describing settings for new crypto key versions.
    Structure is documented below.

    Attributes
    ----------
    algorithm : str, default is Undefined, optional
        The algorithm to use when creating a version based on this template.
        See the algorithm reference for possible inputs.
    protectionLevel : str, default is Undefined, optional
        The protection level to use when creating a version based on this template. Possible values include "SOFTWARE", "HSM", "EXTERNAL", "EXTERNAL_VPC". Defaults to "SOFTWARE".
    """


    algorithm?: str

    protectionLevel?: str


schema KmsGcpmUpboundIoV1beta1CryptoKeyStatusConditionsItems0:
    r"""
    A Condition that may apply to a resource.

    Attributes
    ----------
    lastTransitionTime : str, default is Undefined, required
        LastTransitionTime is the last time this condition transitioned from one
        status to another.
    message : str, default is Undefined, optional
        A Message containing details about this condition's last transition from
        one status to another, if any.
    observedGeneration : int, default is Undefined, optional
        ObservedGeneration represents the .metadata.generation that the condition was set based upon.
        For instance, if .metadata.generation is currently 12, but the .status.conditions[x].observedGeneration is 9, the condition is out of date
        with respect to the current state of the instance.
    reason : str, default is Undefined, required
        A Reason for this condition's last transition from one status to another.
    status : str, default is Undefined, required
        Status of this condition; is it currently True, False, or Unknown?
    $type : str, default is Undefined, required
        Type of this condition. At most one of each condition type may apply to
        a resource at any point in time.
    """


    lastTransitionTime: str

    message?: str

    observedGeneration?: int

    reason: str

    status: str

    $type: str






schema CryptoKeyIAMMember:
    r"""
    CryptoKeyIAMMember is the Schema for the CryptoKeyIAMMembers API. <no value>

    Attributes
    ----------
    apiVersion : str, default is "kms.gcp.m.upbound.io/v1beta1", required
        APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
    kind : str, default is "CryptoKeyIAMMember", required
        Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
    metadata : v1.ObjectMeta, default is Undefined, optional
        metadata
    spec : KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberSpec, default is Undefined, required
        spec
    status : KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberStatus, default is Undefined, optional
        status
    """


    apiVersion: "kms.gcp.m.upbound.io/v1beta1" = "kms.gcp.m.upbound.io/v1beta1"

    kind: "CryptoKeyIAMMember" = "CryptoKeyIAMMember"

    metadata?: v1.ObjectMeta

    spec: KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberSpec

    status?: KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberStatus


schema KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberSpec:
    r"""
    CryptoKeyIAMMemberSpec defines the desired state of CryptoKeyIAMMember

    Attributes
    ----------
    managementPolicies : [str], default is ["*"], optional
        THIS IS A BETA FIELD. It is on by default but can be opted out
        through a Crossplane feature flag.
        ManagementPolicies specify the array of actions Crossplane is allowed to
        take on the managed and external resources.
        See the design doc for more information: https://github.com/crossplane/crossplane/blob/499895a25d1a1a0ba1604944ef98ac7a1a71f197/design/design-doc-observe-only-resources.md?plain=1#L223
        and this one: https://github.com/crossplane/crossplane/blob/444267e84783136daa93568b364a5f01228cacbe/design/one-pager-ignore-changes.md
    forProvider : KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberSpecForProvider, default is Undefined, required
        for provider
    initProvider : KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberSpecInitProvider, default is Undefined, optional
        init provider
    providerConfigRef : KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberSpecProviderConfigRef, default is Undefined, optional
        provider config ref
    writeConnectionSecretToRef : KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberSpecWriteConnectionSecretToRef, default is Undefined, optional
        write connection secret to ref
    """


    managementPolicies?: [str] = ["*"]

    forProvider: KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberSpecForProvider

    initProvider?: KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberSpecInitProvider

    providerConfigRef?: KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberSpecProviderConfigRef

    writeConnectionSecretToRef?: KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberSpecWriteConnectionSecretToRef


schema KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberSpecForProvider:
    r"""
    kms gcpm upbound io v1beta1 crypto key i a m member spec for provider

    Attributes
    ----------
    cryptoKeyId : str, default is Undefined, optional
        crypto key Id
    member : str, default is Undefined, optional
        member
    role : str, default is Undefined, optional
        role
    condition : KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberSpecForProviderCondition, default is Undefined, optional
        condition
    cryptoKeyIdRef : KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberSpecForProviderCryptoKeyIDRef, default is Undefined, optional
        crypto key Id ref
    cryptoKeyIdSelector : KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberSpecForProviderCryptoKeyIDSelector, default is Undefined, optional
        crypto key Id selector
    """


    cryptoKeyId?: str

    member?: str

    role?: str

    condition?: KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberSpecForProviderCondition

    cryptoKeyIdRef?: KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberSpecForProviderCryptoKeyIDRef

    cryptoKeyIdSelector?: KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberSpecForProviderCryptoKeyIDSelector


schema KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberSpecForProviderCondition:
    r"""
    kms gcpm upbound io v1beta1 crypto key i a m member spec for provider condition

    Attributes
    ----------
    description : str, default is Undefined, optional
        description
    expression : str, default is Undefined, optional
        expression
    title : str, default is Undefined, optional
        title
    """


    description?: str

    expression?: str

    title?: str


schema KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberSpecForProviderCryptoKeyIDRef:
    r"""
    Reference to a CryptoKey in kms to populate cryptoKeyId.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberSpecForProviderCryptoKeyIDRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberSpecForProviderCryptoKeyIDRefPolicy


schema KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberSpecForProviderCryptoKeyIDRefPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"


schema KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberSpecForProviderCryptoKeyIDSelector:
    r"""
    Selector for a CryptoKey in kms to populate cryptoKeyId.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberSpecForProviderCryptoKeyIDSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberSpecForProviderCryptoKeyIDSelectorPolicy


schema KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberSpecForProviderCryptoKeyIDSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"


schema KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberSpecInitProvider:
    r"""
    THIS IS A BETA FIELD. It will be honored
    unless the Management Policies feature flag is disabled.
    InitProvider holds the same fields as ForProvider, with the exception
    of Identifier and other resource reference fields. The fields that are
    in InitProvider are merged into ForProvider when the resource is created.
    The same fields are also added to the terraform ignore_changes hook, to
    avoid updating them after creation. This is useful for fields that are
    required on creation, but we do not desire to update them after creation,
    for example because of an external controller is managing them, like an
    autoscaler.

    Attributes
    ----------
    cryptoKeyId : str, default is Undefined, optional
        crypto key Id
    member : str, default is Undefined, optional
        member
    role : str, default is Undefined, optional
        role
    condition : KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberSpecInitProviderCondition, default is Undefined, optional
        condition
    cryptoKeyIdRef : KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberSpecInitProviderCryptoKeyIDRef, default is Undefined, optional
        crypto key Id ref
    cryptoKeyIdSelector : KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberSpecInitProviderCryptoKeyIDSelector, default is Undefined, optional
        crypto key Id selector
    """


    cryptoKeyId?: str

    member?: str

    role?: str

    condition?: KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberSpecInitProviderCondition

    cryptoKeyIdRef?: KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberSpecInitProviderCryptoKeyIDRef

    cryptoKeyIdSelector?: KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberSpecInitProviderCryptoKeyIDSelector


schema KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberSpecInitProviderCondition:
    r"""
    kms gcpm upbound io v1beta1 crypto key i a m member spec init provider condition

    Attributes
    ----------
    description : str, default is Undefined, optional
        description
    expression : str, default is Undefined, optional
        expression
    title : str, default is Undefined, optional
        title
    """


    description?: str

    expression?: str

    title?: str


schema KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberSpecInitProviderCryptoKeyIDRef:
    r"""
    Reference to a CryptoKey in kms to populate cryptoKeyId.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberSpecInitProviderCryptoKeyIDRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberSpecInitProviderCryptoKeyIDRefPolicy


schema KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberSpecInitProviderCryptoKeyIDRefPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"


schema KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberSpecInitProviderCryptoKeyIDSelector:
    r"""
    Selector for a CryptoKey in kms to populate cryptoKeyId.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberSpecInitProviderCryptoKeyIDSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberSpecInitProviderCryptoKeyIDSelectorPolicy


schema KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberSpecInitProviderCryptoKeyIDSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"


schema KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberSpecProviderConfigRef:
    r"""
    ProviderConfigReference specifies how the provider that will be used to
    create, observe, update, and delete this managed resource should be
    configured.

    Attributes
    ----------
    kind : str, default is Undefined, required
        Kind of the referenced object.
    name : str, default is Undefined, required
        Name of the referenced object.
    """


    kind: str

    name: str


schema KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberSpecWriteConnectionSecretToRef:
    r"""
    WriteConnectionSecretToReference specifies the namespace and name of a
    Secret to which any connection details for this managed resource should
    be written. Connection details frequently include the endpoint, username,
    and password required to connect to the managed resource.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the secret.
    """


    name: str


schema KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberStatus:
    r"""
    CryptoKeyIAMMemberStatus defines the observed state of CryptoKeyIAMMember.

    Attributes
    ----------
    conditions : [KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberStatusConditionsItems0], default is Undefined, optional
        Conditions of the resource.
    observedGeneration : int, default is Undefined, optional
        ObservedGeneration is the latest metadata.generation
        which resulted in either a ready state, or stalled due to error
        it can not recover from without human intervention.
    atProvider : KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberStatusAtProvider, default is Undefined, optional
        at provider
    """


    conditions?: [KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberStatusConditionsItems0]

    observedGeneration?: int

    atProvider?: KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberStatusAtProvider


schema KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberStatusAtProvider:
    r"""
    kms gcpm upbound io v1beta1 crypto key i a m member status at provider

    Attributes
    ----------
    cryptoKeyId : str, default is Undefined, optional
        crypto key Id
    etag : str, default is Undefined, optional
        etag
    id : str, default is Undefined, optional
        id
    member : str, default is Undefined, optional
        member
    role : str, default is Undefined, optional
        role
    condition : KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberStatusAtProviderCondition, default is Undefined, optional
        condition
    """


    cryptoKeyId?: str

    etag?: str

    id?: str

    member?: str

    role?: str

    condition?: KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberStatusAtProviderCondition


schema KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberStatusAtProviderCondition:
    r"""
    kms gcpm upbound io v1beta1 crypto key i a m member status at provider condition

    Attributes
    ----------
    description : str, default is Undefined, optional
        description
    expression : str, default is Undefined, optional
        expression
    title : str, default is Undefined, optional
        title
    """


    description?: str

    expression?: str

    title?: str


schema KmsGcpmUpboundIoV1beta1CryptoKeyIAMMemberStatusConditionsItems0:
    r"""
    A Condition that may apply to a resource.

    Attributes
    ----------
    lastTransitionTime : str, default is Undefined, required
        LastTransitionTime is the last time this condition transitioned from one
        status to another.
    message : str, default is Undefined, optional
        A Message containing details about this condition's last transition from
        one status to another, if any.
    observedGeneration : int, default is Undefined, optional
        ObservedGeneration represents the .metadata.generation that the condition was set based upon.
        For instance, if .metadata.generation is currently 12, but the .status.conditions[x].observedGeneration is 9, the condition is out of date
        with respect to the current state of the instance.
    reason : str, default is Undefined, required
        A Reason for this condition's last transition from one status to another.
    status : str, default is Undefined, required
        Status of this condition; is it currently True, False, or Unknown?
    $type : str, default is Undefined, required
        Type of this condition. At most one of each condition type may apply to
        a resource at any point in time.
    """


    lastTransitionTime: str

    message?: str

    observedGeneration?: int

    reason: str

    status: str

    $type: str






schema KeyRing:
    r"""
    KeyRing is the Schema for the KeyRings API. A

    Attributes
    ----------
    apiVersion : str, default is "kms.gcp.m.upbound.io/v1beta1", required
        APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
    kind : str, default is "KeyRing", required
        Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
    metadata : v1.ObjectMeta, default is Undefined, optional
        metadata
    spec : KmsGcpmUpboundIoV1beta1KeyRingSpec, default is Undefined, required
        spec
    status : KmsGcpmUpboundIoV1beta1KeyRingStatus, default is Undefined, optional
        status
    """


    apiVersion: "kms.gcp.m.upbound.io/v1beta1" = "kms.gcp.m.upbound.io/v1beta1"

    kind: "KeyRing" = "KeyRing"

    metadata?: v1.ObjectMeta

    spec: KmsGcpmUpboundIoV1beta1KeyRingSpec

    status?: KmsGcpmUpboundIoV1beta1KeyRingStatus


schema KmsGcpmUpboundIoV1beta1KeyRingSpec:
    r"""
    KeyRingSpec defines the desired state of KeyRing

    Attributes
    ----------
    managementPolicies : [str], default is ["*"], optional
        THIS IS A BETA FIELD. It is on by default but can be opted out
        through a Crossplane feature flag.
        ManagementPolicies specify the array of actions Crossplane is allowed to
        take on the managed and external resources.
        See the design doc for more information: https://github.com/crossplane/crossplane/blob/499895a25d1a1a0ba1604944ef98ac7a1a71f197/design/design-doc-observe-only-resources.md?plain=1#L223
        and this one: https://github.com/crossplane/crossplane/blob/444267e84783136daa93568b364a5f01228cacbe/design/one-pager-ignore-changes.md
    forProvider : KmsGcpmUpboundIoV1beta1KeyRingSpecForProvider, default is Undefined, required
        for provider
    initProvider : KmsGcpmUpboundIoV1beta1KeyRingSpecInitProvider, default is Undefined, optional
        init provider
    providerConfigRef : KmsGcpmUpboundIoV1beta1KeyRingSpecProviderConfigRef, default is Undefined, optional
        provider config ref
    writeConnectionSecretToRef : KmsGcpmUpboundIoV1beta1KeyRingSpecWriteConnectionSecretToRef, default is Undefined, optional
        write connection secret to ref
    """


    managementPolicies?: [str] = ["*"]

    forProvider: KmsGcpmUpboundIoV1beta1KeyRingSpecForProvider

    initProvider?: KmsGcpmUpboundIoV1beta1KeyRingSpecInitProvider

    providerConfigRef?: KmsGcpmUpboundIoV1beta1KeyRingSpecProviderConfigRef

    writeConnectionSecretToRef?: KmsGcpmUpboundIoV1beta1KeyRingSpecWriteConnectionSecretToRef


schema KmsGcpmUpboundIoV1beta1KeyRingSpecForProvider:
    r"""
    kms gcpm upbound io v1beta1 key ring spec for provider

    Attributes
    ----------
    location : str, default is Undefined, required
        The location for the KeyRing.
        A full list of valid locations can be found by running gcloud kms locations list.
    project : str, default is Undefined, optional
        The ID of the project in which the resource belongs.
        If it is not provided, the provider project is used.
    """


    location: str

    project?: str


schema KmsGcpmUpboundIoV1beta1KeyRingSpecInitProvider:
    r"""
    THIS IS A BETA FIELD. It will be honored
    unless the Management Policies feature flag is disabled.
    InitProvider holds the same fields as ForProvider, with the exception
    of Identifier and other resource reference fields. The fields that are
    in InitProvider are merged into ForProvider when the resource is created.
    The same fields are also added to the terraform ignore_changes hook, to
    avoid updating them after creation. This is useful for fields that are
    required on creation, but we do not desire to update them after creation,
    for example because of an external controller is managing them, like an
    autoscaler.

    Attributes
    ----------
    project : str, default is Undefined, optional
        The ID of the project in which the resource belongs.
        If it is not provided, the provider project is used.
    """


    project?: str


schema KmsGcpmUpboundIoV1beta1KeyRingSpecProviderConfigRef:
    r"""
    ProviderConfigReference specifies how the provider that will be used to
    create, observe, update, and delete this managed resource should be
    configured.

    Attributes
    ----------
    kind : str, default is Undefined, required
        Kind of the referenced object.
    name : str, default is Undefined, required
        Name of the referenced object.
    """


    kind: str

    name: str


schema KmsGcpmUpboundIoV1beta1KeyRingSpecWriteConnectionSecretToRef:
    r"""
    WriteConnectionSecretToReference specifies the namespace and name of a
    Secret to which any connection details for this managed resource should
    be written. Connection details frequently include the endpoint, username,
    and password required to connect to the managed resource.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the secret.
    """


    name: str


schema KmsGcpmUpboundIoV1beta1KeyRingStatus:
    r"""
    KeyRingStatus defines the observed state of KeyRing.

    Attributes
    ----------
    conditions : [KmsGcpmUpboundIoV1beta1KeyRingStatusConditionsItems0], default is Undefined, optional
        Conditions of the resource.
    observedGeneration : int, default is Undefined, optional
        ObservedGeneration is the latest metadata.generation
        which resulted in either a ready state, or stalled due to error
        it can not recover from without human intervention.
    atProvider : KmsGcpmUpboundIoV1beta1KeyRingStatusAtProvider, default is Undefined, optional
        at provider
    """


    conditions?: [KmsGcpmUpboundIoV1beta1KeyRingStatusConditionsItems0]

    observedGeneration?: int

    atProvider?: KmsGcpmUpboundIoV1beta1KeyRingStatusAtProvider


schema KmsGcpmUpboundIoV1beta1KeyRingStatusAtProvider:
    r"""
    kms gcpm upbound io v1beta1 key ring status at provider

    Attributes
    ----------
    id : str, default is Undefined, optional
        an identifier for the resource with format projects/{{project}}/locations/{{location}}/keyRings/{{name}}
    location : str, default is Undefined, optional
        The location for the KeyRing.
        A full list of valid locations can be found by running gcloud kms locations list.
    project : str, default is Undefined, optional
        The ID of the project in which the resource belongs.
        If it is not provided, the provider project is used.
    """


    id?: str

    location?: str

    project?: str


schema KmsGcpmUpboundIoV1beta1KeyRingStatusConditionsItems0:
    r"""
    A Condition that may apply to a resource.

    Attributes
    ----------
    lastTransitionTime : str, default is Undefined, required
        LastTransitionTime is the last time this condition transitioned from one
        status to another.
    message : str, default is Undefined, optional
        A Message containing details about this condition's last transition from
        one status to another, if any.
    observedGeneration : int, default is Undefined, optional
        ObservedGeneration represents the .metadata.generation that the condition was set based upon.
        For instance, if .metadata.generation is currently 12, but the .status.conditions[x].observedGeneration is 9, the condition is out of date
        with respect to the current state of the instance.
    reason : str, default is Undefined, required
        A Reason for this condition's last transition from one status to another.
    status : str, default is Undefined, required
        Status of this condition; is it currently True, False, or Unknown?
    $type : str, default is Undefined, required
        Type of this condition. At most one of each condition type may apply to
        a resource at any point in time.
    """


    lastTransitionTime: str

    message?: str

    observedGeneration?: int

    reason: str

    status: str

    $type: str






schema Database:
    r"""
    Database is the Schema for the Databases API. Represents a SQL database inside the Cloud SQL instance, hosted in Google's cloud.

    Attributes
    ----------
    apiVersion : str, default is "sql.gcp.m.upbound.io/v1beta1", required
        APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
    kind : str, default is "Database", required
        Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
    metadata : v1.ObjectMeta, default is Undefined, optional
        metadata
    spec : SQLGcpmUpboundIoV1beta1DatabaseSpec, default is Undefined, required
        spec
    status : SQLGcpmUpboundIoV1beta1DatabaseStatus, default is Undefined, optional
        status
    """


    apiVersion: "sql.gcp.m.upbound.io/v1beta1" = "sql.gcp.m.upbound.io/v1beta1"

    kind: "Database" = "Database"

    metadata?: v1.ObjectMeta

    spec: SQLGcpmUpboundIoV1beta1DatabaseSpec

    status?: SQLGcpmUpboundIoV1beta1DatabaseStatus


schema SQLGcpmUpboundIoV1beta1DatabaseSpec:
    r"""
    DatabaseSpec defines the desired state of Database

    Attributes
    ----------
    managementPolicies : [str], default is ["*"], optional
        THIS IS A BETA FIELD. It is on by default but can be opted out
        through a Crossplane feature flag.
        ManagementPolicies specify the array of actions Crossplane is allowed to
        take on the managed and external resources.
        See the design doc for more information: https://github.com/crossplane/crossplane/blob/499895a25d1a1a0ba1604944ef98ac7a1a71f197/design/design-doc-observe-only-resources.md?plain=1#L223
        and this one: https://github.com/crossplane/crossplane/blob/444267e84783136daa93568b364a5f01228cacbe/design/one-pager-ignore-changes.md
    forProvider : SQLGcpmUpboundIoV1beta1DatabaseSpecForProvider, default is Undefined, required
        for provider
    initProvider : SQLGcpmUpboundIoV1beta1DatabaseSpecInitProvider, default is Undefined, optional
        init provider
    providerConfigRef : SQLGcpmUpboundIoV1beta1DatabaseSpecProviderConfigRef, default is Undefined, optional
        provider config ref
    writeConnectionSecretToRef : SQLGcpmUpboundIoV1beta1DatabaseSpecWriteConnectionSecretToRef, default is Undefined, optional
        write connection secret to ref
    """


    managementPolicies?: [str] = ["*"]

    forProvider: SQLGcpmUpboundIoV1beta1DatabaseSpecForProvider

    initProvider?: SQLGcpmUpboundIoV1beta1DatabaseSpecInitProvider

    providerConfigRef?: SQLGcpmUpboundIoV1beta1DatabaseSpecProviderConfigRef

    writeConnectionSecretToRef?: SQLGcpmUpboundIoV1beta1DatabaseSpecWriteConnectionSecretToRef


schema SQLGcpmUpboundIoV1beta1DatabaseSpecForProvider:
    r"""
    SQL gcpm upbound io v1beta1 database spec for provider

    Attributes
    ----------
    charset : str, default is Undefined, optional
        The charset value. See MySQL's
        Supported Character Sets and Collations
        and Postgres' Character Set Support
        for more details and supported values. Postgres databases only support
        a value of UTF8 at creation time.
    collation : str, default is Undefined, optional
        The collation value. See MySQL's
        Supported Character Sets and Collations
        and Postgres' Collation Support
        for more details and supported values. Postgres databases only support
        a value of en_US.UTF8 at creation time.
    deletionPolicy : str, default is Undefined, optional
        The deletion policy for the database. Setting ABANDON allows the resource
        to be abandoned rather than deleted. This is useful for Postgres, where databases cannot be
        deleted from the API if there are users other than cloudsqlsuperuser with access. Possible
        values are: "ABANDON", "DELETE". Defaults to "DELETE".
    instance : str, default is Undefined, optional
        The name of the Cloud SQL instance. This does not include the project
        ID.
    project : str, default is Undefined, optional
        The ID of the project in which the resource belongs.
        If it is not provided, the provider project is used.
    instanceRef : SQLGcpmUpboundIoV1beta1DatabaseSpecForProviderInstanceRef, default is Undefined, optional
        instance ref
    instanceSelector : SQLGcpmUpboundIoV1beta1DatabaseSpecForProviderInstanceSelector, default is Undefined, optional
        instance selector
    """


    charset?: str

    collation?: str

    deletionPolicy?: str

    instance?: str

    project?: str

    instanceRef?: SQLGcpmUpboundIoV1beta1DatabaseSpecForProviderInstanceRef

    instanceSelector?: SQLGcpmUpboundIoV1beta1DatabaseSpecForProviderInstanceSelector


schema SQLGcpmUpboundIoV1beta1DatabaseSpecForProviderInstanceRef:
    r"""
    Reference to a DatabaseInstance in sql to populate instance.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : SQLGcpmUpboundIoV1beta1DatabaseSpecForProviderInstanceRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: SQLGcpmUpboundIoV1beta1DatabaseSpecForProviderInstanceRefPolicy


schema SQLGcpmUpboundIoV1beta1DatabaseSpecForProviderInstanceRefPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"


schema SQLGcpmUpboundIoV1beta1DatabaseSpecForProviderInstanceSelector:
    r"""
    Selector for a DatabaseInstance in sql to populate instance.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : SQLGcpmUpboundIoV1beta1DatabaseSpecForProviderInstanceSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: SQLGcpmUpboundIoV1beta1DatabaseSpecForProviderInstanceSelectorPolicy


schema SQLGcpmUpboundIoV1beta1DatabaseSpecForProviderInstanceSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"


schema SQLGcpmUpboundIoV1beta1DatabaseSpecInitProvider:
    r"""
    THIS IS A BETA FIELD. It will be honored
    unless the Management Policies feature flag is disabled.
    InitProvider holds the same fields as ForProvider, with the exception
    of Identifier and other resource reference fields. The fields that are
    in InitProvider are merged into ForProvider when the resource is created.
    The same fields are also added to the terraform ignore_changes hook, to
    avoid updating them after creation. This is useful for fields that are
    required on creation, but we do not desire to update them after creation,
    for example because of an external controller is managing them, like an
    autoscaler.

    Attributes
    ----------
    charset : str, default is Undefined, optional
        The charset value. See MySQL's
        Supported Character Sets and Collations
        and Postgres' Character Set Support
        for more details and supported values. Postgres databases only support
        a value of UTF8 at creation time.
    collation : str, default is Undefined, optional
        The collation value. See MySQL's
        Supported Character Sets and Collations
        and Postgres' Collation Support
        for more details and supported values. Postgres databases only support
        a value of en_US.UTF8 at creation time.
    deletionPolicy : str, default is Undefined, optional
        The deletion policy for the database. Setting ABANDON allows the resource
        to be abandoned rather than deleted. This is useful for Postgres, where databases cannot be
        deleted from the API if there are users other than cloudsqlsuperuser with access. Possible
        values are: "ABANDON", "DELETE". Defaults to "DELETE".
    project : str, default is Undefined, optional
        The ID of the project in which the resource belongs.
        If it is not provided, the provider project is used.
    """


    charset?: str

    collation?: str

    deletionPolicy?: str

    project?: str


schema SQLGcpmUpboundIoV1beta1DatabaseSpecProviderConfigRef:
    r"""
    ProviderConfigReference specifies how the provider that will be used to
    create, observe, update, and delete this managed resource should be
    configured.

    Attributes
    ----------
    kind : str, default is Undefined, required
        Kind of the referenced object.
    name : str, default is Undefined, required
        Name of the referenced object.
    """


    kind: str

    name: str


schema SQLGcpmUpboundIoV1beta1DatabaseSpecWriteConnectionSecretToRef:
    r"""
    WriteConnectionSecretToReference specifies the namespace and name of a
    Secret to which any connection details for this managed resource should
    be written. Connection details frequently include the endpoint, username,
    and password required to connect to the managed resource.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the secret.
    """


    name: str


schema SQLGcpmUpboundIoV1beta1DatabaseStatus:
    r"""
    DatabaseStatus defines the observed state of Database.

    Attributes
    ----------
    conditions : [SQLGcpmUpboundIoV1beta1DatabaseStatusConditionsItems0], default is Undefined, optional
        Conditions of the resource.
    observedGeneration : int, default is Undefined, optional
        ObservedGeneration is the latest metadata.generation
        which resulted in either a ready state, or stalled due to error
        it can not recover from without human intervention.
    atProvider : SQLGcpmUpboundIoV1beta1DatabaseStatusAtProvider, default is Undefined, optional
        at provider
    """


    conditions?: [SQLGcpmUpboundIoV1beta1DatabaseStatusConditionsItems0]

    observedGeneration?: int

    atProvider?: SQLGcpmUpboundIoV1beta1DatabaseStatusAtProvider


schema SQLGcpmUpboundIoV1beta1DatabaseStatusAtProvider:
    r"""
    SQL gcpm upbound io v1beta1 database status at provider

    Attributes
    ----------
    charset : str, default is Undefined, optional
        The charset value. See MySQL's
        Supported Character Sets and Collations
        and Postgres' Character Set Support
        for more details and supported values. Postgres databases only support
        a value of UTF8 at creation time.
    collation : str, default is Undefined, optional
        The collation value. See MySQL's
        Supported Character Sets and Collations
        and Postgres' Collation Support
        for more details and supported values. Postgres databases only support
        a value of en_US.UTF8 at creation time.
    deletionPolicy : str, default is Undefined, optional
        The deletion policy for the database. Setting ABANDON allows the resource
        to be abandoned rather than deleted. This is useful for Postgres, where databases cannot be
        deleted from the API if there are users other than cloudsqlsuperuser with access. Possible
        values are: "ABANDON", "DELETE". Defaults to "DELETE".
    id : str, default is Undefined, optional
        an identifier for the resource with format projects/{{project}}/instances/{{instance}}/databases/{{name}}
    instance : str, default is Undefined, optional
        The name of the Cloud SQL instance. This does not include the project
        ID.
    project : str, default is Undefined, optional
        The ID of the project in which the resource belongs.
        If it is not provided, the provider project is used.
    selfLink : str, default is Undefined, optional
        The URI of the created resource.
    """


    charset?: str

    collation?: str

    deletionPolicy?: str

    id?: str

    instance?: str

    project?: str

    selfLink?: str


schema SQLGcpmUpboundIoV1beta1DatabaseStatusConditionsItems0:
    r"""
    A Condition that may apply to a resource.

    Attributes
    ----------
    lastTransitionTime : str, default is Undefined, required
        LastTransitionTime is the last time this condition transitioned from one
        status to another.
    message : str, default is Undefined, optional
        A Message containing details about this condition's last transition from
        one status to another, if any.
    observedGeneration : int, default is Undefined, optional
        ObservedGeneration represents the .metadata.generation that the condition was set based upon.
        For instance, if .metadata.generation is currently 12, but the .status.conditions[x].observedGeneration is 9, the condition is out of date
        with respect to the current state of the instance.
    reason : str, default is Undefined, required
        A Reason for this condition's last transition from one status to another.
    status : str, default is Undefined, required
        Status of this condition; is it currently True, False, or Unknown?
    $type : str, default is Undefined, required
        Type of this condition. At most one of each condition type may apply to
        a resource at any point in time.
    """


    lastTransitionTime: str

    message?: str

    observedGeneration?: int

    reason: str

    status: str

    $type: str






schema DatabaseInstance:
    r"""
    DatabaseInstance is the Schema for the DatabaseInstances API. Creates a new SQL database instance in Google Cloud SQL.

    Attributes
    ----------
    apiVersion : str, default is "sql.gcp.m.upbound.io/v1beta1", required
        APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
    kind : str, default is "DatabaseInstance", required
        Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
    metadata : v1.ObjectMeta, default is Undefined, optional
        metadata
    spec : SQLGcpmUpboundIoV1beta1DatabaseInstanceSpec, default is Undefined, required
        spec
    status : SQLGcpmUpboundIoV1beta1DatabaseInstanceStatus, default is Undefined, optional
        status
    """


    apiVersion: "sql.gcp.m.upbound.io/v1beta1" = "sql.gcp.m.upbound.io/v1beta1"

    kind: "DatabaseInstance" = "DatabaseInstance"

    metadata?: v1.ObjectMeta

    spec: SQLGcpmUpboundIoV1beta1DatabaseInstanceSpec

    status?: SQLGcpmUpboundIoV1beta1DatabaseInstanceStatus


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpec:
    r"""
    DatabaseInstanceSpec defines the desired state of DatabaseInstance

    Attributes
    ----------
    managementPolicies : [str], default is ["*"], optional
        THIS IS A BETA FIELD. It is on by default but can be opted out
        through a Crossplane feature flag.
        ManagementPolicies specify the array of actions Crossplane is allowed to
        take on the managed and external resources.
        See the design doc for more information: https://github.com/crossplane/crossplane/blob/499895a25d1a1a0ba1604944ef98ac7a1a71f197/design/design-doc-observe-only-resources.md?plain=1#L223
        and this one: https://github.com/crossplane/crossplane/blob/444267e84783136daa93568b364a5f01228cacbe/design/one-pager-ignore-changes.md
    forProvider : SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProvider, default is Undefined, required
        for provider
    initProvider : SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProvider, default is Undefined, optional
        init provider
    providerConfigRef : SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecProviderConfigRef, default is Undefined, optional
        provider config ref
    writeConnectionSecretToRef : SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecWriteConnectionSecretToRef, default is Undefined, optional
        write connection secret to ref
    """


    managementPolicies?: [str] = ["*"]

    forProvider: SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProvider

    initProvider?: SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProvider

    providerConfigRef?: SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecProviderConfigRef

    writeConnectionSecretToRef?: SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecWriteConnectionSecretToRef


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProvider:
    r"""
    SQL gcpm upbound io v1beta1 database instance spec for provider

    Attributes
    ----------
    databaseVersion : str, default is Undefined, optional
        The MySQL, PostgreSQL or
        SQL Server version to use. Supported values include MYSQL_5_6,
        MYSQL_5_7, MYSQL_8_0, MYSQL_8_4, POSTGRES_9_6,POSTGRES_10, POSTGRES_11,
        POSTGRES_12, POSTGRES_13, POSTGRES_14, POSTGRES_15, POSTGRES_16, POSTGRES_17,
        SQLSERVER_2017_STANDARD, SQLSERVER_2017_ENTERPRISE, SQLSERVER_2017_EXPRESS, SQLSERVER_2017_WEB.
        SQLSERVER_2019_STANDARD, SQLSERVER_2019_ENTERPRISE, SQLSERVER_2019_EXPRESS,
        SQLSERVER_2019_WEB.
        Database Version Policies
        includes an up-to-date reference of supported versions.
    deletionProtection : bool, default is Undefined, optional
        When the field is set to false, deleting the instance is allowed.
    encryptionKeyName : str, default is Undefined, optional
        The full path to the encryption key used for the CMEK disk encryption.
        The provided key must be in the same region as the SQL instance.  In order
        to use this feature, a special kind of service account must be created and
        granted permission on this key.  This step can currently only be done
        manually, please see this step.
        That service account needs the Cloud KMS > Cloud KMS CryptoKey Encrypter/Decrypter role on your
        key - please see this step.
    maintenanceVersion : str, default is Undefined, optional
        The current software version on the instance. This attribute can not be set during creation. Refer to available_maintenance_versions attribute to see what maintenance_version are available for upgrade. When this attribute gets updated, it will cause an instance restart. Setting a maintenance_version value that is older than the current one on the instance will be ignored.
    masterInstanceName : str, default is Undefined, optional
        The name of the existing instance that will
        act as the master in the replication setup. Note, this requires the master to
        have binary_log_enabled set, as well as existing backups.
    project : str, default is Undefined, optional
        The ID of the project in which the resource belongs. If it
        is not provided, the provider project is used.
    region : str, default is Undefined, optional
        The region the instance will sit in. If a region is not provided in the resource definition,
        the provider region will be used instead.
    replicaNames : [str], default is Undefined, optional
        List of replica names. Can be updated.
    clone : SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderClone, default is Undefined, optional
        clone
    replicaConfiguration : SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderReplicaConfiguration, default is Undefined, optional
        replica configuration
    replicationCluster : SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderReplicationCluster, default is Undefined, optional
        replication cluster
    restoreBackupContext : SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderRestoreBackupContext, default is Undefined, optional
        restore backup context
    rootPasswordSecretRef : SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderRootPasswordSecretRef, default is Undefined, optional
        root password secret ref
    settings : SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettings, default is Undefined, optional
        settings
    """


    databaseVersion?: str

    deletionProtection?: bool

    encryptionKeyName?: str

    maintenanceVersion?: str

    masterInstanceName?: str

    project?: str

    region?: str

    replicaNames?: [str]

    clone?: SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderClone

    replicaConfiguration?: SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderReplicaConfiguration

    replicationCluster?: SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderReplicationCluster

    restoreBackupContext?: SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderRestoreBackupContext

    rootPasswordSecretRef?: SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderRootPasswordSecretRef

    settings?: SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettings


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderClone:
    r"""
    The context needed to create this instance as a clone of another instance. The
    configuration is detailed below.

    Attributes
    ----------
    allocatedIpRange : str, default is Undefined, optional
        The name of the allocated ip range for the private ip CloudSQL instance. For example: "google-managed-services-default". If set, the cloned instance ip will be created in the allocated range. The range name must comply with RFC 1035. Specifically, the name must be 1-63 characters long and match the regular expression a-z?.
    databaseNames : [str], default is Undefined, optional
        (SQL Server only, use with point_in_time) Clone only the specified databases from the source instance. Clone all databases if empty.
    pointInTime : str, default is Undefined, optional
        The timestamp of the point in time that should be restored.
    preferredZone : str, default is Undefined, optional
        (Point-in-time recovery for PostgreSQL only) Clone to an instance in the specified zone. If no zone is specified, clone to the same zone as the source instance. clone-unavailable-instance
    sourceInstanceName : str, default is Undefined, optional
        Name of the source instance which will be cloned.
    """


    allocatedIpRange?: str

    databaseNames?: [str]

    pointInTime?: str

    preferredZone?: str

    sourceInstanceName?: str


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderReplicaConfiguration:
    r"""
    The configuration for replication. The
    configuration is detailed below.

    Attributes
    ----------
    caCertificate : str, default is Undefined, optional
        PEM representation of the trusted CA's x509
        certificate.
    cascadableReplica : bool, default is Undefined, optional
        Specifies if the replica is a cascadable replica. If true, instance must be in different region from primary.
    clientCertificate : str, default is Undefined, optional
        PEM representation of the replica's x509
        certificate.
    clientKey : str, default is Undefined, optional
        PEM representation of the replica's private key. The
        corresponding public key in encoded in the client_certificate.
    connectRetryInterval : float, default is Undefined, optional
        The number of seconds
        between connect retries. MySQL's default is 60 seconds.
    dumpFilePath : str, default is Undefined, optional
        Path to a SQL file in GCS from which replica
        instances are created. Format is gs://bucket/filename. Note, if the master
        instance is a source representation instance this field must be present.
    failoverTarget : bool, default is Undefined, optional
        Specifies if the replica is the failover target.
        If the field is set to true the replica will be designated as a failover replica.
        If the master instance fails, the replica instance will be promoted as
        the new master instance.
        ~> NOTE: Not supported for Postgres database.
    masterHeartbeatPeriod : float, default is Undefined, optional
        Time in ms between replication
        heartbeats.
    sslCipher : str, default is Undefined, optional
        Permissible ciphers for use in SSL encryption.
    username : str, default is Undefined, optional
        Username for replication connection.
    verifyServerCertificate : bool, default is Undefined, optional
        True if the master's common name
        value is checked during the SSL handshake.
    passwordSecretRef : SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderReplicaConfigurationPasswordSecretRef, default is Undefined, optional
        password secret ref
    """


    caCertificate?: str

    cascadableReplica?: bool

    clientCertificate?: str

    clientKey?: str

    connectRetryInterval?: float

    dumpFilePath?: str

    failoverTarget?: bool

    masterHeartbeatPeriod?: float

    sslCipher?: str

    username?: str

    verifyServerCertificate?: bool

    passwordSecretRef?: SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderReplicaConfigurationPasswordSecretRef


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderReplicaConfigurationPasswordSecretRef:
    r"""
    Password for the replication connection.

    Attributes
    ----------
    key : str, default is Undefined, required
        key
    name : str, default is Undefined, required
        Name of the secret.
    """


    key: str

    name: str


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderReplicationCluster:
    r"""
    SQL gcpm upbound io v1beta1 database instance spec for provider replication cluster

    Attributes
    ----------
    failoverDrReplicaName : str, default is Undefined, optional
        project:your-instance". You can also set this field to "your-instance", but cloud SQL backend will convert it to the aforementioned standard format.
    """


    failoverDrReplicaName?: str


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderRestoreBackupContext:
    r"""
    The context needed to restore the database to a backup run. The configuration is detailed below. Adding or modifying this
    block during resource creation/update will trigger the restore action after the resource is created/updated.

    Attributes
    ----------
    backupRunId : float, default is Undefined, optional
        The ID of the backup run to restore from.
    instanceId : str, default is Undefined, optional
        The ID of the instance that the backup was taken from. If left empty,
        this instance's ID will be used.
    project : str, default is Undefined, optional
        The full project ID of the source instance.`
    """


    backupRunId?: float

    instanceId?: str

    project?: str


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderRootPasswordSecretRef:
    r"""
    Initial root password. Can be updated. Required for MS SQL Server.

    Attributes
    ----------
    key : str, default is Undefined, required
        key
    name : str, default is Undefined, required
        Name of the secret.
    """


    key: str

    name: str


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettings:
    r"""
    The settings to use for the database. The
    configuration is detailed below. Required if clone is not set.

    Attributes
    ----------
    activationPolicy : str, default is Undefined, optional
        This specifies when the instance should be
        active. Can be either ALWAYS, NEVER or ON_DEMAND.
    availabilityType : str, default is Undefined, optional
        The availability type of the Cloud SQL
        instance, high availability (REGIONAL) or single zone (ZONAL).' For all instances, ensure that
        settings.backup_configuration.enabled is set to true.
        For MySQL instances, ensure that settings.backup_configuration.binary_log_enabled is set to true.
        For Postgres and SQL Server instances, ensure that settings.backup_configuration.point_in_time_recovery_enabled
        is set to true. Defaults to ZONAL.
    collation : str, default is Undefined, optional
        The name of server instance collation.
    connectionPoolConfig : [SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsConnectionPoolConfigItems0], default is Undefined, optional
        connection pool config
    connectorEnforcement : str, default is Undefined, optional
        Control the enforcement of Cloud SQL Auth Proxy or Cloud SQL connectors for all the connections, can be REQUIRED or NOT_REQUIRED. If enabled, all the direct connections are rejected.
    databaseFlags : [SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsDatabaseFlagsItems0], default is Undefined, optional
        database flags
    deletionProtectionEnabled : bool, default is Undefined, optional
        .
    diskAutoresize : bool, default is Undefined, optional
        Enables auto-resizing of the storage size. Defaults to true. To avoid this, ensure that lifecycle.ignore_changes is applied to disk_size.
    diskAutoresizeLimit : float, default is Undefined, optional
        The maximum size to which storage capacity can be automatically increased. The default value is 0, which specifies that there is no limit.
    diskSize : float, default is Undefined, optional
        The size of data disk, in GB. Size of a running instance cannot be reduced but can be increased. The minimum value is 10GB for PD_SSD, PD_HDD and 20GB for HYPERDISK_BALANCED. Note that this value will override the resizing from disk_autoresize if that feature is enabled. To avoid this, set lifecycle.ignore_changes on this field.
    diskType : str, default is Undefined, optional
        The type of data disk: PD_SSD, PD_HDD, or HYPERDISK_BALANCED. Defaults to PD_SSD. HYPERDISK_BALANCED is preview.
    edition : str, default is Undefined, optional
        The edition of the instance, can be ENTERPRISE or ENTERPRISE_PLUS.
    enableDataplexIntegration : bool, default is Undefined, optional
        Enables Cloud SQL instance integration with Dataplex. MySQL, Postgres and SQL Server instances are supported for this feature. Defaults to false.
    enableGoogleMlIntegration : bool, default is Undefined, optional
        Enables Cloud SQL instances to connect to Vertex AI and pass requests for real-time predictions and insights. Defaults to false.
    pricingPlan : str, default is Undefined, optional
        Pricing plan for this instance, can only be PER_USE.
    retainBackupsOnDelete : bool, default is Undefined, optional
        When this parameter is set to true, Cloud SQL retains backups of the instance even after the instance is deleted. The ON_DEMAND backup will be retained until customer deletes the backup or the project. The AUTOMATED backup will be retained based on the backups retention setting.
    tier : str, default is Undefined, optional
        The machine type to use. See tiers
        for more details and supported versions. Postgres supports only shared-core machine types,
        and custom machine types such as db-custom-2-13312. See the Custom Machine Type Documentation to learn about specifying custom machine types.
    timeZone : str, default is Undefined, optional
        The time_zone to be used by the database engine (supported only for SQL Server), in SQL Server timezone format.
    userLabels : {str:str}, default is Undefined, optional
        A set of key/value user label pairs to assign to the instance.
    activeDirectoryConfig : SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsActiveDirectoryConfig, default is Undefined, optional
        active directory config
    advancedMachineFeatures : SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsAdvancedMachineFeatures, default is Undefined, optional
        advanced machine features
    backupConfiguration : SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsBackupConfiguration, default is Undefined, optional
        backup configuration
    dataCacheConfig : SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsDataCacheConfig, default is Undefined, optional
        data cache config
    denyMaintenancePeriod : SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsDenyMaintenancePeriod, default is Undefined, optional
        deny maintenance period
    insightsConfig : SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsInsightsConfig, default is Undefined, optional
        insights config
    ipConfiguration : SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsIPConfiguration, default is Undefined, optional
        ip configuration
    locationPreference : SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsLocationPreference, default is Undefined, optional
        location preference
    maintenanceWindow : SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsMaintenanceWindow, default is Undefined, optional
        maintenance window
    passwordValidationPolicy : SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsPasswordValidationPolicy, default is Undefined, optional
        password validation policy
    sqlServerAuditConfig : SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsSQLServerAuditConfig, default is Undefined, optional
        sql server audit config
    """


    activationPolicy?: str

    availabilityType?: str

    collation?: str

    connectionPoolConfig?: [SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsConnectionPoolConfigItems0]

    connectorEnforcement?: str

    databaseFlags?: [SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsDatabaseFlagsItems0]

    deletionProtectionEnabled?: bool

    diskAutoresize?: bool

    diskAutoresizeLimit?: float

    diskSize?: float

    diskType?: str

    edition?: str

    enableDataplexIntegration?: bool

    enableGoogleMlIntegration?: bool

    pricingPlan?: str

    retainBackupsOnDelete?: bool

    tier?: str

    timeZone?: str

    userLabels?: {str:str}

    activeDirectoryConfig?: SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsActiveDirectoryConfig

    advancedMachineFeatures?: SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsAdvancedMachineFeatures

    backupConfiguration?: SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsBackupConfiguration

    dataCacheConfig?: SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsDataCacheConfig

    denyMaintenancePeriod?: SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsDenyMaintenancePeriod

    insightsConfig?: SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsInsightsConfig

    ipConfiguration?: SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsIPConfiguration

    locationPreference?: SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsLocationPreference

    maintenanceWindow?: SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsMaintenanceWindow

    passwordValidationPolicy?: SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsPasswordValidationPolicy

    sqlServerAuditConfig?: SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsSQLServerAuditConfig


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsActiveDirectoryConfig:
    r"""
    SQL gcpm upbound io v1beta1 database instance spec for provider settings active directory config

    Attributes
    ----------
    domain : str, default is Undefined, optional
        The domain name for the active directory (e.g., mydomain.com).
        Can only be used with SQL Server.
    """


    domain?: str


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsAdvancedMachineFeatures:
    r"""
    SQL gcpm upbound io v1beta1 database instance spec for provider settings advanced machine features

    Attributes
    ----------
    threadsPerCore : float, default is Undefined, optional
        The number of threads per core. The value of this flag can be 1 or 2. To disable SMT, set this flag to 1. Only available in Cloud SQL for SQL Server instances. See smt for more details.
    """


    threadsPerCore?: float


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsBackupConfiguration:
    r"""
    SQL gcpm upbound io v1beta1 database instance spec for provider settings backup configuration

    Attributes
    ----------
    binaryLogEnabled : bool, default is Undefined, optional
        True if binary logging is enabled.
        Can only be used with MySQL.
    enabled : bool, default is Undefined, optional
        True if backup configuration is enabled.
    location : str, default is Undefined, optional
        The region where the backup will be stored
    pointInTimeRecoveryEnabled : bool, default is Undefined, optional
        True if Point-in-time recovery is enabled. Will restart database if enabled after instance creation. Valid only for PostgreSQL and SQL Server instances. Enabled by default for PostgreSQL Enterprise Plus and SQL Server Enterprise Plus instances.
    startTime : str, default is Undefined, optional
        HH:MM format time indicating when backup
        configuration starts.
    transactionLogRetentionDays : float, default is Undefined, optional
        The number of days of transaction logs we retain for point in time restore, from 1-7. For PostgreSQL Enterprise Plus and SQL Server Enterprise Plus instances, the number of days of retained transaction logs can be set from 1 to 35.
    backupRetentionSettings : SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsBackupConfigurationBackupRetentionSettings, default is Undefined, optional
        backup retention settings
    """


    binaryLogEnabled?: bool

    enabled?: bool

    location?: str

    pointInTimeRecoveryEnabled?: bool

    startTime?: str

    transactionLogRetentionDays?: float

    backupRetentionSettings?: SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsBackupConfigurationBackupRetentionSettings


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsBackupConfigurationBackupRetentionSettings:
    r"""
    Backup retention settings. The configuration is detailed below.

    Attributes
    ----------
    retainedBackups : float, default is Undefined, optional
        Depending on the value of retention_unit, this is used to determine if a backup needs to be deleted. If retention_unit
        is 'COUNT', we will retain this many backups.
    retentionUnit : str, default is Undefined, optional
        The unit that 'retained_backups' represents. Defaults to COUNT.
    """


    retainedBackups?: float

    retentionUnit?: str


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsConnectionPoolConfigItems0:
    r"""
    SQL gcpm upbound io v1beta1 database instance spec for provider settings connection pool config items0

    Attributes
    ----------
    connectionPoolingEnabled : bool, default is Undefined, optional
        :  True if the manager connection pooling configuration is enabled.
    flags : [SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsConnectionPoolConfigItems0FlagsItems0], default is Undefined, optional
        flags
    """


    connectionPoolingEnabled?: bool

    flags?: [SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsConnectionPoolConfigItems0FlagsItems0]


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsConnectionPoolConfigItems0FlagsItems0:
    r"""
    SQL gcpm upbound io v1beta1 database instance spec for provider settings connection pool config items0 flags items0

    Attributes
    ----------
    name : str, default is Undefined, optional
        A name for this whitelist entry.
    value : str, default is Undefined, optional
        A CIDR notation IPv4 or IPv6 address that is allowed to
        access this instance. Must be set even if other two attributes are not for
        the whitelist to become active.
    """


    name?: str

    value?: str


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsDataCacheConfig:
    r"""
    SQL gcpm upbound io v1beta1 database instance spec for provider settings data cache config

    Attributes
    ----------
    dataCacheEnabled : bool, default is Undefined, optional
        Whether data cache is enabled for the instance. Defaults to false. Can be used with MYSQL and PostgreSQL only.
    """


    dataCacheEnabled?: bool


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsDatabaseFlagsItems0:
    r"""
    SQL gcpm upbound io v1beta1 database instance spec for provider settings database flags items0

    Attributes
    ----------
    name : str, default is Undefined, optional
        A name for this whitelist entry.
    value : str, default is Undefined, optional
        A CIDR notation IPv4 or IPv6 address that is allowed to
        access this instance. Must be set even if other two attributes are not for
        the whitelist to become active.
    """


    name?: str

    value?: str


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsDenyMaintenancePeriod:
    r"""
    SQL gcpm upbound io v1beta1 database instance spec for provider settings deny maintenance period

    Attributes
    ----------
    endDate : str, default is Undefined, optional
        "deny maintenance period" end date. If the year of the end date is empty, the year of the start date also must be empty. In this case, it means the no maintenance interval recurs every year. The date is in format yyyy-m-dd (the month is without leading zeros)i.e., 2020-1-01, or 2020-11-01, or mm-dd, i.e., 11-01
    startDate : str, default is Undefined, optional
        "deny maintenance period" start date. If the year of the start date is empty, the year of the end date also must be empty. In this case, it means the deny maintenance period recurs every year. The date is in format yyyy-m-dd (the month is without leading zeros)i.e., 2020-1-01, or 2020-11-01, or mm-dd, i.e., 11-01
    time : str, default is Undefined, optional
        Time in UTC when the "deny maintenance period" starts on startDate and ends on endDate. The time is in format: HH:mm:SS, i.e., 00:00:00
    """


    endDate?: str

    startDate?: str

    time?: str


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsIPConfiguration:
    r"""
    SQL gcpm upbound io v1beta1 database instance spec for provider settings IP configuration

    Attributes
    ----------
    allocatedIpRange : str, default is Undefined, optional
        The name of the allocated ip range for the private ip CloudSQL instance. For example: "google-managed-services-default". If set, the instance ip will be created in the allocated range. The range name must comply with RFC 1035. Specifically, the name must be 1-63 characters long and match the regular expression a-z?.
    authorizedNetworks : [SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsIPConfigurationAuthorizedNetworksItems0], default is Undefined, optional
        authorized networks
    customSubjectAlternativeNames : [str], default is Undefined, optional
        The custom subject alternative names for an instance with CUSTOMER_MANAGED_CAS_CA as the server_ca_mode.
    enablePrivatePathForGoogleCloudServices : bool, default is Undefined, optional
        Whether Google Cloud services such as BigQuery are allowed to access data in this Cloud SQL instance over a private IP connection. SQLSERVER database type is not supported.
    ipv4Enabled : bool, default is Undefined, optional
        Whether this Cloud SQL instance should be assigned
        a public IPV4 address. At least ipv4_enabled must be enabled or a
        private_network must be configured.
    privateNetwork : str, default is Undefined, optional
        The VPC network from which the Cloud SQL
        instance is accessible for private IP. For example, projects/myProject/global/networks/default.
        Specifying a network enables private IP.
        At least ipv4_enabled must be enabled or a private_network must be configured.
        This setting can be updated, but it cannot be removed after it is set.
    pscConfig : [SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsIPConfigurationPscConfigItems0], default is Undefined, optional
        psc config
    serverCaMode : str, default is Undefined, optional
        Specify how the server certificate's Certificate Authority is hosted. Supported values are GOOGLE_MANAGED_INTERNAL_CA and GOOGLE_MANAGED_CAS_CA.
    serverCaPool : str, default is Undefined, optional
        The resource name of the server CA pool for an instance with CUSTOMER_MANAGED_CAS_CA as the server_ca_mode.
    sslMode : str, default is Undefined, optional
        Specify how SSL connection should be enforced in DB connections. Supported values are ALLOW_UNENCRYPTED_AND_ENCRYPTED, ENCRYPTED_ONLY, and TRUSTED_CLIENT_CERTIFICATE_REQUIRED (not supported for SQL Server). See API reference doc for details.
    privateNetworkRef : SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsIPConfigurationPrivateNetworkRef, default is Undefined, optional
        private network ref
    privateNetworkSelector : SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsIPConfigurationPrivateNetworkSelector, default is Undefined, optional
        private network selector
    """


    allocatedIpRange?: str

    authorizedNetworks?: [SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsIPConfigurationAuthorizedNetworksItems0]

    customSubjectAlternativeNames?: [str]

    enablePrivatePathForGoogleCloudServices?: bool

    ipv4Enabled?: bool

    privateNetwork?: str

    pscConfig?: [SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsIPConfigurationPscConfigItems0]

    serverCaMode?: str

    serverCaPool?: str

    sslMode?: str

    privateNetworkRef?: SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsIPConfigurationPrivateNetworkRef

    privateNetworkSelector?: SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsIPConfigurationPrivateNetworkSelector


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsIPConfigurationAuthorizedNetworksItems0:
    r"""
    SQL gcpm upbound io v1beta1 database instance spec for provider settings IP configuration authorized networks items0

    Attributes
    ----------
    expirationTime : str, default is Undefined, optional
        The RFC 3339
        formatted date time string indicating when this whitelist expires.
    name : str, default is Undefined, optional
        A name for this whitelist entry.
    value : str, default is Undefined, optional
        A CIDR notation IPv4 or IPv6 address that is allowed to
        access this instance. Must be set even if other two attributes are not for
        the whitelist to become active.
    """


    expirationTime?: str

    name?: str

    value?: str


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsIPConfigurationPrivateNetworkRef:
    r"""
    Reference to a Network in compute to populate privateNetwork.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsIPConfigurationPrivateNetworkRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsIPConfigurationPrivateNetworkRefPolicy


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsIPConfigurationPrivateNetworkRefPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsIPConfigurationPrivateNetworkSelector:
    r"""
    Selector for a Network in compute to populate privateNetwork.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsIPConfigurationPrivateNetworkSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsIPConfigurationPrivateNetworkSelectorPolicy


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsIPConfigurationPrivateNetworkSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsIPConfigurationPscConfigItems0:
    r"""
    SQL gcpm upbound io v1beta1 database instance spec for provider settings IP configuration psc config items0

    Attributes
    ----------
    allowedConsumerProjects : [str], default is Undefined, optional
        List of consumer projects that are allow-listed for PSC connections to this instance. This instance can be connected to with PSC from any network in these projects. Each consumer project in this list may be represented by a project number (numeric) or by a project id (alphanumeric).
    pscAutoConnections : [SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsIPConfigurationPscConfigItems0PscAutoConnectionsItems0], default is Undefined, optional
        A comma-separated list of networks or a comma-separated list of network-project pairs. Each project in this list is represented by a project number (numeric) or by a project ID (alphanumeric). This allows Private Service Connect connections to be created automatically for the specified networks.
    pscEnabled : bool, default is Undefined, optional
        Whether PSC connectivity is enabled for this instance.
    """


    allowedConsumerProjects?: [str]

    pscAutoConnections?: [SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsIPConfigurationPscConfigItems0PscAutoConnectionsItems0]

    pscEnabled?: bool


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsIPConfigurationPscConfigItems0PscAutoConnectionsItems0:
    r"""
    SQL gcpm upbound io v1beta1 database instance spec for provider settings IP configuration psc config items0 psc auto connections items0

    Attributes
    ----------
    consumerNetwork : str, default is Undefined, optional
        "The consumer network of this consumer endpoint. This must be a resource path that includes both the host project and the network name. For example, projects/project1/global/networks/network1. The consumer host project of this network might be different from the consumer service project."
    consumerServiceProjectId : str, default is Undefined, optional
        The project ID of consumer service project of this consumer endpoint.
    """


    consumerNetwork?: str

    consumerServiceProjectId?: str


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsInsightsConfig:
    r"""
    SQL gcpm upbound io v1beta1 database instance spec for provider settings insights config

    Attributes
    ----------
    queryInsightsEnabled : bool, default is Undefined, optional
        True if Query Insights feature is enabled.
    queryPlansPerMinute : float, default is Undefined, optional
        Number of query execution plans captured by Insights per minute for all queries combined. Between 0 and 20. Default to 5.
    queryStringLength : float, default is Undefined, optional
        Maximum query length stored in bytes. Between 256 and 4500. Default to 1024. Higher query lengths are more useful for analytical queries, but they also require more memory. Changing the query length requires you to restart the instance. You can still add tags to queries that exceed the length limit.
    recordApplicationTags : bool, default is Undefined, optional
        True if Query Insights will record application tags from query when enabled.
    recordClientAddress : bool, default is Undefined, optional
        True if Query Insights will record client address when enabled.
    """


    queryInsightsEnabled?: bool

    queryPlansPerMinute?: float

    queryStringLength?: float

    recordApplicationTags?: bool

    recordClientAddress?: bool


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsLocationPreference:
    r"""
    SQL gcpm upbound io v1beta1 database instance spec for provider settings location preference

    Attributes
    ----------
    followGaeApplication : str, default is Undefined, optional
        A GAE application whose zone to remain
        in. Must be in the same region as this instance.
    secondaryZone : str, default is Undefined, optional
        The preferred Compute Engine zone for the secondary/failover.
    zone : str, default is Undefined, optional
        The preferred compute engine
        zone.
    """


    followGaeApplication?: str

    secondaryZone?: str

    zone?: str


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsMaintenanceWindow:
    r"""
    SQL gcpm upbound io v1beta1 database instance spec for provider settings maintenance window

    Attributes
    ----------
    day : float, default is Undefined, optional
        Day of week (1-7), starting on Monday
    hour : float, default is Undefined, optional
        Hour of day (0-23), ignored if day not set
    updateTrack : str, default is Undefined, optional
        Receive updates after one week (canary) or after two weeks (stable) or after five weeks (week5) of notification.
    """


    day?: float

    hour?: float

    updateTrack?: str


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsPasswordValidationPolicy:
    r"""
    SQL gcpm upbound io v1beta1 database instance spec for provider settings password validation policy

    Attributes
    ----------
    complexity : str, default is Undefined, optional
        Checks if the password is a combination of lowercase, uppercase, numeric, and non-alphanumeric characters.
    disallowUsernameSubstring : bool, default is Undefined, optional
        Prevents the use of the username in the password.
    enablePasswordPolicy : bool, default is Undefined, optional
        Enables or disable the password validation policy.
    minLength : float, default is Undefined, optional
        Specifies the minimum number of characters that the password must have.
    passwordChangeInterval : str, default is Undefined, optional
        Specifies the minimum duration after which you can change the password.
    reuseInterval : float, default is Undefined, optional
        Specifies the number of previous passwords that you can't reuse.
    """


    complexity?: str

    disallowUsernameSubstring?: bool

    enablePasswordPolicy?: bool

    minLength?: float

    passwordChangeInterval?: str

    reuseInterval?: float


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecForProviderSettingsSQLServerAuditConfig:
    r"""
    SQL gcpm upbound io v1beta1 database instance spec for provider settings SQL server audit config

    Attributes
    ----------
    bucket : str, default is Undefined, optional
        The name of the destination bucket (e.g., gs://mybucket).
    retentionInterval : str, default is Undefined, optional
        How long to keep generated audit files. A duration in seconds with up to nine fractional digits, terminated by 's'. Example: "3.5s".
    uploadInterval : str, default is Undefined, optional
        How often to upload generated audit files. A duration in seconds with up to nine fractional digits, terminated by 's'. Example: "3.5s".
    """


    bucket?: str

    retentionInterval?: str

    uploadInterval?: str


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProvider:
    r"""
    THIS IS A BETA FIELD. It will be honored
    unless the Management Policies feature flag is disabled.
    InitProvider holds the same fields as ForProvider, with the exception
    of Identifier and other resource reference fields. The fields that are
    in InitProvider are merged into ForProvider when the resource is created.
    The same fields are also added to the terraform ignore_changes hook, to
    avoid updating them after creation. This is useful for fields that are
    required on creation, but we do not desire to update them after creation,
    for example because of an external controller is managing them, like an
    autoscaler.

    Attributes
    ----------
    databaseVersion : str, default is Undefined, optional
        The MySQL, PostgreSQL or
        SQL Server version to use. Supported values include MYSQL_5_6,
        MYSQL_5_7, MYSQL_8_0, MYSQL_8_4, POSTGRES_9_6,POSTGRES_10, POSTGRES_11,
        POSTGRES_12, POSTGRES_13, POSTGRES_14, POSTGRES_15, POSTGRES_16, POSTGRES_17,
        SQLSERVER_2017_STANDARD, SQLSERVER_2017_ENTERPRISE, SQLSERVER_2017_EXPRESS, SQLSERVER_2017_WEB.
        SQLSERVER_2019_STANDARD, SQLSERVER_2019_ENTERPRISE, SQLSERVER_2019_EXPRESS,
        SQLSERVER_2019_WEB.
        Database Version Policies
        includes an up-to-date reference of supported versions.
    deletionProtection : bool, default is Undefined, optional
        When the field is set to false, deleting the instance is allowed.
    encryptionKeyName : str, default is Undefined, optional
        The full path to the encryption key used for the CMEK disk encryption.
        The provided key must be in the same region as the SQL instance.  In order
        to use this feature, a special kind of service account must be created and
        granted permission on this key.  This step can currently only be done
        manually, please see this step.
        That service account needs the Cloud KMS > Cloud KMS CryptoKey Encrypter/Decrypter role on your
        key - please see this step.
    maintenanceVersion : str, default is Undefined, optional
        The current software version on the instance. This attribute can not be set during creation. Refer to available_maintenance_versions attribute to see what maintenance_version are available for upgrade. When this attribute gets updated, it will cause an instance restart. Setting a maintenance_version value that is older than the current one on the instance will be ignored.
    masterInstanceName : str, default is Undefined, optional
        The name of the existing instance that will
        act as the master in the replication setup. Note, this requires the master to
        have binary_log_enabled set, as well as existing backups.
    project : str, default is Undefined, optional
        The ID of the project in which the resource belongs. If it
        is not provided, the provider project is used.
    region : str, default is Undefined, optional
        The region the instance will sit in. If a region is not provided in the resource definition,
        the provider region will be used instead.
    replicaNames : [str], default is Undefined, optional
        List of replica names. Can be updated.
    clone : SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderClone, default is Undefined, optional
        clone
    replicaConfiguration : SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderReplicaConfiguration, default is Undefined, optional
        replica configuration
    replicationCluster : SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderReplicationCluster, default is Undefined, optional
        replication cluster
    restoreBackupContext : SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderRestoreBackupContext, default is Undefined, optional
        restore backup context
    rootPasswordSecretRef : SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderRootPasswordSecretRef, default is Undefined, optional
        root password secret ref
    settings : SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettings, default is Undefined, optional
        settings
    """


    databaseVersion?: str

    deletionProtection?: bool

    encryptionKeyName?: str

    maintenanceVersion?: str

    masterInstanceName?: str

    project?: str

    region?: str

    replicaNames?: [str]

    clone?: SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderClone

    replicaConfiguration?: SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderReplicaConfiguration

    replicationCluster?: SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderReplicationCluster

    restoreBackupContext?: SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderRestoreBackupContext

    rootPasswordSecretRef?: SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderRootPasswordSecretRef

    settings?: SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettings


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderClone:
    r"""
    The context needed to create this instance as a clone of another instance. The
    configuration is detailed below.

    Attributes
    ----------
    allocatedIpRange : str, default is Undefined, optional
        The name of the allocated ip range for the private ip CloudSQL instance. For example: "google-managed-services-default". If set, the cloned instance ip will be created in the allocated range. The range name must comply with RFC 1035. Specifically, the name must be 1-63 characters long and match the regular expression a-z?.
    databaseNames : [str], default is Undefined, optional
        (SQL Server only, use with point_in_time) Clone only the specified databases from the source instance. Clone all databases if empty.
    pointInTime : str, default is Undefined, optional
        The timestamp of the point in time that should be restored.
    preferredZone : str, default is Undefined, optional
        (Point-in-time recovery for PostgreSQL only) Clone to an instance in the specified zone. If no zone is specified, clone to the same zone as the source instance. clone-unavailable-instance
    sourceInstanceName : str, default is Undefined, optional
        Name of the source instance which will be cloned.
    """


    allocatedIpRange?: str

    databaseNames?: [str]

    pointInTime?: str

    preferredZone?: str

    sourceInstanceName?: str


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderReplicaConfiguration:
    r"""
    The configuration for replication. The
    configuration is detailed below.

    Attributes
    ----------
    caCertificate : str, default is Undefined, optional
        PEM representation of the trusted CA's x509
        certificate.
    cascadableReplica : bool, default is Undefined, optional
        Specifies if the replica is a cascadable replica. If true, instance must be in different region from primary.
    clientCertificate : str, default is Undefined, optional
        PEM representation of the replica's x509
        certificate.
    clientKey : str, default is Undefined, optional
        PEM representation of the replica's private key. The
        corresponding public key in encoded in the client_certificate.
    connectRetryInterval : float, default is Undefined, optional
        The number of seconds
        between connect retries. MySQL's default is 60 seconds.
    dumpFilePath : str, default is Undefined, optional
        Path to a SQL file in GCS from which replica
        instances are created. Format is gs://bucket/filename. Note, if the master
        instance is a source representation instance this field must be present.
    failoverTarget : bool, default is Undefined, optional
        Specifies if the replica is the failover target.
        If the field is set to true the replica will be designated as a failover replica.
        If the master instance fails, the replica instance will be promoted as
        the new master instance.
        ~> NOTE: Not supported for Postgres database.
    masterHeartbeatPeriod : float, default is Undefined, optional
        Time in ms between replication
        heartbeats.
    sslCipher : str, default is Undefined, optional
        Permissible ciphers for use in SSL encryption.
    username : str, default is Undefined, optional
        Username for replication connection.
    verifyServerCertificate : bool, default is Undefined, optional
        True if the master's common name
        value is checked during the SSL handshake.
    passwordSecretRef : SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderReplicaConfigurationPasswordSecretRef, default is Undefined, optional
        password secret ref
    """


    caCertificate?: str

    cascadableReplica?: bool

    clientCertificate?: str

    clientKey?: str

    connectRetryInterval?: float

    dumpFilePath?: str

    failoverTarget?: bool

    masterHeartbeatPeriod?: float

    sslCipher?: str

    username?: str

    verifyServerCertificate?: bool

    passwordSecretRef?: SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderReplicaConfigurationPasswordSecretRef


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderReplicaConfigurationPasswordSecretRef:
    r"""
    Password for the replication connection.

    Attributes
    ----------
    key : str, default is Undefined, required
        key
    name : str, default is Undefined, required
        Name of the secret.
    """


    key: str

    name: str


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderReplicationCluster:
    r"""
    SQL gcpm upbound io v1beta1 database instance spec init provider replication cluster

    Attributes
    ----------
    failoverDrReplicaName : str, default is Undefined, optional
        project:your-instance". You can also set this field to "your-instance", but cloud SQL backend will convert it to the aforementioned standard format.
    """


    failoverDrReplicaName?: str


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderRestoreBackupContext:
    r"""
    The context needed to restore the database to a backup run. The configuration is detailed below. Adding or modifying this
    block during resource creation/update will trigger the restore action after the resource is created/updated.

    Attributes
    ----------
    backupRunId : float, default is Undefined, optional
        The ID of the backup run to restore from.
    instanceId : str, default is Undefined, optional
        The ID of the instance that the backup was taken from. If left empty,
        this instance's ID will be used.
    project : str, default is Undefined, optional
        The full project ID of the source instance.`
    """


    backupRunId?: float

    instanceId?: str

    project?: str


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderRootPasswordSecretRef:
    r"""
    Initial root password. Can be updated. Required for MS SQL Server.

    Attributes
    ----------
    key : str, default is Undefined, required
        key
    name : str, default is Undefined, required
        Name of the secret.
    """


    key: str

    name: str


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettings:
    r"""
    The settings to use for the database. The
    configuration is detailed below. Required if clone is not set.

    Attributes
    ----------
    activationPolicy : str, default is Undefined, optional
        This specifies when the instance should be
        active. Can be either ALWAYS, NEVER or ON_DEMAND.
    availabilityType : str, default is Undefined, optional
        The availability type of the Cloud SQL
        instance, high availability (REGIONAL) or single zone (ZONAL).' For all instances, ensure that
        settings.backup_configuration.enabled is set to true.
        For MySQL instances, ensure that settings.backup_configuration.binary_log_enabled is set to true.
        For Postgres and SQL Server instances, ensure that settings.backup_configuration.point_in_time_recovery_enabled
        is set to true. Defaults to ZONAL.
    collation : str, default is Undefined, optional
        The name of server instance collation.
    connectionPoolConfig : [SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsConnectionPoolConfigItems0], default is Undefined, optional
        connection pool config
    connectorEnforcement : str, default is Undefined, optional
        Control the enforcement of Cloud SQL Auth Proxy or Cloud SQL connectors for all the connections, can be REQUIRED or NOT_REQUIRED. If enabled, all the direct connections are rejected.
    databaseFlags : [SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsDatabaseFlagsItems0], default is Undefined, optional
        database flags
    deletionProtectionEnabled : bool, default is Undefined, optional
        .
    diskAutoresize : bool, default is Undefined, optional
        Enables auto-resizing of the storage size. Defaults to true. To avoid this, ensure that lifecycle.ignore_changes is applied to disk_size.
    diskAutoresizeLimit : float, default is Undefined, optional
        The maximum size to which storage capacity can be automatically increased. The default value is 0, which specifies that there is no limit.
    diskSize : float, default is Undefined, optional
        The size of data disk, in GB. Size of a running instance cannot be reduced but can be increased. The minimum value is 10GB for PD_SSD, PD_HDD and 20GB for HYPERDISK_BALANCED. Note that this value will override the resizing from disk_autoresize if that feature is enabled. To avoid this, set lifecycle.ignore_changes on this field.
    diskType : str, default is Undefined, optional
        The type of data disk: PD_SSD, PD_HDD, or HYPERDISK_BALANCED. Defaults to PD_SSD. HYPERDISK_BALANCED is preview.
    edition : str, default is Undefined, optional
        The edition of the instance, can be ENTERPRISE or ENTERPRISE_PLUS.
    enableDataplexIntegration : bool, default is Undefined, optional
        Enables Cloud SQL instance integration with Dataplex. MySQL, Postgres and SQL Server instances are supported for this feature. Defaults to false.
    enableGoogleMlIntegration : bool, default is Undefined, optional
        Enables Cloud SQL instances to connect to Vertex AI and pass requests for real-time predictions and insights. Defaults to false.
    pricingPlan : str, default is Undefined, optional
        Pricing plan for this instance, can only be PER_USE.
    retainBackupsOnDelete : bool, default is Undefined, optional
        When this parameter is set to true, Cloud SQL retains backups of the instance even after the instance is deleted. The ON_DEMAND backup will be retained until customer deletes the backup or the project. The AUTOMATED backup will be retained based on the backups retention setting.
    tier : str, default is Undefined, optional
        The machine type to use. See tiers
        for more details and supported versions. Postgres supports only shared-core machine types,
        and custom machine types such as db-custom-2-13312. See the Custom Machine Type Documentation to learn about specifying custom machine types.
    timeZone : str, default is Undefined, optional
        The time_zone to be used by the database engine (supported only for SQL Server), in SQL Server timezone format.
    userLabels : {str:str}, default is Undefined, optional
        A set of key/value user label pairs to assign to the instance.
    activeDirectoryConfig : SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsActiveDirectoryConfig, default is Undefined, optional
        active directory config
    advancedMachineFeatures : SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsAdvancedMachineFeatures, default is Undefined, optional
        advanced machine features
    backupConfiguration : SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsBackupConfiguration, default is Undefined, optional
        backup configuration
    dataCacheConfig : SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsDataCacheConfig, default is Undefined, optional
        data cache config
    denyMaintenancePeriod : SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsDenyMaintenancePeriod, default is Undefined, optional
        deny maintenance period
    insightsConfig : SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsInsightsConfig, default is Undefined, optional
        insights config
    ipConfiguration : SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsIPConfiguration, default is Undefined, optional
        ip configuration
    locationPreference : SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsLocationPreference, default is Undefined, optional
        location preference
    maintenanceWindow : SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsMaintenanceWindow, default is Undefined, optional
        maintenance window
    passwordValidationPolicy : SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsPasswordValidationPolicy, default is Undefined, optional
        password validation policy
    sqlServerAuditConfig : SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsSQLServerAuditConfig, default is Undefined, optional
        sql server audit config
    """


    activationPolicy?: str

    availabilityType?: str

    collation?: str

    connectionPoolConfig?: [SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsConnectionPoolConfigItems0]

    connectorEnforcement?: str

    databaseFlags?: [SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsDatabaseFlagsItems0]

    deletionProtectionEnabled?: bool

    diskAutoresize?: bool

    diskAutoresizeLimit?: float

    diskSize?: float

    diskType?: str

    edition?: str

    enableDataplexIntegration?: bool

    enableGoogleMlIntegration?: bool

    pricingPlan?: str

    retainBackupsOnDelete?: bool

    tier?: str

    timeZone?: str

    userLabels?: {str:str}

    activeDirectoryConfig?: SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsActiveDirectoryConfig

    advancedMachineFeatures?: SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsAdvancedMachineFeatures

    backupConfiguration?: SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsBackupConfiguration

    dataCacheConfig?: SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsDataCacheConfig

    denyMaintenancePeriod?: SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsDenyMaintenancePeriod

    insightsConfig?: SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsInsightsConfig

    ipConfiguration?: SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsIPConfiguration

    locationPreference?: SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsLocationPreference

    maintenanceWindow?: SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsMaintenanceWindow

    passwordValidationPolicy?: SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsPasswordValidationPolicy

    sqlServerAuditConfig?: SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsSQLServerAuditConfig


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsActiveDirectoryConfig:
    r"""
    SQL gcpm upbound io v1beta1 database instance spec init provider settings active directory config

    Attributes
    ----------
    domain : str, default is Undefined, optional
        The domain name for the active directory (e.g., mydomain.com).
        Can only be used with SQL Server.
    """


    domain?: str


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsAdvancedMachineFeatures:
    r"""
    SQL gcpm upbound io v1beta1 database instance spec init provider settings advanced machine features

    Attributes
    ----------
    threadsPerCore : float, default is Undefined, optional
        The number of threads per core. The value of this flag can be 1 or 2. To disable SMT, set this flag to 1. Only available in Cloud SQL for SQL Server instances. See smt for more details.
    """


    threadsPerCore?: float


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsBackupConfiguration:
    r"""
    SQL gcpm upbound io v1beta1 database instance spec init provider settings backup configuration

    Attributes
    ----------
    binaryLogEnabled : bool, default is Undefined, optional
        True if binary logging is enabled.
        Can only be used with MySQL.
    enabled : bool, default is Undefined, optional
        True if backup configuration is enabled.
    location : str, default is Undefined, optional
        The region where the backup will be stored
    pointInTimeRecoveryEnabled : bool, default is Undefined, optional
        True if Point-in-time recovery is enabled. Will restart database if enabled after instance creation. Valid only for PostgreSQL and SQL Server instances. Enabled by default for PostgreSQL Enterprise Plus and SQL Server Enterprise Plus instances.
    startTime : str, default is Undefined, optional
        HH:MM format time indicating when backup
        configuration starts.
    transactionLogRetentionDays : float, default is Undefined, optional
        The number of days of transaction logs we retain for point in time restore, from 1-7. For PostgreSQL Enterprise Plus and SQL Server Enterprise Plus instances, the number of days of retained transaction logs can be set from 1 to 35.
    backupRetentionSettings : SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsBackupConfigurationBackupRetentionSettings, default is Undefined, optional
        backup retention settings
    """


    binaryLogEnabled?: bool

    enabled?: bool

    location?: str

    pointInTimeRecoveryEnabled?: bool

    startTime?: str

    transactionLogRetentionDays?: float

    backupRetentionSettings?: SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsBackupConfigurationBackupRetentionSettings


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsBackupConfigurationBackupRetentionSettings:
    r"""
    Backup retention settings. The configuration is detailed below.

    Attributes
    ----------
    retainedBackups : float, default is Undefined, optional
        Depending on the value of retention_unit, this is used to determine if a backup needs to be deleted. If retention_unit
        is 'COUNT', we will retain this many backups.
    retentionUnit : str, default is Undefined, optional
        The unit that 'retained_backups' represents. Defaults to COUNT.
    """


    retainedBackups?: float

    retentionUnit?: str


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsConnectionPoolConfigItems0:
    r"""
    SQL gcpm upbound io v1beta1 database instance spec init provider settings connection pool config items0

    Attributes
    ----------
    connectionPoolingEnabled : bool, default is Undefined, optional
        :  True if the manager connection pooling configuration is enabled.
    flags : [SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsConnectionPoolConfigItems0FlagsItems0], default is Undefined, optional
        flags
    """


    connectionPoolingEnabled?: bool

    flags?: [SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsConnectionPoolConfigItems0FlagsItems0]


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsConnectionPoolConfigItems0FlagsItems0:
    r"""
    SQL gcpm upbound io v1beta1 database instance spec init provider settings connection pool config items0 flags items0

    Attributes
    ----------
    name : str, default is Undefined, optional
        A name for this whitelist entry.
    value : str, default is Undefined, optional
        A CIDR notation IPv4 or IPv6 address that is allowed to
        access this instance. Must be set even if other two attributes are not for
        the whitelist to become active.
    """


    name?: str

    value?: str


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsDataCacheConfig:
    r"""
    SQL gcpm upbound io v1beta1 database instance spec init provider settings data cache config

    Attributes
    ----------
    dataCacheEnabled : bool, default is Undefined, optional
        Whether data cache is enabled for the instance. Defaults to false. Can be used with MYSQL and PostgreSQL only.
    """


    dataCacheEnabled?: bool


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsDatabaseFlagsItems0:
    r"""
    SQL gcpm upbound io v1beta1 database instance spec init provider settings database flags items0

    Attributes
    ----------
    name : str, default is Undefined, optional
        A name for this whitelist entry.
    value : str, default is Undefined, optional
        A CIDR notation IPv4 or IPv6 address that is allowed to
        access this instance. Must be set even if other two attributes are not for
        the whitelist to become active.
    """


    name?: str

    value?: str


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsDenyMaintenancePeriod:
    r"""
    SQL gcpm upbound io v1beta1 database instance spec init provider settings deny maintenance period

    Attributes
    ----------
    endDate : str, default is Undefined, optional
        "deny maintenance period" end date. If the year of the end date is empty, the year of the start date also must be empty. In this case, it means the no maintenance interval recurs every year. The date is in format yyyy-m-dd (the month is without leading zeros)i.e., 2020-1-01, or 2020-11-01, or mm-dd, i.e., 11-01
    startDate : str, default is Undefined, optional
        "deny maintenance period" start date. If the year of the start date is empty, the year of the end date also must be empty. In this case, it means the deny maintenance period recurs every year. The date is in format yyyy-m-dd (the month is without leading zeros)i.e., 2020-1-01, or 2020-11-01, or mm-dd, i.e., 11-01
    time : str, default is Undefined, optional
        Time in UTC when the "deny maintenance period" starts on startDate and ends on endDate. The time is in format: HH:mm:SS, i.e., 00:00:00
    """


    endDate?: str

    startDate?: str

    time?: str


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsIPConfiguration:
    r"""
    SQL gcpm upbound io v1beta1 database instance spec init provider settings IP configuration

    Attributes
    ----------
    allocatedIpRange : str, default is Undefined, optional
        The name of the allocated ip range for the private ip CloudSQL instance. For example: "google-managed-services-default". If set, the instance ip will be created in the allocated range. The range name must comply with RFC 1035. Specifically, the name must be 1-63 characters long and match the regular expression a-z?.
    authorizedNetworks : [SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsIPConfigurationAuthorizedNetworksItems0], default is Undefined, optional
        authorized networks
    customSubjectAlternativeNames : [str], default is Undefined, optional
        The custom subject alternative names for an instance with CUSTOMER_MANAGED_CAS_CA as the server_ca_mode.
    enablePrivatePathForGoogleCloudServices : bool, default is Undefined, optional
        Whether Google Cloud services such as BigQuery are allowed to access data in this Cloud SQL instance over a private IP connection. SQLSERVER database type is not supported.
    ipv4Enabled : bool, default is Undefined, optional
        Whether this Cloud SQL instance should be assigned
        a public IPV4 address. At least ipv4_enabled must be enabled or a
        private_network must be configured.
    privateNetwork : str, default is Undefined, optional
        The VPC network from which the Cloud SQL
        instance is accessible for private IP. For example, projects/myProject/global/networks/default.
        Specifying a network enables private IP.
        At least ipv4_enabled must be enabled or a private_network must be configured.
        This setting can be updated, but it cannot be removed after it is set.
    pscConfig : [SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsIPConfigurationPscConfigItems0], default is Undefined, optional
        psc config
    serverCaMode : str, default is Undefined, optional
        Specify how the server certificate's Certificate Authority is hosted. Supported values are GOOGLE_MANAGED_INTERNAL_CA and GOOGLE_MANAGED_CAS_CA.
    serverCaPool : str, default is Undefined, optional
        The resource name of the server CA pool for an instance with CUSTOMER_MANAGED_CAS_CA as the server_ca_mode.
    sslMode : str, default is Undefined, optional
        Specify how SSL connection should be enforced in DB connections. Supported values are ALLOW_UNENCRYPTED_AND_ENCRYPTED, ENCRYPTED_ONLY, and TRUSTED_CLIENT_CERTIFICATE_REQUIRED (not supported for SQL Server). See API reference doc for details.
    privateNetworkRef : SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsIPConfigurationPrivateNetworkRef, default is Undefined, optional
        private network ref
    privateNetworkSelector : SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsIPConfigurationPrivateNetworkSelector, default is Undefined, optional
        private network selector
    """


    allocatedIpRange?: str

    authorizedNetworks?: [SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsIPConfigurationAuthorizedNetworksItems0]

    customSubjectAlternativeNames?: [str]

    enablePrivatePathForGoogleCloudServices?: bool

    ipv4Enabled?: bool

    privateNetwork?: str

    pscConfig?: [SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsIPConfigurationPscConfigItems0]

    serverCaMode?: str

    serverCaPool?: str

    sslMode?: str

    privateNetworkRef?: SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsIPConfigurationPrivateNetworkRef

    privateNetworkSelector?: SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsIPConfigurationPrivateNetworkSelector


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsIPConfigurationAuthorizedNetworksItems0:
    r"""
    SQL gcpm upbound io v1beta1 database instance spec init provider settings IP configuration authorized networks items0

    Attributes
    ----------
    expirationTime : str, default is Undefined, optional
        The RFC 3339
        formatted date time string indicating when this whitelist expires.
    name : str, default is Undefined, optional
        A name for this whitelist entry.
    value : str, default is Undefined, optional
        A CIDR notation IPv4 or IPv6 address that is allowed to
        access this instance. Must be set even if other two attributes are not for
        the whitelist to become active.
    """


    expirationTime?: str

    name?: str

    value?: str


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsIPConfigurationPrivateNetworkRef:
    r"""
    Reference to a Network in compute to populate privateNetwork.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsIPConfigurationPrivateNetworkRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsIPConfigurationPrivateNetworkRefPolicy


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsIPConfigurationPrivateNetworkRefPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsIPConfigurationPrivateNetworkSelector:
    r"""
    Selector for a Network in compute to populate privateNetwork.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsIPConfigurationPrivateNetworkSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsIPConfigurationPrivateNetworkSelectorPolicy


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsIPConfigurationPrivateNetworkSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsIPConfigurationPscConfigItems0:
    r"""
    SQL gcpm upbound io v1beta1 database instance spec init provider settings IP configuration psc config items0

    Attributes
    ----------
    allowedConsumerProjects : [str], default is Undefined, optional
        List of consumer projects that are allow-listed for PSC connections to this instance. This instance can be connected to with PSC from any network in these projects. Each consumer project in this list may be represented by a project number (numeric) or by a project id (alphanumeric).
    pscAutoConnections : [SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsIPConfigurationPscConfigItems0PscAutoConnectionsItems0], default is Undefined, optional
        A comma-separated list of networks or a comma-separated list of network-project pairs. Each project in this list is represented by a project number (numeric) or by a project ID (alphanumeric). This allows Private Service Connect connections to be created automatically for the specified networks.
    pscEnabled : bool, default is Undefined, optional
        Whether PSC connectivity is enabled for this instance.
    """


    allowedConsumerProjects?: [str]

    pscAutoConnections?: [SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsIPConfigurationPscConfigItems0PscAutoConnectionsItems0]

    pscEnabled?: bool


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsIPConfigurationPscConfigItems0PscAutoConnectionsItems0:
    r"""
    SQL gcpm upbound io v1beta1 database instance spec init provider settings IP configuration psc config items0 psc auto connections items0

    Attributes
    ----------
    consumerNetwork : str, default is Undefined, optional
        "The consumer network of this consumer endpoint. This must be a resource path that includes both the host project and the network name. For example, projects/project1/global/networks/network1. The consumer host project of this network might be different from the consumer service project."
    consumerServiceProjectId : str, default is Undefined, optional
        The project ID of consumer service project of this consumer endpoint.
    """


    consumerNetwork?: str

    consumerServiceProjectId?: str


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsInsightsConfig:
    r"""
    SQL gcpm upbound io v1beta1 database instance spec init provider settings insights config

    Attributes
    ----------
    queryInsightsEnabled : bool, default is Undefined, optional
        True if Query Insights feature is enabled.
    queryPlansPerMinute : float, default is Undefined, optional
        Number of query execution plans captured by Insights per minute for all queries combined. Between 0 and 20. Default to 5.
    queryStringLength : float, default is Undefined, optional
        Maximum query length stored in bytes. Between 256 and 4500. Default to 1024. Higher query lengths are more useful for analytical queries, but they also require more memory. Changing the query length requires you to restart the instance. You can still add tags to queries that exceed the length limit.
    recordApplicationTags : bool, default is Undefined, optional
        True if Query Insights will record application tags from query when enabled.
    recordClientAddress : bool, default is Undefined, optional
        True if Query Insights will record client address when enabled.
    """


    queryInsightsEnabled?: bool

    queryPlansPerMinute?: float

    queryStringLength?: float

    recordApplicationTags?: bool

    recordClientAddress?: bool


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsLocationPreference:
    r"""
    SQL gcpm upbound io v1beta1 database instance spec init provider settings location preference

    Attributes
    ----------
    followGaeApplication : str, default is Undefined, optional
        A GAE application whose zone to remain
        in. Must be in the same region as this instance.
    secondaryZone : str, default is Undefined, optional
        The preferred Compute Engine zone for the secondary/failover.
    zone : str, default is Undefined, optional
        The preferred compute engine
        zone.
    """


    followGaeApplication?: str

    secondaryZone?: str

    zone?: str


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsMaintenanceWindow:
    r"""
    SQL gcpm upbound io v1beta1 database instance spec init provider settings maintenance window

    Attributes
    ----------
    day : float, default is Undefined, optional
        Day of week (1-7), starting on Monday
    hour : float, default is Undefined, optional
        Hour of day (0-23), ignored if day not set
    updateTrack : str, default is Undefined, optional
        Receive updates after one week (canary) or after two weeks (stable) or after five weeks (week5) of notification.
    """


    day?: float

    hour?: float

    updateTrack?: str


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsPasswordValidationPolicy:
    r"""
    SQL gcpm upbound io v1beta1 database instance spec init provider settings password validation policy

    Attributes
    ----------
    complexity : str, default is Undefined, optional
        Checks if the password is a combination of lowercase, uppercase, numeric, and non-alphanumeric characters.
    disallowUsernameSubstring : bool, default is Undefined, optional
        Prevents the use of the username in the password.
    enablePasswordPolicy : bool, default is Undefined, optional
        Enables or disable the password validation policy.
    minLength : float, default is Undefined, optional
        Specifies the minimum number of characters that the password must have.
    passwordChangeInterval : str, default is Undefined, optional
        Specifies the minimum duration after which you can change the password.
    reuseInterval : float, default is Undefined, optional
        Specifies the number of previous passwords that you can't reuse.
    """


    complexity?: str

    disallowUsernameSubstring?: bool

    enablePasswordPolicy?: bool

    minLength?: float

    passwordChangeInterval?: str

    reuseInterval?: float


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecInitProviderSettingsSQLServerAuditConfig:
    r"""
    SQL gcpm upbound io v1beta1 database instance spec init provider settings SQL server audit config

    Attributes
    ----------
    bucket : str, default is Undefined, optional
        The name of the destination bucket (e.g., gs://mybucket).
    retentionInterval : str, default is Undefined, optional
        How long to keep generated audit files. A duration in seconds with up to nine fractional digits, terminated by 's'. Example: "3.5s".
    uploadInterval : str, default is Undefined, optional
        How often to upload generated audit files. A duration in seconds with up to nine fractional digits, terminated by 's'. Example: "3.5s".
    """


    bucket?: str

    retentionInterval?: str

    uploadInterval?: str


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecProviderConfigRef:
    r"""
    ProviderConfigReference specifies how the provider that will be used to
    create, observe, update, and delete this managed resource should be
    configured.

    Attributes
    ----------
    kind : str, default is Undefined, required
        Kind of the referenced object.
    name : str, default is Undefined, required
        Name of the referenced object.
    """


    kind: str

    name: str


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceSpecWriteConnectionSecretToRef:
    r"""
    WriteConnectionSecretToReference specifies the namespace and name of a
    Secret to which any connection details for this managed resource should
    be written. Connection details frequently include the endpoint, username,
    and password required to connect to the managed resource.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the secret.
    """


    name: str


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceStatus:
    r"""
    DatabaseInstanceStatus defines the observed state of DatabaseInstance.

    Attributes
    ----------
    conditions : [SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusConditionsItems0], default is Undefined, optional
        Conditions of the resource.
    observedGeneration : int, default is Undefined, optional
        ObservedGeneration is the latest metadata.generation
        which resulted in either a ready state, or stalled due to error
        it can not recover from without human intervention.
    atProvider : SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProvider, default is Undefined, optional
        at provider
    """


    conditions?: [SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusConditionsItems0]

    observedGeneration?: int

    atProvider?: SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProvider


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProvider:
    r"""
    SQL gcpm upbound io v1beta1 database instance status at provider

    Attributes
    ----------
    availableMaintenanceVersions : [str], default is Undefined, optional
        The list of all maintenance versions applicable on the instance.
    connectionName : str, default is Undefined, optional
        The connection name of the instance to be used in
        connection strings. For example, when connecting with Cloud SQL Proxy.
    databaseVersion : str, default is Undefined, optional
        The MySQL, PostgreSQL or
        SQL Server version to use. Supported values include MYSQL_5_6,
        MYSQL_5_7, MYSQL_8_0, MYSQL_8_4, POSTGRES_9_6,POSTGRES_10, POSTGRES_11,
        POSTGRES_12, POSTGRES_13, POSTGRES_14, POSTGRES_15, POSTGRES_16, POSTGRES_17,
        SQLSERVER_2017_STANDARD, SQLSERVER_2017_ENTERPRISE, SQLSERVER_2017_EXPRESS, SQLSERVER_2017_WEB.
        SQLSERVER_2019_STANDARD, SQLSERVER_2019_ENTERPRISE, SQLSERVER_2019_EXPRESS,
        SQLSERVER_2019_WEB.
        Database Version Policies
        includes an up-to-date reference of supported versions.
    deletionProtection : bool, default is Undefined, optional
        When the field is set to false, deleting the instance is allowed.
    dnsName : str, default is Undefined, optional
        The DNS name of the instance. See Connect to an instance using Private Service Connect for more details.
    dnsNames : [SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderDNSNamesItems0], default is Undefined, optional
        The list of DNS names used by this instance. Different connection types for an instance may have different DNS names. DNS names can apply to an individual instance or a cluster of instances.
    encryptionKeyName : str, default is Undefined, optional
        The full path to the encryption key used for the CMEK disk encryption.
        The provided key must be in the same region as the SQL instance.  In order
        to use this feature, a special kind of service account must be created and
        granted permission on this key.  This step can currently only be done
        manually, please see this step.
        That service account needs the Cloud KMS > Cloud KMS CryptoKey Encrypter/Decrypter role on your
        key - please see this step.
    firstIpAddress : str, default is Undefined, optional
        The first IPv4 address of any type assigned.
    id : str, default is Undefined, optional
        id
    instanceType : str, default is Undefined, optional
        The type of the instance. The supported values are SQL_INSTANCE_TYPE_UNSPECIFIED, CLOUD_SQL_INSTANCE, ON_PREMISES_INSTANCE and READ_REPLICA_INSTANCE.
    ipAddress : [SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderIPAddressItems0], default is Undefined, optional
        The IPv4 address assigned.
    maintenanceVersion : str, default is Undefined, optional
        The current software version on the instance. This attribute can not be set during creation. Refer to available_maintenance_versions attribute to see what maintenance_version are available for upgrade. When this attribute gets updated, it will cause an instance restart. Setting a maintenance_version value that is older than the current one on the instance will be ignored.
    masterInstanceName : str, default is Undefined, optional
        The name of the existing instance that will
        act as the master in the replication setup. Note, this requires the master to
        have binary_log_enabled set, as well as existing backups.
    privateIpAddress : str, default is Undefined, optional
        The first private (PRIVATE) IPv4 address assigned.
    project : str, default is Undefined, optional
        The ID of the project in which the resource belongs. If it
        is not provided, the provider project is used.
    pscServiceAttachmentLink : str, default is Undefined, optional
        the URI that points to the service attachment of the instance.
    publicIpAddress : str, default is Undefined, optional
        The first public (PRIMARY) IPv4 address assigned.
    region : str, default is Undefined, optional
        The region the instance will sit in. If a region is not provided in the resource definition,
        the provider region will be used instead.
    replicaNames : [str], default is Undefined, optional
        List of replica names. Can be updated.
    selfLink : str, default is Undefined, optional
        The URI of the created resource.
    serviceAccountEmailAddress : str, default is Undefined, optional
        The service account email address assigned to the
        instance.
    clone : SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderClone, default is Undefined, optional
        clone
    replicaConfiguration : SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderReplicaConfiguration, default is Undefined, optional
        replica configuration
    replicationCluster : SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderReplicationCluster, default is Undefined, optional
        replication cluster
    restoreBackupContext : SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderRestoreBackupContext, default is Undefined, optional
        restore backup context
    settings : SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettings, default is Undefined, optional
        settings
    """


    availableMaintenanceVersions?: [str]

    connectionName?: str

    databaseVersion?: str

    deletionProtection?: bool

    dnsName?: str

    dnsNames?: [SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderDNSNamesItems0]

    encryptionKeyName?: str

    firstIpAddress?: str

    id?: str

    instanceType?: str

    ipAddress?: [SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderIPAddressItems0]

    maintenanceVersion?: str

    masterInstanceName?: str

    privateIpAddress?: str

    project?: str

    pscServiceAttachmentLink?: str

    publicIpAddress?: str

    region?: str

    replicaNames?: [str]

    selfLink?: str

    serviceAccountEmailAddress?: str

    clone?: SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderClone

    replicaConfiguration?: SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderReplicaConfiguration

    replicationCluster?: SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderReplicationCluster

    restoreBackupContext?: SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderRestoreBackupContext

    settings?: SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettings


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderClone:
    r"""
    The context needed to create this instance as a clone of another instance. The
    configuration is detailed below.

    Attributes
    ----------
    allocatedIpRange : str, default is Undefined, optional
        The name of the allocated ip range for the private ip CloudSQL instance. For example: "google-managed-services-default". If set, the cloned instance ip will be created in the allocated range. The range name must comply with RFC 1035. Specifically, the name must be 1-63 characters long and match the regular expression a-z?.
    databaseNames : [str], default is Undefined, optional
        (SQL Server only, use with point_in_time) Clone only the specified databases from the source instance. Clone all databases if empty.
    pointInTime : str, default is Undefined, optional
        The timestamp of the point in time that should be restored.
    preferredZone : str, default is Undefined, optional
        (Point-in-time recovery for PostgreSQL only) Clone to an instance in the specified zone. If no zone is specified, clone to the same zone as the source instance. clone-unavailable-instance
    sourceInstanceName : str, default is Undefined, optional
        Name of the source instance which will be cloned.
    """


    allocatedIpRange?: str

    databaseNames?: [str]

    pointInTime?: str

    preferredZone?: str

    sourceInstanceName?: str


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderDNSNamesItems0:
    r"""
    SQL gcpm upbound io v1beta1 database instance status at provider DNS names items0

    Attributes
    ----------
    connectionType : str, default is Undefined, optional
        The connection type of the DNS name. Can be either PUBLIC, PRIVATE_SERVICES_ACCESS, or PRIVATE_SERVICE_CONNECT.
    dnsScope : str, default is Undefined, optional
        The scope that the DNS name applies to.
    name : str, default is Undefined, optional
        A name for this whitelist entry.
    """


    connectionType?: str

    dnsScope?: str

    name?: str


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderIPAddressItems0:
    r"""
    SQL gcpm upbound io v1beta1 database instance status at provider IP address items0

    Attributes
    ----------
    ipAddress : str, default is Undefined, optional
        The IPv4 address assigned.
    timeToRetire : str, default is Undefined, optional
        The time this IP address will be retired, in RFC
        3339 format.
    $type : str, default is Undefined, optional
        The type of this IP address.
    """


    ipAddress?: str

    timeToRetire?: str

    $type?: str


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderReplicaConfiguration:
    r"""
    The configuration for replication. The
    configuration is detailed below.

    Attributes
    ----------
    caCertificate : str, default is Undefined, optional
        PEM representation of the trusted CA's x509
        certificate.
    cascadableReplica : bool, default is Undefined, optional
        Specifies if the replica is a cascadable replica. If true, instance must be in different region from primary.
    clientCertificate : str, default is Undefined, optional
        PEM representation of the replica's x509
        certificate.
    clientKey : str, default is Undefined, optional
        PEM representation of the replica's private key. The
        corresponding public key in encoded in the client_certificate.
    connectRetryInterval : float, default is Undefined, optional
        The number of seconds
        between connect retries. MySQL's default is 60 seconds.
    dumpFilePath : str, default is Undefined, optional
        Path to a SQL file in GCS from which replica
        instances are created. Format is gs://bucket/filename. Note, if the master
        instance is a source representation instance this field must be present.
    failoverTarget : bool, default is Undefined, optional
        Specifies if the replica is the failover target.
        If the field is set to true the replica will be designated as a failover replica.
        If the master instance fails, the replica instance will be promoted as
        the new master instance.
        ~> NOTE: Not supported for Postgres database.
    masterHeartbeatPeriod : float, default is Undefined, optional
        Time in ms between replication
        heartbeats.
    sslCipher : str, default is Undefined, optional
        Permissible ciphers for use in SSL encryption.
    username : str, default is Undefined, optional
        Username for replication connection.
    verifyServerCertificate : bool, default is Undefined, optional
        True if the master's common name
        value is checked during the SSL handshake.
    """


    caCertificate?: str

    cascadableReplica?: bool

    clientCertificate?: str

    clientKey?: str

    connectRetryInterval?: float

    dumpFilePath?: str

    failoverTarget?: bool

    masterHeartbeatPeriod?: float

    sslCipher?: str

    username?: str

    verifyServerCertificate?: bool


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderReplicationCluster:
    r"""
    SQL gcpm upbound io v1beta1 database instance status at provider replication cluster

    Attributes
    ----------
    drReplica : bool, default is Undefined, optional
        only field that indicates whether the replica is a DR replica.
    failoverDrReplicaName : str, default is Undefined, optional
        project:your-instance". You can also set this field to "your-instance", but cloud SQL backend will convert it to the aforementioned standard format.
    """


    drReplica?: bool

    failoverDrReplicaName?: str


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderRestoreBackupContext:
    r"""
    The context needed to restore the database to a backup run. The configuration is detailed below. Adding or modifying this
    block during resource creation/update will trigger the restore action after the resource is created/updated.

    Attributes
    ----------
    backupRunId : float, default is Undefined, optional
        The ID of the backup run to restore from.
    instanceId : str, default is Undefined, optional
        The ID of the instance that the backup was taken from. If left empty,
        this instance's ID will be used.
    project : str, default is Undefined, optional
        The full project ID of the source instance.`
    """


    backupRunId?: float

    instanceId?: str

    project?: str


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettings:
    r"""
    The settings to use for the database. The
    configuration is detailed below. Required if clone is not set.

    Attributes
    ----------
    activationPolicy : str, default is Undefined, optional
        This specifies when the instance should be
        active. Can be either ALWAYS, NEVER or ON_DEMAND.
    availabilityType : str, default is Undefined, optional
        The availability type of the Cloud SQL
        instance, high availability (REGIONAL) or single zone (ZONAL).' For all instances, ensure that
        settings.backup_configuration.enabled is set to true.
        For MySQL instances, ensure that settings.backup_configuration.binary_log_enabled is set to true.
        For Postgres and SQL Server instances, ensure that settings.backup_configuration.point_in_time_recovery_enabled
        is set to true. Defaults to ZONAL.
    collation : str, default is Undefined, optional
        The name of server instance collation.
    connectionPoolConfig : [SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsConnectionPoolConfigItems0], default is Undefined, optional
        connection pool config
    connectorEnforcement : str, default is Undefined, optional
        Control the enforcement of Cloud SQL Auth Proxy or Cloud SQL connectors for all the connections, can be REQUIRED or NOT_REQUIRED. If enabled, all the direct connections are rejected.
    databaseFlags : [SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsDatabaseFlagsItems0], default is Undefined, optional
        database flags
    deletionProtectionEnabled : bool, default is Undefined, optional
        .
    diskAutoresize : bool, default is Undefined, optional
        Enables auto-resizing of the storage size. Defaults to true. To avoid this, ensure that lifecycle.ignore_changes is applied to disk_size.
    diskAutoresizeLimit : float, default is Undefined, optional
        The maximum size to which storage capacity can be automatically increased. The default value is 0, which specifies that there is no limit.
    diskSize : float, default is Undefined, optional
        The size of data disk, in GB. Size of a running instance cannot be reduced but can be increased. The minimum value is 10GB for PD_SSD, PD_HDD and 20GB for HYPERDISK_BALANCED. Note that this value will override the resizing from disk_autoresize if that feature is enabled. To avoid this, set lifecycle.ignore_changes on this field.
    diskType : str, default is Undefined, optional
        The type of data disk: PD_SSD, PD_HDD, or HYPERDISK_BALANCED. Defaults to PD_SSD. HYPERDISK_BALANCED is preview.
    edition : str, default is Undefined, optional
        The edition of the instance, can be ENTERPRISE or ENTERPRISE_PLUS.
    enableDataplexIntegration : bool, default is Undefined, optional
        Enables Cloud SQL instance integration with Dataplex. MySQL, Postgres and SQL Server instances are supported for this feature. Defaults to false.
    enableGoogleMlIntegration : bool, default is Undefined, optional
        Enables Cloud SQL instances to connect to Vertex AI and pass requests for real-time predictions and insights. Defaults to false.
    pricingPlan : str, default is Undefined, optional
        Pricing plan for this instance, can only be PER_USE.
    retainBackupsOnDelete : bool, default is Undefined, optional
        When this parameter is set to true, Cloud SQL retains backups of the instance even after the instance is deleted. The ON_DEMAND backup will be retained until customer deletes the backup or the project. The AUTOMATED backup will be retained based on the backups retention setting.
    tier : str, default is Undefined, optional
        The machine type to use. See tiers
        for more details and supported versions. Postgres supports only shared-core machine types,
        and custom machine types such as db-custom-2-13312. See the Custom Machine Type Documentation to learn about specifying custom machine types.
    timeZone : str, default is Undefined, optional
        The time_zone to be used by the database engine (supported only for SQL Server), in SQL Server timezone format.
    userLabels : {str:str}, default is Undefined, optional
        A set of key/value user label pairs to assign to the instance.
    version : float, default is Undefined, optional
        Used to make sure changes to the settings block are
        atomic.
    activeDirectoryConfig : SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsActiveDirectoryConfig, default is Undefined, optional
        active directory config
    advancedMachineFeatures : SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsAdvancedMachineFeatures, default is Undefined, optional
        advanced machine features
    backupConfiguration : SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsBackupConfiguration, default is Undefined, optional
        backup configuration
    dataCacheConfig : SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsDataCacheConfig, default is Undefined, optional
        data cache config
    denyMaintenancePeriod : SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsDenyMaintenancePeriod, default is Undefined, optional
        deny maintenance period
    insightsConfig : SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsInsightsConfig, default is Undefined, optional
        insights config
    ipConfiguration : SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsIPConfiguration, default is Undefined, optional
        ip configuration
    locationPreference : SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsLocationPreference, default is Undefined, optional
        location preference
    maintenanceWindow : SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsMaintenanceWindow, default is Undefined, optional
        maintenance window
    passwordValidationPolicy : SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsPasswordValidationPolicy, default is Undefined, optional
        password validation policy
    sqlServerAuditConfig : SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsSQLServerAuditConfig, default is Undefined, optional
        sql server audit config
    """


    activationPolicy?: str

    availabilityType?: str

    collation?: str

    connectionPoolConfig?: [SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsConnectionPoolConfigItems0]

    connectorEnforcement?: str

    databaseFlags?: [SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsDatabaseFlagsItems0]

    deletionProtectionEnabled?: bool

    diskAutoresize?: bool

    diskAutoresizeLimit?: float

    diskSize?: float

    diskType?: str

    edition?: str

    enableDataplexIntegration?: bool

    enableGoogleMlIntegration?: bool

    pricingPlan?: str

    retainBackupsOnDelete?: bool

    tier?: str

    timeZone?: str

    userLabels?: {str:str}

    version?: float

    activeDirectoryConfig?: SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsActiveDirectoryConfig

    advancedMachineFeatures?: SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsAdvancedMachineFeatures

    backupConfiguration?: SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsBackupConfiguration

    dataCacheConfig?: SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsDataCacheConfig

    denyMaintenancePeriod?: SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsDenyMaintenancePeriod

    insightsConfig?: SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsInsightsConfig

    ipConfiguration?: SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsIPConfiguration

    locationPreference?: SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsLocationPreference

    maintenanceWindow?: SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsMaintenanceWindow

    passwordValidationPolicy?: SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsPasswordValidationPolicy

    sqlServerAuditConfig?: SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsSQLServerAuditConfig


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsActiveDirectoryConfig:
    r"""
    SQL gcpm upbound io v1beta1 database instance status at provider settings active directory config

    Attributes
    ----------
    domain : str, default is Undefined, optional
        The domain name for the active directory (e.g., mydomain.com).
        Can only be used with SQL Server.
    """


    domain?: str


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsAdvancedMachineFeatures:
    r"""
    SQL gcpm upbound io v1beta1 database instance status at provider settings advanced machine features

    Attributes
    ----------
    threadsPerCore : float, default is Undefined, optional
        The number of threads per core. The value of this flag can be 1 or 2. To disable SMT, set this flag to 1. Only available in Cloud SQL for SQL Server instances. See smt for more details.
    """


    threadsPerCore?: float


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsBackupConfiguration:
    r"""
    SQL gcpm upbound io v1beta1 database instance status at provider settings backup configuration

    Attributes
    ----------
    binaryLogEnabled : bool, default is Undefined, optional
        True if binary logging is enabled.
        Can only be used with MySQL.
    enabled : bool, default is Undefined, optional
        True if backup configuration is enabled.
    location : str, default is Undefined, optional
        The region where the backup will be stored
    pointInTimeRecoveryEnabled : bool, default is Undefined, optional
        True if Point-in-time recovery is enabled. Will restart database if enabled after instance creation. Valid only for PostgreSQL and SQL Server instances. Enabled by default for PostgreSQL Enterprise Plus and SQL Server Enterprise Plus instances.
    startTime : str, default is Undefined, optional
        HH:MM format time indicating when backup
        configuration starts.
    transactionLogRetentionDays : float, default is Undefined, optional
        The number of days of transaction logs we retain for point in time restore, from 1-7. For PostgreSQL Enterprise Plus and SQL Server Enterprise Plus instances, the number of days of retained transaction logs can be set from 1 to 35.
    backupRetentionSettings : SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsBackupConfigurationBackupRetentionSettings, default is Undefined, optional
        backup retention settings
    """


    binaryLogEnabled?: bool

    enabled?: bool

    location?: str

    pointInTimeRecoveryEnabled?: bool

    startTime?: str

    transactionLogRetentionDays?: float

    backupRetentionSettings?: SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsBackupConfigurationBackupRetentionSettings


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsBackupConfigurationBackupRetentionSettings:
    r"""
    Backup retention settings. The configuration is detailed below.

    Attributes
    ----------
    retainedBackups : float, default is Undefined, optional
        Depending on the value of retention_unit, this is used to determine if a backup needs to be deleted. If retention_unit
        is 'COUNT', we will retain this many backups.
    retentionUnit : str, default is Undefined, optional
        The unit that 'retained_backups' represents. Defaults to COUNT.
    """


    retainedBackups?: float

    retentionUnit?: str


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsConnectionPoolConfigItems0:
    r"""
    SQL gcpm upbound io v1beta1 database instance status at provider settings connection pool config items0

    Attributes
    ----------
    connectionPoolingEnabled : bool, default is Undefined, optional
        :  True if the manager connection pooling configuration is enabled.
    flags : [SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsConnectionPoolConfigItems0FlagsItems0], default is Undefined, optional
        flags
    """


    connectionPoolingEnabled?: bool

    flags?: [SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsConnectionPoolConfigItems0FlagsItems0]


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsConnectionPoolConfigItems0FlagsItems0:
    r"""
    SQL gcpm upbound io v1beta1 database instance status at provider settings connection pool config items0 flags items0

    Attributes
    ----------
    name : str, default is Undefined, optional
        A name for this whitelist entry.
    value : str, default is Undefined, optional
        A CIDR notation IPv4 or IPv6 address that is allowed to
        access this instance. Must be set even if other two attributes are not for
        the whitelist to become active.
    """


    name?: str

    value?: str


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsDataCacheConfig:
    r"""
    SQL gcpm upbound io v1beta1 database instance status at provider settings data cache config

    Attributes
    ----------
    dataCacheEnabled : bool, default is Undefined, optional
        Whether data cache is enabled for the instance. Defaults to false. Can be used with MYSQL and PostgreSQL only.
    """


    dataCacheEnabled?: bool


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsDatabaseFlagsItems0:
    r"""
    SQL gcpm upbound io v1beta1 database instance status at provider settings database flags items0

    Attributes
    ----------
    name : str, default is Undefined, optional
        A name for this whitelist entry.
    value : str, default is Undefined, optional
        A CIDR notation IPv4 or IPv6 address that is allowed to
        access this instance. Must be set even if other two attributes are not for
        the whitelist to become active.
    """


    name?: str

    value?: str


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsDenyMaintenancePeriod:
    r"""
    SQL gcpm upbound io v1beta1 database instance status at provider settings deny maintenance period

    Attributes
    ----------
    endDate : str, default is Undefined, optional
        "deny maintenance period" end date. If the year of the end date is empty, the year of the start date also must be empty. In this case, it means the no maintenance interval recurs every year. The date is in format yyyy-m-dd (the month is without leading zeros)i.e., 2020-1-01, or 2020-11-01, or mm-dd, i.e., 11-01
    startDate : str, default is Undefined, optional
        "deny maintenance period" start date. If the year of the start date is empty, the year of the end date also must be empty. In this case, it means the deny maintenance period recurs every year. The date is in format yyyy-m-dd (the month is without leading zeros)i.e., 2020-1-01, or 2020-11-01, or mm-dd, i.e., 11-01
    time : str, default is Undefined, optional
        Time in UTC when the "deny maintenance period" starts on startDate and ends on endDate. The time is in format: HH:mm:SS, i.e., 00:00:00
    """


    endDate?: str

    startDate?: str

    time?: str


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsIPConfiguration:
    r"""
    SQL gcpm upbound io v1beta1 database instance status at provider settings IP configuration

    Attributes
    ----------
    allocatedIpRange : str, default is Undefined, optional
        The name of the allocated ip range for the private ip CloudSQL instance. For example: "google-managed-services-default". If set, the instance ip will be created in the allocated range. The range name must comply with RFC 1035. Specifically, the name must be 1-63 characters long and match the regular expression a-z?.
    authorizedNetworks : [SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsIPConfigurationAuthorizedNetworksItems0], default is Undefined, optional
        authorized networks
    customSubjectAlternativeNames : [str], default is Undefined, optional
        The custom subject alternative names for an instance with CUSTOMER_MANAGED_CAS_CA as the server_ca_mode.
    enablePrivatePathForGoogleCloudServices : bool, default is Undefined, optional
        Whether Google Cloud services such as BigQuery are allowed to access data in this Cloud SQL instance over a private IP connection. SQLSERVER database type is not supported.
    ipv4Enabled : bool, default is Undefined, optional
        Whether this Cloud SQL instance should be assigned
        a public IPV4 address. At least ipv4_enabled must be enabled or a
        private_network must be configured.
    privateNetwork : str, default is Undefined, optional
        The VPC network from which the Cloud SQL
        instance is accessible for private IP. For example, projects/myProject/global/networks/default.
        Specifying a network enables private IP.
        At least ipv4_enabled must be enabled or a private_network must be configured.
        This setting can be updated, but it cannot be removed after it is set.
    pscConfig : [SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsIPConfigurationPscConfigItems0], default is Undefined, optional
        psc config
    serverCaMode : str, default is Undefined, optional
        Specify how the server certificate's Certificate Authority is hosted. Supported values are GOOGLE_MANAGED_INTERNAL_CA and GOOGLE_MANAGED_CAS_CA.
    serverCaPool : str, default is Undefined, optional
        The resource name of the server CA pool for an instance with CUSTOMER_MANAGED_CAS_CA as the server_ca_mode.
    sslMode : str, default is Undefined, optional
        Specify how SSL connection should be enforced in DB connections. Supported values are ALLOW_UNENCRYPTED_AND_ENCRYPTED, ENCRYPTED_ONLY, and TRUSTED_CLIENT_CERTIFICATE_REQUIRED (not supported for SQL Server). See API reference doc for details.
    """


    allocatedIpRange?: str

    authorizedNetworks?: [SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsIPConfigurationAuthorizedNetworksItems0]

    customSubjectAlternativeNames?: [str]

    enablePrivatePathForGoogleCloudServices?: bool

    ipv4Enabled?: bool

    privateNetwork?: str

    pscConfig?: [SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsIPConfigurationPscConfigItems0]

    serverCaMode?: str

    serverCaPool?: str

    sslMode?: str


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsIPConfigurationAuthorizedNetworksItems0:
    r"""
    SQL gcpm upbound io v1beta1 database instance status at provider settings IP configuration authorized networks items0

    Attributes
    ----------
    expirationTime : str, default is Undefined, optional
        The RFC 3339
        formatted date time string indicating when this whitelist expires.
    name : str, default is Undefined, optional
        A name for this whitelist entry.
    value : str, default is Undefined, optional
        A CIDR notation IPv4 or IPv6 address that is allowed to
        access this instance. Must be set even if other two attributes are not for
        the whitelist to become active.
    """


    expirationTime?: str

    name?: str

    value?: str


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsIPConfigurationPscConfigItems0:
    r"""
    SQL gcpm upbound io v1beta1 database instance status at provider settings IP configuration psc config items0

    Attributes
    ----------
    allowedConsumerProjects : [str], default is Undefined, optional
        List of consumer projects that are allow-listed for PSC connections to this instance. This instance can be connected to with PSC from any network in these projects. Each consumer project in this list may be represented by a project number (numeric) or by a project id (alphanumeric).
    pscAutoConnections : [SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsIPConfigurationPscConfigItems0PscAutoConnectionsItems0], default is Undefined, optional
        A comma-separated list of networks or a comma-separated list of network-project pairs. Each project in this list is represented by a project number (numeric) or by a project ID (alphanumeric). This allows Private Service Connect connections to be created automatically for the specified networks.
    pscEnabled : bool, default is Undefined, optional
        Whether PSC connectivity is enabled for this instance.
    """


    allowedConsumerProjects?: [str]

    pscAutoConnections?: [SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsIPConfigurationPscConfigItems0PscAutoConnectionsItems0]

    pscEnabled?: bool


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsIPConfigurationPscConfigItems0PscAutoConnectionsItems0:
    r"""
    SQL gcpm upbound io v1beta1 database instance status at provider settings IP configuration psc config items0 psc auto connections items0

    Attributes
    ----------
    consumerNetwork : str, default is Undefined, optional
        "The consumer network of this consumer endpoint. This must be a resource path that includes both the host project and the network name. For example, projects/project1/global/networks/network1. The consumer host project of this network might be different from the consumer service project."
    consumerServiceProjectId : str, default is Undefined, optional
        The project ID of consumer service project of this consumer endpoint.
    """


    consumerNetwork?: str

    consumerServiceProjectId?: str


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsInsightsConfig:
    r"""
    SQL gcpm upbound io v1beta1 database instance status at provider settings insights config

    Attributes
    ----------
    queryInsightsEnabled : bool, default is Undefined, optional
        True if Query Insights feature is enabled.
    queryPlansPerMinute : float, default is Undefined, optional
        Number of query execution plans captured by Insights per minute for all queries combined. Between 0 and 20. Default to 5.
    queryStringLength : float, default is Undefined, optional
        Maximum query length stored in bytes. Between 256 and 4500. Default to 1024. Higher query lengths are more useful for analytical queries, but they also require more memory. Changing the query length requires you to restart the instance. You can still add tags to queries that exceed the length limit.
    recordApplicationTags : bool, default is Undefined, optional
        True if Query Insights will record application tags from query when enabled.
    recordClientAddress : bool, default is Undefined, optional
        True if Query Insights will record client address when enabled.
    """


    queryInsightsEnabled?: bool

    queryPlansPerMinute?: float

    queryStringLength?: float

    recordApplicationTags?: bool

    recordClientAddress?: bool


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsLocationPreference:
    r"""
    SQL gcpm upbound io v1beta1 database instance status at provider settings location preference

    Attributes
    ----------
    followGaeApplication : str, default is Undefined, optional
        A GAE application whose zone to remain
        in. Must be in the same region as this instance.
    secondaryZone : str, default is Undefined, optional
        The preferred Compute Engine zone for the secondary/failover.
    zone : str, default is Undefined, optional
        The preferred compute engine
        zone.
    """


    followGaeApplication?: str

    secondaryZone?: str

    zone?: str


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsMaintenanceWindow:
    r"""
    SQL gcpm upbound io v1beta1 database instance status at provider settings maintenance window

    Attributes
    ----------
    day : float, default is Undefined, optional
        Day of week (1-7), starting on Monday
    hour : float, default is Undefined, optional
        Hour of day (0-23), ignored if day not set
    updateTrack : str, default is Undefined, optional
        Receive updates after one week (canary) or after two weeks (stable) or after five weeks (week5) of notification.
    """


    day?: float

    hour?: float

    updateTrack?: str


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsPasswordValidationPolicy:
    r"""
    SQL gcpm upbound io v1beta1 database instance status at provider settings password validation policy

    Attributes
    ----------
    complexity : str, default is Undefined, optional
        Checks if the password is a combination of lowercase, uppercase, numeric, and non-alphanumeric characters.
    disallowUsernameSubstring : bool, default is Undefined, optional
        Prevents the use of the username in the password.
    enablePasswordPolicy : bool, default is Undefined, optional
        Enables or disable the password validation policy.
    minLength : float, default is Undefined, optional
        Specifies the minimum number of characters that the password must have.
    passwordChangeInterval : str, default is Undefined, optional
        Specifies the minimum duration after which you can change the password.
    reuseInterval : float, default is Undefined, optional
        Specifies the number of previous passwords that you can't reuse.
    """


    complexity?: str

    disallowUsernameSubstring?: bool

    enablePasswordPolicy?: bool

    minLength?: float

    passwordChangeInterval?: str

    reuseInterval?: float


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusAtProviderSettingsSQLServerAuditConfig:
    r"""
    SQL gcpm upbound io v1beta1 database instance status at provider settings SQL server audit config

    Attributes
    ----------
    bucket : str, default is Undefined, optional
        The name of the destination bucket (e.g., gs://mybucket).
    retentionInterval : str, default is Undefined, optional
        How long to keep generated audit files. A duration in seconds with up to nine fractional digits, terminated by 's'. Example: "3.5s".
    uploadInterval : str, default is Undefined, optional
        How often to upload generated audit files. A duration in seconds with up to nine fractional digits, terminated by 's'. Example: "3.5s".
    """


    bucket?: str

    retentionInterval?: str

    uploadInterval?: str


schema SQLGcpmUpboundIoV1beta1DatabaseInstanceStatusConditionsItems0:
    r"""
    A Condition that may apply to a resource.

    Attributes
    ----------
    lastTransitionTime : str, default is Undefined, required
        LastTransitionTime is the last time this condition transitioned from one
        status to another.
    message : str, default is Undefined, optional
        A Message containing details about this condition's last transition from
        one status to another, if any.
    observedGeneration : int, default is Undefined, optional
        ObservedGeneration represents the .metadata.generation that the condition was set based upon.
        For instance, if .metadata.generation is currently 12, but the .status.conditions[x].observedGeneration is 9, the condition is out of date
        with respect to the current state of the instance.
    reason : str, default is Undefined, required
        A Reason for this condition's last transition from one status to another.
    status : str, default is Undefined, required
        Status of this condition; is it currently True, False, or Unknown?
    $type : str, default is Undefined, required
        Type of this condition. At most one of each condition type may apply to
        a resource at any point in time.
    """


    lastTransitionTime: str

    message?: str

    observedGeneration?: int

    reason: str

    status: str

    $type: str






schema User:
    r"""
    User is the Schema for the Users API. Creates a new SQL user in Google Cloud SQL.

    Attributes
    ----------
    apiVersion : str, default is "sql.gcp.m.upbound.io/v1beta1", required
        APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
    kind : str, default is "User", required
        Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
    metadata : v1.ObjectMeta, default is Undefined, optional
        metadata
    spec : SQLGcpmUpboundIoV1beta1UserSpec, default is Undefined, required
        spec
    status : SQLGcpmUpboundIoV1beta1UserStatus, default is Undefined, optional
        status
    """


    apiVersion: "sql.gcp.m.upbound.io/v1beta1" = "sql.gcp.m.upbound.io/v1beta1"

    kind: "User" = "User"

    metadata?: v1.ObjectMeta

    spec: SQLGcpmUpboundIoV1beta1UserSpec

    status?: SQLGcpmUpboundIoV1beta1UserStatus


schema SQLGcpmUpboundIoV1beta1UserSpec:
    r"""
    UserSpec defines the desired state of User

    Attributes
    ----------
    managementPolicies : [str], default is ["*"], optional
        THIS IS A BETA FIELD. It is on by default but can be opted out
        through a Crossplane feature flag.
        ManagementPolicies specify the array of actions Crossplane is allowed to
        take on the managed and external resources.
        See the design doc for more information: https://github.com/crossplane/crossplane/blob/499895a25d1a1a0ba1604944ef98ac7a1a71f197/design/design-doc-observe-only-resources.md?plain=1#L223
        and this one: https://github.com/crossplane/crossplane/blob/444267e84783136daa93568b364a5f01228cacbe/design/one-pager-ignore-changes.md
    forProvider : SQLGcpmUpboundIoV1beta1UserSpecForProvider, default is Undefined, required
        for provider
    initProvider : SQLGcpmUpboundIoV1beta1UserSpecInitProvider, default is Undefined, optional
        init provider
    providerConfigRef : SQLGcpmUpboundIoV1beta1UserSpecProviderConfigRef, default is Undefined, optional
        provider config ref
    writeConnectionSecretToRef : SQLGcpmUpboundIoV1beta1UserSpecWriteConnectionSecretToRef, default is Undefined, optional
        write connection secret to ref
    """


    managementPolicies?: [str] = ["*"]

    forProvider: SQLGcpmUpboundIoV1beta1UserSpecForProvider

    initProvider?: SQLGcpmUpboundIoV1beta1UserSpecInitProvider

    providerConfigRef?: SQLGcpmUpboundIoV1beta1UserSpecProviderConfigRef

    writeConnectionSecretToRef?: SQLGcpmUpboundIoV1beta1UserSpecWriteConnectionSecretToRef


schema SQLGcpmUpboundIoV1beta1UserSpecForProvider:
    r"""
    SQL gcpm upbound io v1beta1 user spec for provider

    Attributes
    ----------
    deletionPolicy : str, default is Undefined, optional
        The deletion policy for the user.
        Setting ABANDON allows the resource to be abandoned rather than deleted. This is useful
        for Postgres, where users cannot be deleted from the API if they have been granted SQL roles.
    host : str, default is Undefined, optional
        The host the user can connect from. This is only supported
        for BUILT_IN users in MySQL instances. Don't set this field for PostgreSQL and SQL Server instances.
        Can be an IP address. Changing this forces a new resource to be created.
    instance : str, default is Undefined, optional
        The name of the Cloud SQL instance. Changing this
        forces a new resource to be created.
    passwordWo : str, default is Undefined, optional
        The password for the user. Can be updated. For Postgres
        instances this is a Required field, unless type is set to either CLOUD_IAM_USER
        or CLOUD_IAM_SERVICE_ACCOUNT. Don't set this field for CLOUD_IAM_USER
        and CLOUD_IAM_SERVICE_ACCOUNT user types for any Cloud SQL instance.
        Note: This property is write-only and will not be read from the API.
    passwordWoVersion : float, default is Undefined, optional
        The version of the password_wo. For more info see updating write-only attributes.
    project : str, default is Undefined, optional
        The ID of the project in which the resource belongs. If it
        is not provided, the provider project is used.
    $type : str, default is Undefined, optional
        The user type. It determines the method to authenticate the
        user during login. The default is the database's built-in user type. Flags
        include "BUILT_IN", "CLOUD_IAM_USER", "CLOUD_IAM_SERVICE_ACCOUNT", "CLOUD_IAM_GROUP",
        "CLOUD_IAM_GROUP_USER" and "CLOUD_IAM_GROUP_SERVICE_ACCOUNT" for
        Postgres
        and MySQL.
    instanceRef : SQLGcpmUpboundIoV1beta1UserSpecForProviderInstanceRef, default is Undefined, optional
        instance ref
    instanceSelector : SQLGcpmUpboundIoV1beta1UserSpecForProviderInstanceSelector, default is Undefined, optional
        instance selector
    passwordPolicy : SQLGcpmUpboundIoV1beta1UserSpecForProviderPasswordPolicy, default is Undefined, optional
        password policy
    passwordSecretRef : SQLGcpmUpboundIoV1beta1UserSpecForProviderPasswordSecretRef, default is Undefined, optional
        password secret ref
    """


    deletionPolicy?: str

    host?: str

    instance?: str

    passwordWo?: str

    passwordWoVersion?: float

    project?: str

    $type?: str

    instanceRef?: SQLGcpmUpboundIoV1beta1UserSpecForProviderInstanceRef

    instanceSelector?: SQLGcpmUpboundIoV1beta1UserSpecForProviderInstanceSelector

    passwordPolicy?: SQLGcpmUpboundIoV1beta1UserSpecForProviderPasswordPolicy

    passwordSecretRef?: SQLGcpmUpboundIoV1beta1UserSpecForProviderPasswordSecretRef


schema SQLGcpmUpboundIoV1beta1UserSpecForProviderInstanceRef:
    r"""
    Reference to a DatabaseInstance in sql to populate instance.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : SQLGcpmUpboundIoV1beta1UserSpecForProviderInstanceRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: SQLGcpmUpboundIoV1beta1UserSpecForProviderInstanceRefPolicy


schema SQLGcpmUpboundIoV1beta1UserSpecForProviderInstanceRefPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"


schema SQLGcpmUpboundIoV1beta1UserSpecForProviderInstanceSelector:
    r"""
    Selector for a DatabaseInstance in sql to populate instance.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : SQLGcpmUpboundIoV1beta1UserSpecForProviderInstanceSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: SQLGcpmUpboundIoV1beta1UserSpecForProviderInstanceSelectorPolicy


schema SQLGcpmUpboundIoV1beta1UserSpecForProviderInstanceSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"


schema SQLGcpmUpboundIoV1beta1UserSpecForProviderPasswordPolicy:
    r"""
    SQL gcpm upbound io v1beta1 user spec for provider password policy

    Attributes
    ----------
    allowedFailedAttempts : float, default is Undefined, optional
        Number of failed attempts allowed before the user get locked.
    enableFailedAttemptsCheck : bool, default is Undefined, optional
        If true, the check that will lock user after too many failed login attempts will be enabled.
    enablePasswordVerification : bool, default is Undefined, optional
        If true, the user must specify the current password before changing the password. This flag is supported only for MySQL.
    passwordExpirationDuration : str, default is Undefined, optional
        Password expiration duration with one week grace period.
    """


    allowedFailedAttempts?: float

    enableFailedAttemptsCheck?: bool

    enablePasswordVerification?: bool

    passwordExpirationDuration?: str


schema SQLGcpmUpboundIoV1beta1UserSpecForProviderPasswordSecretRef:
    r"""
    The password for the user. Can be updated. For Postgres
    instances this is a Required field, unless type is set to either CLOUD_IAM_USER
    or CLOUD_IAM_SERVICE_ACCOUNT. Don't set this field for CLOUD_IAM_USER
    and CLOUD_IAM_SERVICE_ACCOUNT user types for any Cloud SQL instance.

    Attributes
    ----------
    key : str, default is Undefined, required
        key
    name : str, default is Undefined, required
        Name of the secret.
    """


    key: str

    name: str


schema SQLGcpmUpboundIoV1beta1UserSpecInitProvider:
    r"""
    THIS IS A BETA FIELD. It will be honored
    unless the Management Policies feature flag is disabled.
    InitProvider holds the same fields as ForProvider, with the exception
    of Identifier and other resource reference fields. The fields that are
    in InitProvider are merged into ForProvider when the resource is created.
    The same fields are also added to the terraform ignore_changes hook, to
    avoid updating them after creation. This is useful for fields that are
    required on creation, but we do not desire to update them after creation,
    for example because of an external controller is managing them, like an
    autoscaler.

    Attributes
    ----------
    deletionPolicy : str, default is Undefined, optional
        The deletion policy for the user.
        Setting ABANDON allows the resource to be abandoned rather than deleted. This is useful
        for Postgres, where users cannot be deleted from the API if they have been granted SQL roles.
    host : str, default is Undefined, optional
        The host the user can connect from. This is only supported
        for BUILT_IN users in MySQL instances. Don't set this field for PostgreSQL and SQL Server instances.
        Can be an IP address. Changing this forces a new resource to be created.
    instance : str, default is Undefined, optional
        The name of the Cloud SQL instance. Changing this
        forces a new resource to be created.
    passwordWo : str, default is Undefined, optional
        The password for the user. Can be updated. For Postgres
        instances this is a Required field, unless type is set to either CLOUD_IAM_USER
        or CLOUD_IAM_SERVICE_ACCOUNT. Don't set this field for CLOUD_IAM_USER
        and CLOUD_IAM_SERVICE_ACCOUNT user types for any Cloud SQL instance.
        Note: This property is write-only and will not be read from the API.
    passwordWoVersion : float, default is Undefined, optional
        The version of the password_wo. For more info see updating write-only attributes.
    project : str, default is Undefined, optional
        The ID of the project in which the resource belongs. If it
        is not provided, the provider project is used.
    $type : str, default is Undefined, optional
        The user type. It determines the method to authenticate the
        user during login. The default is the database's built-in user type. Flags
        include "BUILT_IN", "CLOUD_IAM_USER", "CLOUD_IAM_SERVICE_ACCOUNT", "CLOUD_IAM_GROUP",
        "CLOUD_IAM_GROUP_USER" and "CLOUD_IAM_GROUP_SERVICE_ACCOUNT" for
        Postgres
        and MySQL.
    instanceRef : SQLGcpmUpboundIoV1beta1UserSpecInitProviderInstanceRef, default is Undefined, optional
        instance ref
    instanceSelector : SQLGcpmUpboundIoV1beta1UserSpecInitProviderInstanceSelector, default is Undefined, optional
        instance selector
    passwordPolicy : SQLGcpmUpboundIoV1beta1UserSpecInitProviderPasswordPolicy, default is Undefined, optional
        password policy
    passwordSecretRef : SQLGcpmUpboundIoV1beta1UserSpecInitProviderPasswordSecretRef, default is Undefined, optional
        password secret ref
    """


    deletionPolicy?: str

    host?: str

    instance?: str

    passwordWo?: str

    passwordWoVersion?: float

    project?: str

    $type?: str

    instanceRef?: SQLGcpmUpboundIoV1beta1UserSpecInitProviderInstanceRef

    instanceSelector?: SQLGcpmUpboundIoV1beta1UserSpecInitProviderInstanceSelector

    passwordPolicy?: SQLGcpmUpboundIoV1beta1UserSpecInitProviderPasswordPolicy

    passwordSecretRef?: SQLGcpmUpboundIoV1beta1UserSpecInitProviderPasswordSecretRef


schema SQLGcpmUpboundIoV1beta1UserSpecInitProviderInstanceRef:
    r"""
    Reference to a DatabaseInstance in sql to populate instance.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : SQLGcpmUpboundIoV1beta1UserSpecInitProviderInstanceRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: SQLGcpmUpboundIoV1beta1UserSpecInitProviderInstanceRefPolicy


schema SQLGcpmUpboundIoV1beta1UserSpecInitProviderInstanceRefPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"


schema SQLGcpmUpboundIoV1beta1UserSpecInitProviderInstanceSelector:
    r"""
    Selector for a DatabaseInstance in sql to populate instance.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : SQLGcpmUpboundIoV1beta1UserSpecInitProviderInstanceSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: SQLGcpmUpboundIoV1beta1UserSpecInitProviderInstanceSelectorPolicy


schema SQLGcpmUpboundIoV1beta1UserSpecInitProviderInstanceSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"


schema SQLGcpmUpboundIoV1beta1UserSpecInitProviderPasswordPolicy:
    r"""
    SQL gcpm upbound io v1beta1 user spec init provider password policy

    Attributes
    ----------
    allowedFailedAttempts : float, default is Undefined, optional
        Number of failed attempts allowed before the user get locked.
    enableFailedAttemptsCheck : bool, default is Undefined, optional
        If true, the check that will lock user after too many failed login attempts will be enabled.
    enablePasswordVerification : bool, default is Undefined, optional
        If true, the user must specify the current password before changing the password. This flag is supported only for MySQL.
    passwordExpirationDuration : str, default is Undefined, optional
        Password expiration duration with one week grace period.
    """


    allowedFailedAttempts?: float

    enableFailedAttemptsCheck?: bool

    enablePasswordVerification?: bool

    passwordExpirationDuration?: str


schema SQLGcpmUpboundIoV1beta1UserSpecInitProviderPasswordSecretRef:
    r"""
    The password for the user. Can be updated. For Postgres
    instances this is a Required field, unless type is set to either CLOUD_IAM_USER
    or CLOUD_IAM_SERVICE_ACCOUNT. Don't set this field for CLOUD_IAM_USER
    and CLOUD_IAM_SERVICE_ACCOUNT user types for any Cloud SQL instance.

    Attributes
    ----------
    key : str, default is Undefined, required
        key
    name : str, default is Undefined, required
        Name of the secret.
    """


    key: str

    name: str


schema SQLGcpmUpboundIoV1beta1UserSpecProviderConfigRef:
    r"""
    ProviderConfigReference specifies how the provider that will be used to
    create, observe, update, and delete this managed resource should be
    configured.

    Attributes
    ----------
    kind : str, default is Undefined, required
        Kind of the referenced object.
    name : str, default is Undefined, required
        Name of the referenced object.
    """


    kind: str

    name: str


schema SQLGcpmUpboundIoV1beta1UserSpecWriteConnectionSecretToRef:
    r"""
    WriteConnectionSecretToReference specifies the namespace and name of a
    Secret to which any connection details for this managed resource should
    be written. Connection details frequently include the endpoint, username,
    and password required to connect to the managed resource.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the secret.
    """


    name: str


schema SQLGcpmUpboundIoV1beta1UserStatus:
    r"""
    UserStatus defines the observed state of User.

    Attributes
    ----------
    conditions : [SQLGcpmUpboundIoV1beta1UserStatusConditionsItems0], default is Undefined, optional
        Conditions of the resource.
    observedGeneration : int, default is Undefined, optional
        ObservedGeneration is the latest metadata.generation
        which resulted in either a ready state, or stalled due to error
        it can not recover from without human intervention.
    atProvider : SQLGcpmUpboundIoV1beta1UserStatusAtProvider, default is Undefined, optional
        at provider
    """


    conditions?: [SQLGcpmUpboundIoV1beta1UserStatusConditionsItems0]

    observedGeneration?: int

    atProvider?: SQLGcpmUpboundIoV1beta1UserStatusAtProvider


schema SQLGcpmUpboundIoV1beta1UserStatusAtProvider:
    r"""
    SQL gcpm upbound io v1beta1 user status at provider

    Attributes
    ----------
    deletionPolicy : str, default is Undefined, optional
        The deletion policy for the user.
        Setting ABANDON allows the resource to be abandoned rather than deleted. This is useful
        for Postgres, where users cannot be deleted from the API if they have been granted SQL roles.
    host : str, default is Undefined, optional
        The host the user can connect from. This is only supported
        for BUILT_IN users in MySQL instances. Don't set this field for PostgreSQL and SQL Server instances.
        Can be an IP address. Changing this forces a new resource to be created.
    id : str, default is Undefined, optional
        id
    instance : str, default is Undefined, optional
        The name of the Cloud SQL instance. Changing this
        forces a new resource to be created.
    passwordWo : str, default is Undefined, optional
        The password for the user. Can be updated. For Postgres
        instances this is a Required field, unless type is set to either CLOUD_IAM_USER
        or CLOUD_IAM_SERVICE_ACCOUNT. Don't set this field for CLOUD_IAM_USER
        and CLOUD_IAM_SERVICE_ACCOUNT user types for any Cloud SQL instance.
        Note: This property is write-only and will not be read from the API.
    passwordWoVersion : float, default is Undefined, optional
        The version of the password_wo. For more info see updating write-only attributes.
    project : str, default is Undefined, optional
        The ID of the project in which the resource belongs. If it
        is not provided, the provider project is used.
    sqlServerUserDetails : [SQLGcpmUpboundIoV1beta1UserStatusAtProviderSQLServerUserDetailsItems0], default is Undefined, optional
        sql server user details
    $type : str, default is Undefined, optional
        The user type. It determines the method to authenticate the
        user during login. The default is the database's built-in user type. Flags
        include "BUILT_IN", "CLOUD_IAM_USER", "CLOUD_IAM_SERVICE_ACCOUNT", "CLOUD_IAM_GROUP",
        "CLOUD_IAM_GROUP_USER" and "CLOUD_IAM_GROUP_SERVICE_ACCOUNT" for
        Postgres
        and MySQL.
    passwordPolicy : SQLGcpmUpboundIoV1beta1UserStatusAtProviderPasswordPolicy, default is Undefined, optional
        password policy
    """


    deletionPolicy?: str

    host?: str

    id?: str

    instance?: str

    passwordWo?: str

    passwordWoVersion?: float

    project?: str

    sqlServerUserDetails?: [SQLGcpmUpboundIoV1beta1UserStatusAtProviderSQLServerUserDetailsItems0]

    $type?: str

    passwordPolicy?: SQLGcpmUpboundIoV1beta1UserStatusAtProviderPasswordPolicy


schema SQLGcpmUpboundIoV1beta1UserStatusAtProviderPasswordPolicy:
    r"""
    SQL gcpm upbound io v1beta1 user status at provider password policy

    Attributes
    ----------
    allowedFailedAttempts : float, default is Undefined, optional
        Number of failed attempts allowed before the user get locked.
    enableFailedAttemptsCheck : bool, default is Undefined, optional
        If true, the check that will lock user after too many failed login attempts will be enabled.
    enablePasswordVerification : bool, default is Undefined, optional
        If true, the user must specify the current password before changing the password. This flag is supported only for MySQL.
    passwordExpirationDuration : str, default is Undefined, optional
        Password expiration duration with one week grace period.
    status : [SQLGcpmUpboundIoV1beta1UserStatusAtProviderPasswordPolicyStatusItems0], default is Undefined, optional
        status
    """


    allowedFailedAttempts?: float

    enableFailedAttemptsCheck?: bool

    enablePasswordVerification?: bool

    passwordExpirationDuration?: str

    status?: [SQLGcpmUpboundIoV1beta1UserStatusAtProviderPasswordPolicyStatusItems0]


schema SQLGcpmUpboundIoV1beta1UserStatusAtProviderPasswordPolicyStatusItems0:
    r"""
    SQL gcpm upbound io v1beta1 user status at provider password policy status items0

    Attributes
    ----------
    locked : bool, default is Undefined, optional
        (read only) If true, user does not have login privileges.
    passwordExpirationTime : str, default is Undefined, optional
        (read only) Password expiration duration with one week grace period.
    """


    locked?: bool

    passwordExpirationTime?: str


schema SQLGcpmUpboundIoV1beta1UserStatusAtProviderSQLServerUserDetailsItems0:
    r"""
    SQL gcpm upbound io v1beta1 user status at provider SQL server user details items0

    Attributes
    ----------
    disabled : bool, default is Undefined, optional
        disabled
    serverRoles : [str], default is Undefined, optional
        server roles
    """


    disabled?: bool

    serverRoles?: [str]


schema SQLGcpmUpboundIoV1beta1UserStatusConditionsItems0:
    r"""
    A Condition that may apply to a resource.

    Attributes
    ----------
    lastTransitionTime : str, default is Undefined, required
        LastTransitionTime is the last time this condition transitioned from one
        status to another.
    message : str, default is Undefined, optional
        A Message containing details about this condition's last transition from
        one status to another, if any.
    observedGeneration : int, default is Undefined, optional
        ObservedGeneration represents the .metadata.generation that the condition was set based upon.
        For instance, if .metadata.generation is currently 12, but the .status.conditions[x].observedGeneration is 9, the condition is out of date
        with respect to the current state of the instance.
    reason : str, default is Undefined, required
        A Reason for this condition's last transition from one status to another.
    status : str, default is Undefined, required
        Status of this condition; is it currently True, False, or Unknown?
    $type : str, default is Undefined, required
        Type of this condition. At most one of each condition type may apply to
        a resource at any point in time.
    """


    lastTransitionTime: str

    message?: str

    observedGeneration?: int

    reason: str

    status: str

    $type: str






schema Bucket:
    r"""
    Bucket is the Schema for the Buckets API. Creates a new bucket in Google Cloud Storage.

    Attributes
    ----------
    apiVersion : str, default is "storage.gcp.m.upbound.io/v1beta1", required
        APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
    kind : str, default is "Bucket", required
        Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
    metadata : v1.ObjectMeta, default is Undefined, optional
        metadata
    spec : StorageGcpmUpboundIoV1beta1BucketSpec, default is Undefined, required
        spec
    status : StorageGcpmUpboundIoV1beta1BucketStatus, default is Undefined, optional
        status
    """


    apiVersion: "storage.gcp.m.upbound.io/v1beta1" = "storage.gcp.m.upbound.io/v1beta1"

    kind: "Bucket" = "Bucket"

    metadata?: v1.ObjectMeta

    spec: StorageGcpmUpboundIoV1beta1BucketSpec

    status?: StorageGcpmUpboundIoV1beta1BucketStatus


schema StorageGcpmUpboundIoV1beta1BucketSpec:
    r"""
    BucketSpec defines the desired state of Bucket

    Attributes
    ----------
    managementPolicies : [str], default is ["*"], optional
        THIS IS A BETA FIELD. It is on by default but can be opted out
        through a Crossplane feature flag.
        ManagementPolicies specify the array of actions Crossplane is allowed to
        take on the managed and external resources.
        See the design doc for more information: https://github.com/crossplane/crossplane/blob/499895a25d1a1a0ba1604944ef98ac7a1a71f197/design/design-doc-observe-only-resources.md?plain=1#L223
        and this one: https://github.com/crossplane/crossplane/blob/444267e84783136daa93568b364a5f01228cacbe/design/one-pager-ignore-changes.md
    forProvider : StorageGcpmUpboundIoV1beta1BucketSpecForProvider, default is Undefined, required
        for provider
    initProvider : StorageGcpmUpboundIoV1beta1BucketSpecInitProvider, default is Undefined, optional
        init provider
    providerConfigRef : StorageGcpmUpboundIoV1beta1BucketSpecProviderConfigRef, default is Undefined, optional
        provider config ref
    writeConnectionSecretToRef : StorageGcpmUpboundIoV1beta1BucketSpecWriteConnectionSecretToRef, default is Undefined, optional
        write connection secret to ref
    """


    managementPolicies?: [str] = ["*"]

    forProvider: StorageGcpmUpboundIoV1beta1BucketSpecForProvider

    initProvider?: StorageGcpmUpboundIoV1beta1BucketSpecInitProvider

    providerConfigRef?: StorageGcpmUpboundIoV1beta1BucketSpecProviderConfigRef

    writeConnectionSecretToRef?: StorageGcpmUpboundIoV1beta1BucketSpecWriteConnectionSecretToRef


schema StorageGcpmUpboundIoV1beta1BucketSpecForProvider:
    r"""
    storage gcpm upbound io v1beta1 bucket spec for provider

    Attributes
    ----------
    cors : [StorageGcpmUpboundIoV1beta1BucketSpecForProviderCorsItems0], default is Undefined, optional
        The bucket's Cross-Origin Resource Sharing (CORS) configuration. Multiple blocks of this type are permitted. Structure is documented below.
    defaultEventBasedHold : bool, default is Undefined, optional
        Whether or not to automatically apply an eventBasedHold to new objects added to the bucket.
    enableObjectRetention : bool, default is Undefined, optional
        Enables object retention on a storage bucket.
    forceDestroy : bool, default is Undefined, optional
        When deleting a bucket, this
        boolean option will delete all contained objects.
    labels : {str:str}, default is Undefined, optional
        A map of key/value label pairs to assign to the bucket.
    lifecycleRule : [StorageGcpmUpboundIoV1beta1BucketSpecForProviderLifecycleRuleItems0], default is Undefined, optional
        The bucket's Lifecycle Rules configuration. Multiple blocks of this type are permitted. Structure is documented below.
    location : str, default is Undefined, optional
        The GCS location.
    project : str, default is Undefined, optional
        The ID of the project in which the resource belongs. If it
        is not provided, the provider project is used.
    publicAccessPrevention : str, default is Undefined, optional
        Prevents public access to a bucket. Acceptable values are "inherited" or "enforced". If "inherited", the bucket uses public access prevention only if the bucket is subject to the public access prevention organization policy constraint. Defaults to "inherited".
    requesterPays : bool, default is Undefined, optional
        Enables Requester Pays on a storage bucket.
    rpo : str, default is Undefined, optional
        The recovery point objective for cross-region replication of the bucket. Applicable only for dual and multi-region buckets. "DEFAULT" sets default replication. "ASYNC_TURBO" value enables turbo replication, valid for dual-region buckets only. See Turbo Replication for more information. If rpo is not specified at bucket creation, it defaults to "DEFAULT" for dual and multi-region buckets. NOTE If used with single-region bucket, It will throw an error.
    storageClass : str, default is Undefined, optional
        The Storage Class of the new bucket. Supported values include: STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE.
    uniformBucketLevelAccess : bool, default is Undefined, optional
        Enables Uniform bucket-level access access to a bucket.
    autoclass : StorageGcpmUpboundIoV1beta1BucketSpecForProviderAutoclass, default is Undefined, optional
        autoclass
    customPlacementConfig : StorageGcpmUpboundIoV1beta1BucketSpecForProviderCustomPlacementConfig, default is Undefined, optional
        custom placement config
    encryption : StorageGcpmUpboundIoV1beta1BucketSpecForProviderEncryption, default is Undefined, optional
        encryption
    hierarchicalNamespace : StorageGcpmUpboundIoV1beta1BucketSpecForProviderHierarchicalNamespace, default is Undefined, optional
        hierarchical namespace
    ipFilter : StorageGcpmUpboundIoV1beta1BucketSpecForProviderIPFilter, default is Undefined, optional
        ip filter
    logging : StorageGcpmUpboundIoV1beta1BucketSpecForProviderLogging, default is Undefined, optional
        logging
    retentionPolicy : StorageGcpmUpboundIoV1beta1BucketSpecForProviderRetentionPolicy, default is Undefined, optional
        retention policy
    softDeletePolicy : StorageGcpmUpboundIoV1beta1BucketSpecForProviderSoftDeletePolicy, default is Undefined, optional
        soft delete policy
    versioning : StorageGcpmUpboundIoV1beta1BucketSpecForProviderVersioning, default is Undefined, optional
        versioning
    website : StorageGcpmUpboundIoV1beta1BucketSpecForProviderWebsite, default is Undefined, optional
        website
    """


    cors?: [StorageGcpmUpboundIoV1beta1BucketSpecForProviderCorsItems0]

    defaultEventBasedHold?: bool

    enableObjectRetention?: bool

    forceDestroy?: bool

    labels?: {str:str}

    lifecycleRule?: [StorageGcpmUpboundIoV1beta1BucketSpecForProviderLifecycleRuleItems0]

    location?: str

    project?: str

    publicAccessPrevention?: str

    requesterPays?: bool

    rpo?: str

    storageClass?: str

    uniformBucketLevelAccess?: bool

    autoclass?: StorageGcpmUpboundIoV1beta1BucketSpecForProviderAutoclass

    customPlacementConfig?: StorageGcpmUpboundIoV1beta1BucketSpecForProviderCustomPlacementConfig

    encryption?: StorageGcpmUpboundIoV1beta1BucketSpecForProviderEncryption

    hierarchicalNamespace?: StorageGcpmUpboundIoV1beta1BucketSpecForProviderHierarchicalNamespace

    ipFilter?: StorageGcpmUpboundIoV1beta1BucketSpecForProviderIPFilter

    logging?: StorageGcpmUpboundIoV1beta1BucketSpecForProviderLogging

    retentionPolicy?: StorageGcpmUpboundIoV1beta1BucketSpecForProviderRetentionPolicy

    softDeletePolicy?: StorageGcpmUpboundIoV1beta1BucketSpecForProviderSoftDeletePolicy

    versioning?: StorageGcpmUpboundIoV1beta1BucketSpecForProviderVersioning

    website?: StorageGcpmUpboundIoV1beta1BucketSpecForProviderWebsite


schema StorageGcpmUpboundIoV1beta1BucketSpecForProviderAutoclass:
    r"""
    The bucket's Autoclass configuration.  Structure is documented below.

    Attributes
    ----------
    enabled : bool, default is Undefined, optional
        While set to true, autoclass automatically transitions objects in your bucket to appropriate storage classes based on each object's access pattern.
    terminalStorageClass : str, default is Undefined, optional
        The storage class that objects in the bucket eventually transition to if they are not read for a certain length of time. Supported values include: NEARLINE, ARCHIVE.
    """


    enabled?: bool

    terminalStorageClass?: str


schema StorageGcpmUpboundIoV1beta1BucketSpecForProviderCorsItems0:
    r"""
    storage gcpm upbound io v1beta1 bucket spec for provider cors items0

    Attributes
    ----------
    maxAgeSeconds : float, default is Undefined, optional
        The value, in seconds, to return in the Access-Control-Max-Age header used in preflight responses.
    method : [str], default is Undefined, optional
        The list of HTTP methods on which to include CORS response headers, (GET, OPTIONS, POST, etc) Note: "*" is permitted in the list of methods, and means "any method".
    origin : [str], default is Undefined, optional
        The list of Origins eligible to receive CORS response headers. Note: "*" is permitted in the list of origins, and means "any Origin".
    responseHeader : [str], default is Undefined, optional
        The list of HTTP headers other than the simple response headers to give permission for the user-agent to share across domains.
    """


    maxAgeSeconds?: float

    method?: [str]

    origin?: [str]

    responseHeader?: [str]


schema StorageGcpmUpboundIoV1beta1BucketSpecForProviderCustomPlacementConfig:
    r"""
    The bucket's custom location configuration, which specifies the individual regions that comprise a dual-region bucket. If the bucket is designated a single or multi-region, the parameters are empty. Structure is documented below.

    Attributes
    ----------
    dataLocations : [str], default is Undefined, optional
        The list of individual regions that comprise a dual-region bucket. See Cloud Storage bucket locations for a list of acceptable regions. Note: If any of the data_locations changes, it will recreate the bucket.
    """


    dataLocations?: [str]


schema StorageGcpmUpboundIoV1beta1BucketSpecForProviderEncryption:
    r"""
    The bucket's encryption configuration. Structure is documented below.

    Attributes
    ----------
    defaultKmsKeyName : str, default is Undefined, optional
        : The id of a Cloud KMS key that will be used to encrypt objects inserted into this bucket, if no encryption method is specified.
        You must pay attention to whether the crypto key is available in the location that this bucket is created in.
        See the docs for more details.
    """


    defaultKmsKeyName?: str


schema StorageGcpmUpboundIoV1beta1BucketSpecForProviderHierarchicalNamespace:
    r"""
    The bucket's hierarchical namespace policy, which defines the bucket capability to handle folders in logical structure. Structure is documented below. To use this configuration, uniform_bucket_level_access must be enabled on bucket.

    Attributes
    ----------
    enabled : bool, default is Undefined, optional
        Enables hierarchical namespace for the bucket.
    """


    enabled?: bool


schema StorageGcpmUpboundIoV1beta1BucketSpecForProviderIPFilter:
    r"""
    The bucket IP filtering configuration. Specifies the network sources that can access the bucket, as well as its underlying objects. Structure is documented below.

    Attributes
    ----------
    allowAllServiceAgentAccess : bool, default is Undefined, optional
        While set true, allows all service agents to access the bucket regardless of the IP filter configuration.
    allowCrossOrgVpcs : bool, default is Undefined, optional
        While set true, allows cross-org VPCs in the bucket's IP filter configuration.
    mode : str, default is Undefined, optional
        The state of the IP filter configuration. Valid values are Enabled and Disabled. When set to Enabled, IP filtering rules are applied to a bucket and all incoming requests to the bucket are evaluated against these rules. When set to Disabled, IP filtering rules are not applied to a bucket. Note: allow_all_service_agent_access must be supplied when mode is set to Enabled, it can be ommited for other values.
    vpcNetworkSources : [StorageGcpmUpboundIoV1beta1BucketSpecForProviderIPFilterVpcNetworkSourcesItems0], default is Undefined, optional
        The list of VPC networks that can access the bucket. Structure is documented below.
    publicNetworkSource : StorageGcpmUpboundIoV1beta1BucketSpecForProviderIPFilterPublicNetworkSource, default is Undefined, optional
        public network source
    """


    allowAllServiceAgentAccess?: bool

    allowCrossOrgVpcs?: bool

    mode?: str

    vpcNetworkSources?: [StorageGcpmUpboundIoV1beta1BucketSpecForProviderIPFilterVpcNetworkSourcesItems0]

    publicNetworkSource?: StorageGcpmUpboundIoV1beta1BucketSpecForProviderIPFilterPublicNetworkSource


schema StorageGcpmUpboundIoV1beta1BucketSpecForProviderIPFilterPublicNetworkSource:
    r"""
    The public network IP address ranges that can access the bucket and its data. Structure is documented below.

    Attributes
    ----------
    allowedIpCidrRanges : [str], default is Undefined, optional
        The list of public or private IPv4 and IPv6 CIDR ranges that can access the bucket.
    """


    allowedIpCidrRanges?: [str]


schema StorageGcpmUpboundIoV1beta1BucketSpecForProviderIPFilterVpcNetworkSourcesItems0:
    r"""
    storage gcpm upbound io v1beta1 bucket spec for provider IP filter vpc network sources items0

    Attributes
    ----------
    allowedIpCidrRanges : [str], default is Undefined, optional
        The list of public or private IPv4 and IPv6 CIDR ranges that can access the bucket.
    network : str, default is Undefined, optional
        Name of the network. Format: projects/PROJECT_ID/global/networks/NETWORK_NAME
    """


    allowedIpCidrRanges?: [str]

    network?: str


schema StorageGcpmUpboundIoV1beta1BucketSpecForProviderLifecycleRuleItems0:
    r"""
    storage gcpm upbound io v1beta1 bucket spec for provider lifecycle rule items0

    Attributes
    ----------
    action : StorageGcpmUpboundIoV1beta1BucketSpecForProviderLifecycleRuleItems0Action, default is Undefined, optional
        action
    condition : StorageGcpmUpboundIoV1beta1BucketSpecForProviderLifecycleRuleItems0Condition, default is Undefined, optional
        condition
    """


    action?: StorageGcpmUpboundIoV1beta1BucketSpecForProviderLifecycleRuleItems0Action

    condition?: StorageGcpmUpboundIoV1beta1BucketSpecForProviderLifecycleRuleItems0Condition


schema StorageGcpmUpboundIoV1beta1BucketSpecForProviderLifecycleRuleItems0Action:
    r"""
    The Lifecycle Rule's action configuration. A single block of this type is supported. Structure is documented below.

    Attributes
    ----------
    storageClass : str, default is Undefined, optional
        The Storage Class of the new bucket. Supported values include: STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE.
    $type : str, default is Undefined, optional
        The type of the action of this Lifecycle Rule. Supported values include: Delete, SetStorageClass and AbortIncompleteMultipartUpload.
    """


    storageClass?: str

    $type?: str


schema StorageGcpmUpboundIoV1beta1BucketSpecForProviderLifecycleRuleItems0Condition:
    r"""
    The Lifecycle Rule's condition configuration. A single block of this type is supported. Structure is documented below.

    Attributes
    ----------
    age : float, default is Undefined, optional
        Minimum age of an object in days to satisfy this condition. Note To set 0 value of age, send_age_if_zero should be set true otherwise 0 value of age field will be ignored.
    createdBefore : str, default is Undefined, optional
        A date in the RFC 3339 format YYYY-MM-DD. This condition is satisfied when an object is created before midnight of the specified date in UTC.
    customTimeBefore : str, default is Undefined, optional
        A date in the RFC 3339 format YYYY-MM-DD. This condition is satisfied when the customTime metadata for the object is set to an earlier date than the date used in this lifecycle condition.
    daysSinceCustomTime : float, default is Undefined, optional
        Days since the date set in the customTime metadata for the object. This condition is satisfied when the current date and time is at least the specified number of days after the customTime. When set to 0 it will be ignored, and your state will treat it as though you supplied no days_since_custom_time condition.
    daysSinceNoncurrentTime : float, default is Undefined, optional
        Relevant only for versioned objects. Number of days elapsed since the noncurrent timestamp of an object. When set to 0 it will be ignored, and your state will treat it as though you supplied no days_since_noncurrent_time condition.
    matchesPrefix : [str], default is Undefined, optional
        One or more matching name prefixes to satisfy this condition.
    matchesStorageClass : [str], default is Undefined, optional
        Storage Class of objects to satisfy this condition. Supported values include: STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE, DURABLE_REDUCED_AVAILABILITY.
    matchesSuffix : [str], default is Undefined, optional
        One or more matching name suffixes to satisfy this condition.
    noncurrentTimeBefore : str, default is Undefined, optional
        Relevant only for versioned objects. The date in RFC 3339 (e.g. 2017-06-13) when the object became nonconcurrent. When set to 0 it will be ignored, and your state will treat it as though you supplied no noncurrent_time_before condition.
    numNewerVersions : float, default is Undefined, optional
        Relevant only for versioned objects. The number of newer versions of an object to satisfy this condition. When set to 0 it will be ignored and your state will treat it as though you supplied no num_newer_versions condition.
    sendAgeIfZero : bool, default is Undefined, optional
        While set true, age value will be sent in the request even for zero value of the field. This field is only useful and required for setting 0 value to the age field. It can be used alone or together with age attribute. NOTE age attibute with 0 value will be ommitted from the API request if send_age_if_zero field is having false value.
    sendDaysSinceCustomTimeIfZero : bool, default is Undefined, optional
        While set true, days_since_custom_time value will be sent in the request even for zero value of the field. This field is only useful for setting 0 value to the days_since_custom_time field. It can be used alone or together with days_since_custom_time.
    sendDaysSinceNoncurrentTimeIfZero : bool, default is Undefined, optional
        While set true, days_since_noncurrent_time value will be sent in the request even for zero value of the field. This field is only useful for setting 0 value to the days_since_noncurrent_time field. It can be used alone or together with days_since_noncurrent_time.
    sendNumNewerVersionsIfZero : bool, default is Undefined, optional
        While set true, num_newer_versions value will be sent in the request even for zero value of the field. This field is only useful for setting 0 value to the num_newer_versions field. It can be used alone or together with num_newer_versions.
    withState : str, default is Undefined, optional
        Match to live and/or archived objects. Unversioned buckets have only live objects. Supported values include: "LIVE", "ARCHIVED", "ANY".
    """


    age?: float

    createdBefore?: str

    customTimeBefore?: str

    daysSinceCustomTime?: float

    daysSinceNoncurrentTime?: float

    matchesPrefix?: [str]

    matchesStorageClass?: [str]

    matchesSuffix?: [str]

    noncurrentTimeBefore?: str

    numNewerVersions?: float

    sendAgeIfZero?: bool

    sendDaysSinceCustomTimeIfZero?: bool

    sendDaysSinceNoncurrentTimeIfZero?: bool

    sendNumNewerVersionsIfZero?: bool

    withState?: str


schema StorageGcpmUpboundIoV1beta1BucketSpecForProviderLogging:
    r"""
    The bucket's Access & Storage Logs configuration. Structure is documented below.

    Attributes
    ----------
    logBucket : str, default is Undefined, optional
        The bucket that will receive log objects.
    logObjectPrefix : str, default is Undefined, optional
        The object prefix for log objects. If it's not provided,
        by default GCS sets this to this bucket's name.
    """


    logBucket?: str

    logObjectPrefix?: str


schema StorageGcpmUpboundIoV1beta1BucketSpecForProviderRetentionPolicy:
    r"""
    Configuration of the bucket's data retention policy for how long objects in the bucket should be retained. Structure is documented below.

    Attributes
    ----------
    isLocked : bool, default is Undefined, optional
        If set to true, the bucket will be locked and permanently restrict edits to the bucket's retention policy.  Caution: Locking a bucket is an irreversible action.
    retentionPeriod : float, default is Undefined, optional
        The period of time, in seconds, that objects in the bucket must be retained and cannot be deleted, overwritten, or archived. The value must be less than 2,147,483,647 seconds.
    """


    isLocked?: bool

    retentionPeriod?: float


schema StorageGcpmUpboundIoV1beta1BucketSpecForProviderSoftDeletePolicy:
    r"""
    The bucket's soft delete policy, which defines the period of time that soft-deleted objects will be retained, and cannot be permanently deleted. Structure is documented below.

    Attributes
    ----------
    retentionDurationSeconds : float, default is Undefined, optional
        The duration in seconds that soft-deleted objects in the bucket will be retained and cannot be permanently deleted. Default value is 604800. The value must be in between 604800(7 days) and 7776000(90 days). Note: To disable the soft delete policy on a bucket, This field must be set to 0.
    """


    retentionDurationSeconds?: float


schema StorageGcpmUpboundIoV1beta1BucketSpecForProviderVersioning:
    r"""
    The bucket's Versioning configuration.  Structure is documented below.

    Attributes
    ----------
    enabled : bool, default is Undefined, optional
        While set to true, versioning is fully enabled for this bucket.
    """


    enabled?: bool


schema StorageGcpmUpboundIoV1beta1BucketSpecForProviderWebsite:
    r"""
    Configuration if the bucket acts as a website. Structure is documented below.

    Attributes
    ----------
    mainPageSuffix : str, default is Undefined, optional
        Behaves as the bucket's directory index where
        missing objects are treated as potential directories.
    notFoundPage : str, default is Undefined, optional
        The custom object to return when a requested
        resource is not found.
    """


    mainPageSuffix?: str

    notFoundPage?: str


schema StorageGcpmUpboundIoV1beta1BucketSpecInitProvider:
    r"""
    THIS IS A BETA FIELD. It will be honored
    unless the Management Policies feature flag is disabled.
    InitProvider holds the same fields as ForProvider, with the exception
    of Identifier and other resource reference fields. The fields that are
    in InitProvider are merged into ForProvider when the resource is created.
    The same fields are also added to the terraform ignore_changes hook, to
    avoid updating them after creation. This is useful for fields that are
    required on creation, but we do not desire to update them after creation,
    for example because of an external controller is managing them, like an
    autoscaler.

    Attributes
    ----------
    cors : [StorageGcpmUpboundIoV1beta1BucketSpecInitProviderCorsItems0], default is Undefined, optional
        The bucket's Cross-Origin Resource Sharing (CORS) configuration. Multiple blocks of this type are permitted. Structure is documented below.
    defaultEventBasedHold : bool, default is Undefined, optional
        Whether or not to automatically apply an eventBasedHold to new objects added to the bucket.
    enableObjectRetention : bool, default is Undefined, optional
        Enables object retention on a storage bucket.
    forceDestroy : bool, default is Undefined, optional
        When deleting a bucket, this
        boolean option will delete all contained objects.
    labels : {str:str}, default is Undefined, optional
        A map of key/value label pairs to assign to the bucket.
    lifecycleRule : [StorageGcpmUpboundIoV1beta1BucketSpecInitProviderLifecycleRuleItems0], default is Undefined, optional
        The bucket's Lifecycle Rules configuration. Multiple blocks of this type are permitted. Structure is documented below.
    location : str, default is Undefined, optional
        The GCS location.
    project : str, default is Undefined, optional
        The ID of the project in which the resource belongs. If it
        is not provided, the provider project is used.
    publicAccessPrevention : str, default is Undefined, optional
        Prevents public access to a bucket. Acceptable values are "inherited" or "enforced". If "inherited", the bucket uses public access prevention only if the bucket is subject to the public access prevention organization policy constraint. Defaults to "inherited".
    requesterPays : bool, default is Undefined, optional
        Enables Requester Pays on a storage bucket.
    rpo : str, default is Undefined, optional
        The recovery point objective for cross-region replication of the bucket. Applicable only for dual and multi-region buckets. "DEFAULT" sets default replication. "ASYNC_TURBO" value enables turbo replication, valid for dual-region buckets only. See Turbo Replication for more information. If rpo is not specified at bucket creation, it defaults to "DEFAULT" for dual and multi-region buckets. NOTE If used with single-region bucket, It will throw an error.
    storageClass : str, default is Undefined, optional
        The Storage Class of the new bucket. Supported values include: STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE.
    uniformBucketLevelAccess : bool, default is Undefined, optional
        Enables Uniform bucket-level access access to a bucket.
    autoclass : StorageGcpmUpboundIoV1beta1BucketSpecInitProviderAutoclass, default is Undefined, optional
        autoclass
    customPlacementConfig : StorageGcpmUpboundIoV1beta1BucketSpecInitProviderCustomPlacementConfig, default is Undefined, optional
        custom placement config
    encryption : StorageGcpmUpboundIoV1beta1BucketSpecInitProviderEncryption, default is Undefined, optional
        encryption
    hierarchicalNamespace : StorageGcpmUpboundIoV1beta1BucketSpecInitProviderHierarchicalNamespace, default is Undefined, optional
        hierarchical namespace
    ipFilter : StorageGcpmUpboundIoV1beta1BucketSpecInitProviderIPFilter, default is Undefined, optional
        ip filter
    logging : StorageGcpmUpboundIoV1beta1BucketSpecInitProviderLogging, default is Undefined, optional
        logging
    retentionPolicy : StorageGcpmUpboundIoV1beta1BucketSpecInitProviderRetentionPolicy, default is Undefined, optional
        retention policy
    softDeletePolicy : StorageGcpmUpboundIoV1beta1BucketSpecInitProviderSoftDeletePolicy, default is Undefined, optional
        soft delete policy
    versioning : StorageGcpmUpboundIoV1beta1BucketSpecInitProviderVersioning, default is Undefined, optional
        versioning
    website : StorageGcpmUpboundIoV1beta1BucketSpecInitProviderWebsite, default is Undefined, optional
        website
    """


    cors?: [StorageGcpmUpboundIoV1beta1BucketSpecInitProviderCorsItems0]

    defaultEventBasedHold?: bool

    enableObjectRetention?: bool

    forceDestroy?: bool

    labels?: {str:str}

    lifecycleRule?: [StorageGcpmUpboundIoV1beta1BucketSpecInitProviderLifecycleRuleItems0]

    location?: str

    project?: str

    publicAccessPrevention?: str

    requesterPays?: bool

    rpo?: str

    storageClass?: str

    uniformBucketLevelAccess?: bool

    autoclass?: StorageGcpmUpboundIoV1beta1BucketSpecInitProviderAutoclass

    customPlacementConfig?: StorageGcpmUpboundIoV1beta1BucketSpecInitProviderCustomPlacementConfig

    encryption?: StorageGcpmUpboundIoV1beta1BucketSpecInitProviderEncryption

    hierarchicalNamespace?: StorageGcpmUpboundIoV1beta1BucketSpecInitProviderHierarchicalNamespace

    ipFilter?: StorageGcpmUpboundIoV1beta1BucketSpecInitProviderIPFilter

    logging?: StorageGcpmUpboundIoV1beta1BucketSpecInitProviderLogging

    retentionPolicy?: StorageGcpmUpboundIoV1beta1BucketSpecInitProviderRetentionPolicy

    softDeletePolicy?: StorageGcpmUpboundIoV1beta1BucketSpecInitProviderSoftDeletePolicy

    versioning?: StorageGcpmUpboundIoV1beta1BucketSpecInitProviderVersioning

    website?: StorageGcpmUpboundIoV1beta1BucketSpecInitProviderWebsite


schema StorageGcpmUpboundIoV1beta1BucketSpecInitProviderAutoclass:
    r"""
    The bucket's Autoclass configuration.  Structure is documented below.

    Attributes
    ----------
    enabled : bool, default is Undefined, optional
        While set to true, autoclass automatically transitions objects in your bucket to appropriate storage classes based on each object's access pattern.
    terminalStorageClass : str, default is Undefined, optional
        The storage class that objects in the bucket eventually transition to if they are not read for a certain length of time. Supported values include: NEARLINE, ARCHIVE.
    """


    enabled?: bool

    terminalStorageClass?: str


schema StorageGcpmUpboundIoV1beta1BucketSpecInitProviderCorsItems0:
    r"""
    storage gcpm upbound io v1beta1 bucket spec init provider cors items0

    Attributes
    ----------
    maxAgeSeconds : float, default is Undefined, optional
        The value, in seconds, to return in the Access-Control-Max-Age header used in preflight responses.
    method : [str], default is Undefined, optional
        The list of HTTP methods on which to include CORS response headers, (GET, OPTIONS, POST, etc) Note: "*" is permitted in the list of methods, and means "any method".
    origin : [str], default is Undefined, optional
        The list of Origins eligible to receive CORS response headers. Note: "*" is permitted in the list of origins, and means "any Origin".
    responseHeader : [str], default is Undefined, optional
        The list of HTTP headers other than the simple response headers to give permission for the user-agent to share across domains.
    """


    maxAgeSeconds?: float

    method?: [str]

    origin?: [str]

    responseHeader?: [str]


schema StorageGcpmUpboundIoV1beta1BucketSpecInitProviderCustomPlacementConfig:
    r"""
    The bucket's custom location configuration, which specifies the individual regions that comprise a dual-region bucket. If the bucket is designated a single or multi-region, the parameters are empty. Structure is documented below.

    Attributes
    ----------
    dataLocations : [str], default is Undefined, optional
        The list of individual regions that comprise a dual-region bucket. See Cloud Storage bucket locations for a list of acceptable regions. Note: If any of the data_locations changes, it will recreate the bucket.
    """


    dataLocations?: [str]


schema StorageGcpmUpboundIoV1beta1BucketSpecInitProviderEncryption:
    r"""
    The bucket's encryption configuration. Structure is documented below.

    Attributes
    ----------
    defaultKmsKeyName : str, default is Undefined, optional
        : The id of a Cloud KMS key that will be used to encrypt objects inserted into this bucket, if no encryption method is specified.
        You must pay attention to whether the crypto key is available in the location that this bucket is created in.
        See the docs for more details.
    """


    defaultKmsKeyName?: str


schema StorageGcpmUpboundIoV1beta1BucketSpecInitProviderHierarchicalNamespace:
    r"""
    The bucket's hierarchical namespace policy, which defines the bucket capability to handle folders in logical structure. Structure is documented below. To use this configuration, uniform_bucket_level_access must be enabled on bucket.

    Attributes
    ----------
    enabled : bool, default is Undefined, optional
        Enables hierarchical namespace for the bucket.
    """


    enabled?: bool


schema StorageGcpmUpboundIoV1beta1BucketSpecInitProviderIPFilter:
    r"""
    The bucket IP filtering configuration. Specifies the network sources that can access the bucket, as well as its underlying objects. Structure is documented below.

    Attributes
    ----------
    allowAllServiceAgentAccess : bool, default is Undefined, optional
        While set true, allows all service agents to access the bucket regardless of the IP filter configuration.
    allowCrossOrgVpcs : bool, default is Undefined, optional
        While set true, allows cross-org VPCs in the bucket's IP filter configuration.
    mode : str, default is Undefined, optional
        The state of the IP filter configuration. Valid values are Enabled and Disabled. When set to Enabled, IP filtering rules are applied to a bucket and all incoming requests to the bucket are evaluated against these rules. When set to Disabled, IP filtering rules are not applied to a bucket. Note: allow_all_service_agent_access must be supplied when mode is set to Enabled, it can be ommited for other values.
    vpcNetworkSources : [StorageGcpmUpboundIoV1beta1BucketSpecInitProviderIPFilterVpcNetworkSourcesItems0], default is Undefined, optional
        The list of VPC networks that can access the bucket. Structure is documented below.
    publicNetworkSource : StorageGcpmUpboundIoV1beta1BucketSpecInitProviderIPFilterPublicNetworkSource, default is Undefined, optional
        public network source
    """


    allowAllServiceAgentAccess?: bool

    allowCrossOrgVpcs?: bool

    mode?: str

    vpcNetworkSources?: [StorageGcpmUpboundIoV1beta1BucketSpecInitProviderIPFilterVpcNetworkSourcesItems0]

    publicNetworkSource?: StorageGcpmUpboundIoV1beta1BucketSpecInitProviderIPFilterPublicNetworkSource


schema StorageGcpmUpboundIoV1beta1BucketSpecInitProviderIPFilterPublicNetworkSource:
    r"""
    The public network IP address ranges that can access the bucket and its data. Structure is documented below.

    Attributes
    ----------
    allowedIpCidrRanges : [str], default is Undefined, optional
        The list of public or private IPv4 and IPv6 CIDR ranges that can access the bucket.
    """


    allowedIpCidrRanges?: [str]


schema StorageGcpmUpboundIoV1beta1BucketSpecInitProviderIPFilterVpcNetworkSourcesItems0:
    r"""
    storage gcpm upbound io v1beta1 bucket spec init provider IP filter vpc network sources items0

    Attributes
    ----------
    allowedIpCidrRanges : [str], default is Undefined, optional
        The list of public or private IPv4 and IPv6 CIDR ranges that can access the bucket.
    network : str, default is Undefined, optional
        Name of the network. Format: projects/PROJECT_ID/global/networks/NETWORK_NAME
    """


    allowedIpCidrRanges?: [str]

    network?: str


schema StorageGcpmUpboundIoV1beta1BucketSpecInitProviderLifecycleRuleItems0:
    r"""
    storage gcpm upbound io v1beta1 bucket spec init provider lifecycle rule items0

    Attributes
    ----------
    action : StorageGcpmUpboundIoV1beta1BucketSpecInitProviderLifecycleRuleItems0Action, default is Undefined, optional
        action
    condition : StorageGcpmUpboundIoV1beta1BucketSpecInitProviderLifecycleRuleItems0Condition, default is Undefined, optional
        condition
    """


    action?: StorageGcpmUpboundIoV1beta1BucketSpecInitProviderLifecycleRuleItems0Action

    condition?: StorageGcpmUpboundIoV1beta1BucketSpecInitProviderLifecycleRuleItems0Condition


schema StorageGcpmUpboundIoV1beta1BucketSpecInitProviderLifecycleRuleItems0Action:
    r"""
    The Lifecycle Rule's action configuration. A single block of this type is supported. Structure is documented below.

    Attributes
    ----------
    storageClass : str, default is Undefined, optional
        The Storage Class of the new bucket. Supported values include: STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE.
    $type : str, default is Undefined, optional
        The type of the action of this Lifecycle Rule. Supported values include: Delete, SetStorageClass and AbortIncompleteMultipartUpload.
    """


    storageClass?: str

    $type?: str


schema StorageGcpmUpboundIoV1beta1BucketSpecInitProviderLifecycleRuleItems0Condition:
    r"""
    The Lifecycle Rule's condition configuration. A single block of this type is supported. Structure is documented below.

    Attributes
    ----------
    age : float, default is Undefined, optional
        Minimum age of an object in days to satisfy this condition. Note To set 0 value of age, send_age_if_zero should be set true otherwise 0 value of age field will be ignored.
    createdBefore : str, default is Undefined, optional
        A date in the RFC 3339 format YYYY-MM-DD. This condition is satisfied when an object is created before midnight of the specified date in UTC.
    customTimeBefore : str, default is Undefined, optional
        A date in the RFC 3339 format YYYY-MM-DD. This condition is satisfied when the customTime metadata for the object is set to an earlier date than the date used in this lifecycle condition.
    daysSinceCustomTime : float, default is Undefined, optional
        Days since the date set in the customTime metadata for the object. This condition is satisfied when the current date and time is at least the specified number of days after the customTime. When set to 0 it will be ignored, and your state will treat it as though you supplied no days_since_custom_time condition.
    daysSinceNoncurrentTime : float, default is Undefined, optional
        Relevant only for versioned objects. Number of days elapsed since the noncurrent timestamp of an object. When set to 0 it will be ignored, and your state will treat it as though you supplied no days_since_noncurrent_time condition.
    matchesPrefix : [str], default is Undefined, optional
        One or more matching name prefixes to satisfy this condition.
    matchesStorageClass : [str], default is Undefined, optional
        Storage Class of objects to satisfy this condition. Supported values include: STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE, DURABLE_REDUCED_AVAILABILITY.
    matchesSuffix : [str], default is Undefined, optional
        One or more matching name suffixes to satisfy this condition.
    noncurrentTimeBefore : str, default is Undefined, optional
        Relevant only for versioned objects. The date in RFC 3339 (e.g. 2017-06-13) when the object became nonconcurrent. When set to 0 it will be ignored, and your state will treat it as though you supplied no noncurrent_time_before condition.
    numNewerVersions : float, default is Undefined, optional
        Relevant only for versioned objects. The number of newer versions of an object to satisfy this condition. When set to 0 it will be ignored and your state will treat it as though you supplied no num_newer_versions condition.
    sendAgeIfZero : bool, default is Undefined, optional
        While set true, age value will be sent in the request even for zero value of the field. This field is only useful and required for setting 0 value to the age field. It can be used alone or together with age attribute. NOTE age attibute with 0 value will be ommitted from the API request if send_age_if_zero field is having false value.
    sendDaysSinceCustomTimeIfZero : bool, default is Undefined, optional
        While set true, days_since_custom_time value will be sent in the request even for zero value of the field. This field is only useful for setting 0 value to the days_since_custom_time field. It can be used alone or together with days_since_custom_time.
    sendDaysSinceNoncurrentTimeIfZero : bool, default is Undefined, optional
        While set true, days_since_noncurrent_time value will be sent in the request even for zero value of the field. This field is only useful for setting 0 value to the days_since_noncurrent_time field. It can be used alone or together with days_since_noncurrent_time.
    sendNumNewerVersionsIfZero : bool, default is Undefined, optional
        While set true, num_newer_versions value will be sent in the request even for zero value of the field. This field is only useful for setting 0 value to the num_newer_versions field. It can be used alone or together with num_newer_versions.
    withState : str, default is Undefined, optional
        Match to live and/or archived objects. Unversioned buckets have only live objects. Supported values include: "LIVE", "ARCHIVED", "ANY".
    """


    age?: float

    createdBefore?: str

    customTimeBefore?: str

    daysSinceCustomTime?: float

    daysSinceNoncurrentTime?: float

    matchesPrefix?: [str]

    matchesStorageClass?: [str]

    matchesSuffix?: [str]

    noncurrentTimeBefore?: str

    numNewerVersions?: float

    sendAgeIfZero?: bool

    sendDaysSinceCustomTimeIfZero?: bool

    sendDaysSinceNoncurrentTimeIfZero?: bool

    sendNumNewerVersionsIfZero?: bool

    withState?: str


schema StorageGcpmUpboundIoV1beta1BucketSpecInitProviderLogging:
    r"""
    The bucket's Access & Storage Logs configuration. Structure is documented below.

    Attributes
    ----------
    logBucket : str, default is Undefined, optional
        The bucket that will receive log objects.
    logObjectPrefix : str, default is Undefined, optional
        The object prefix for log objects. If it's not provided,
        by default GCS sets this to this bucket's name.
    """


    logBucket?: str

    logObjectPrefix?: str


schema StorageGcpmUpboundIoV1beta1BucketSpecInitProviderRetentionPolicy:
    r"""
    Configuration of the bucket's data retention policy for how long objects in the bucket should be retained. Structure is documented below.

    Attributes
    ----------
    isLocked : bool, default is Undefined, optional
        If set to true, the bucket will be locked and permanently restrict edits to the bucket's retention policy.  Caution: Locking a bucket is an irreversible action.
    retentionPeriod : float, default is Undefined, optional
        The period of time, in seconds, that objects in the bucket must be retained and cannot be deleted, overwritten, or archived. The value must be less than 2,147,483,647 seconds.
    """


    isLocked?: bool

    retentionPeriod?: float


schema StorageGcpmUpboundIoV1beta1BucketSpecInitProviderSoftDeletePolicy:
    r"""
    The bucket's soft delete policy, which defines the period of time that soft-deleted objects will be retained, and cannot be permanently deleted. Structure is documented below.

    Attributes
    ----------
    retentionDurationSeconds : float, default is Undefined, optional
        The duration in seconds that soft-deleted objects in the bucket will be retained and cannot be permanently deleted. Default value is 604800. The value must be in between 604800(7 days) and 7776000(90 days). Note: To disable the soft delete policy on a bucket, This field must be set to 0.
    """


    retentionDurationSeconds?: float


schema StorageGcpmUpboundIoV1beta1BucketSpecInitProviderVersioning:
    r"""
    The bucket's Versioning configuration.  Structure is documented below.

    Attributes
    ----------
    enabled : bool, default is Undefined, optional
        While set to true, versioning is fully enabled for this bucket.
    """


    enabled?: bool


schema StorageGcpmUpboundIoV1beta1BucketSpecInitProviderWebsite:
    r"""
    Configuration if the bucket acts as a website. Structure is documented below.

    Attributes
    ----------
    mainPageSuffix : str, default is Undefined, optional
        Behaves as the bucket's directory index where
        missing objects are treated as potential directories.
    notFoundPage : str, default is Undefined, optional
        The custom object to return when a requested
        resource is not found.
    """


    mainPageSuffix?: str

    notFoundPage?: str


schema StorageGcpmUpboundIoV1beta1BucketSpecProviderConfigRef:
    r"""
    ProviderConfigReference specifies how the provider that will be used to
    create, observe, update, and delete this managed resource should be
    configured.

    Attributes
    ----------
    kind : str, default is Undefined, required
        Kind of the referenced object.
    name : str, default is Undefined, required
        Name of the referenced object.
    """


    kind: str

    name: str


schema StorageGcpmUpboundIoV1beta1BucketSpecWriteConnectionSecretToRef:
    r"""
    WriteConnectionSecretToReference specifies the namespace and name of a
    Secret to which any connection details for this managed resource should
    be written. Connection details frequently include the endpoint, username,
    and password required to connect to the managed resource.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the secret.
    """


    name: str


schema StorageGcpmUpboundIoV1beta1BucketStatus:
    r"""
    BucketStatus defines the observed state of Bucket.

    Attributes
    ----------
    conditions : [StorageGcpmUpboundIoV1beta1BucketStatusConditionsItems0], default is Undefined, optional
        Conditions of the resource.
    observedGeneration : int, default is Undefined, optional
        ObservedGeneration is the latest metadata.generation
        which resulted in either a ready state, or stalled due to error
        it can not recover from without human intervention.
    atProvider : StorageGcpmUpboundIoV1beta1BucketStatusAtProvider, default is Undefined, optional
        at provider
    """


    conditions?: [StorageGcpmUpboundIoV1beta1BucketStatusConditionsItems0]

    observedGeneration?: int

    atProvider?: StorageGcpmUpboundIoV1beta1BucketStatusAtProvider


schema StorageGcpmUpboundIoV1beta1BucketStatusAtProvider:
    r"""
    storage gcpm upbound io v1beta1 bucket status at provider

    Attributes
    ----------
    cors : [StorageGcpmUpboundIoV1beta1BucketStatusAtProviderCorsItems0], default is Undefined, optional
        The bucket's Cross-Origin Resource Sharing (CORS) configuration. Multiple blocks of this type are permitted. Structure is documented below.
    defaultEventBasedHold : bool, default is Undefined, optional
        Whether or not to automatically apply an eventBasedHold to new objects added to the bucket.
    effectiveLabels : {str:str}, default is Undefined, optional
        A map of key/value label pairs to assign to the bucket.
    enableObjectRetention : bool, default is Undefined, optional
        Enables object retention on a storage bucket.
    forceDestroy : bool, default is Undefined, optional
        When deleting a bucket, this
        boolean option will delete all contained objects.
    id : str, default is Undefined, optional
        id
    labels : {str:str}, default is Undefined, optional
        A map of key/value label pairs to assign to the bucket.
    lifecycleRule : [StorageGcpmUpboundIoV1beta1BucketStatusAtProviderLifecycleRuleItems0], default is Undefined, optional
        The bucket's Lifecycle Rules configuration. Multiple blocks of this type are permitted. Structure is documented below.
    location : str, default is Undefined, optional
        The GCS location.
    project : str, default is Undefined, optional
        The ID of the project in which the resource belongs. If it
        is not provided, the provider project is used.
    projectNumber : float, default is Undefined, optional
        project number
    publicAccessPrevention : str, default is Undefined, optional
        Prevents public access to a bucket. Acceptable values are "inherited" or "enforced". If "inherited", the bucket uses public access prevention only if the bucket is subject to the public access prevention organization policy constraint. Defaults to "inherited".
    requesterPays : bool, default is Undefined, optional
        Enables Requester Pays on a storage bucket.
    rpo : str, default is Undefined, optional
        The recovery point objective for cross-region replication of the bucket. Applicable only for dual and multi-region buckets. "DEFAULT" sets default replication. "ASYNC_TURBO" value enables turbo replication, valid for dual-region buckets only. See Turbo Replication for more information. If rpo is not specified at bucket creation, it defaults to "DEFAULT" for dual and multi-region buckets. NOTE If used with single-region bucket, It will throw an error.
    selfLink : str, default is Undefined, optional
        The URI of the created resource.
    storageClass : str, default is Undefined, optional
        The Storage Class of the new bucket. Supported values include: STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE.
    terraformLabels : {str:str}, default is Undefined, optional
        A map of key/value label pairs to assign to the bucket.
    timeCreated : str, default is Undefined, optional
        (Computed) The creation time of the bucket in RFC 3339 format.
    uniformBucketLevelAccess : bool, default is Undefined, optional
        Enables Uniform bucket-level access access to a bucket.
    updated : str, default is Undefined, optional
        (Computed) The time at which the bucket's metadata or IAM policy was last updated, in RFC 3339 format.
    url : str, default is Undefined, optional
        The base URL of the bucket, in the format gs://<bucket-name>.
    autoclass : StorageGcpmUpboundIoV1beta1BucketStatusAtProviderAutoclass, default is Undefined, optional
        autoclass
    customPlacementConfig : StorageGcpmUpboundIoV1beta1BucketStatusAtProviderCustomPlacementConfig, default is Undefined, optional
        custom placement config
    encryption : StorageGcpmUpboundIoV1beta1BucketStatusAtProviderEncryption, default is Undefined, optional
        encryption
    hierarchicalNamespace : StorageGcpmUpboundIoV1beta1BucketStatusAtProviderHierarchicalNamespace, default is Undefined, optional
        hierarchical namespace
    ipFilter : StorageGcpmUpboundIoV1beta1BucketStatusAtProviderIPFilter, default is Undefined, optional
        ip filter
    logging : StorageGcpmUpboundIoV1beta1BucketStatusAtProviderLogging, default is Undefined, optional
        logging
    retentionPolicy : StorageGcpmUpboundIoV1beta1BucketStatusAtProviderRetentionPolicy, default is Undefined, optional
        retention policy
    softDeletePolicy : StorageGcpmUpboundIoV1beta1BucketStatusAtProviderSoftDeletePolicy, default is Undefined, optional
        soft delete policy
    versioning : StorageGcpmUpboundIoV1beta1BucketStatusAtProviderVersioning, default is Undefined, optional
        versioning
    website : StorageGcpmUpboundIoV1beta1BucketStatusAtProviderWebsite, default is Undefined, optional
        website
    """


    cors?: [StorageGcpmUpboundIoV1beta1BucketStatusAtProviderCorsItems0]

    defaultEventBasedHold?: bool

    effectiveLabels?: {str:str}

    enableObjectRetention?: bool

    forceDestroy?: bool

    id?: str

    labels?: {str:str}

    lifecycleRule?: [StorageGcpmUpboundIoV1beta1BucketStatusAtProviderLifecycleRuleItems0]

    location?: str

    project?: str

    projectNumber?: float

    publicAccessPrevention?: str

    requesterPays?: bool

    rpo?: str

    selfLink?: str

    storageClass?: str

    terraformLabels?: {str:str}

    timeCreated?: str

    uniformBucketLevelAccess?: bool

    updated?: str

    url?: str

    autoclass?: StorageGcpmUpboundIoV1beta1BucketStatusAtProviderAutoclass

    customPlacementConfig?: StorageGcpmUpboundIoV1beta1BucketStatusAtProviderCustomPlacementConfig

    encryption?: StorageGcpmUpboundIoV1beta1BucketStatusAtProviderEncryption

    hierarchicalNamespace?: StorageGcpmUpboundIoV1beta1BucketStatusAtProviderHierarchicalNamespace

    ipFilter?: StorageGcpmUpboundIoV1beta1BucketStatusAtProviderIPFilter

    logging?: StorageGcpmUpboundIoV1beta1BucketStatusAtProviderLogging

    retentionPolicy?: StorageGcpmUpboundIoV1beta1BucketStatusAtProviderRetentionPolicy

    softDeletePolicy?: StorageGcpmUpboundIoV1beta1BucketStatusAtProviderSoftDeletePolicy

    versioning?: StorageGcpmUpboundIoV1beta1BucketStatusAtProviderVersioning

    website?: StorageGcpmUpboundIoV1beta1BucketStatusAtProviderWebsite


schema StorageGcpmUpboundIoV1beta1BucketStatusAtProviderAutoclass:
    r"""
    The bucket's Autoclass configuration.  Structure is documented below.

    Attributes
    ----------
    enabled : bool, default is Undefined, optional
        While set to true, autoclass automatically transitions objects in your bucket to appropriate storage classes based on each object's access pattern.
    terminalStorageClass : str, default is Undefined, optional
        The storage class that objects in the bucket eventually transition to if they are not read for a certain length of time. Supported values include: NEARLINE, ARCHIVE.
    """


    enabled?: bool

    terminalStorageClass?: str


schema StorageGcpmUpboundIoV1beta1BucketStatusAtProviderCorsItems0:
    r"""
    storage gcpm upbound io v1beta1 bucket status at provider cors items0

    Attributes
    ----------
    maxAgeSeconds : float, default is Undefined, optional
        The value, in seconds, to return in the Access-Control-Max-Age header used in preflight responses.
    method : [str], default is Undefined, optional
        The list of HTTP methods on which to include CORS response headers, (GET, OPTIONS, POST, etc) Note: "*" is permitted in the list of methods, and means "any method".
    origin : [str], default is Undefined, optional
        The list of Origins eligible to receive CORS response headers. Note: "*" is permitted in the list of origins, and means "any Origin".
    responseHeader : [str], default is Undefined, optional
        The list of HTTP headers other than the simple response headers to give permission for the user-agent to share across domains.
    """


    maxAgeSeconds?: float

    method?: [str]

    origin?: [str]

    responseHeader?: [str]


schema StorageGcpmUpboundIoV1beta1BucketStatusAtProviderCustomPlacementConfig:
    r"""
    The bucket's custom location configuration, which specifies the individual regions that comprise a dual-region bucket. If the bucket is designated a single or multi-region, the parameters are empty. Structure is documented below.

    Attributes
    ----------
    dataLocations : [str], default is Undefined, optional
        The list of individual regions that comprise a dual-region bucket. See Cloud Storage bucket locations for a list of acceptable regions. Note: If any of the data_locations changes, it will recreate the bucket.
    """


    dataLocations?: [str]


schema StorageGcpmUpboundIoV1beta1BucketStatusAtProviderEncryption:
    r"""
    The bucket's encryption configuration. Structure is documented below.

    Attributes
    ----------
    defaultKmsKeyName : str, default is Undefined, optional
        : The id of a Cloud KMS key that will be used to encrypt objects inserted into this bucket, if no encryption method is specified.
        You must pay attention to whether the crypto key is available in the location that this bucket is created in.
        See the docs for more details.
    """


    defaultKmsKeyName?: str


schema StorageGcpmUpboundIoV1beta1BucketStatusAtProviderHierarchicalNamespace:
    r"""
    The bucket's hierarchical namespace policy, which defines the bucket capability to handle folders in logical structure. Structure is documented below. To use this configuration, uniform_bucket_level_access must be enabled on bucket.

    Attributes
    ----------
    enabled : bool, default is Undefined, optional
        Enables hierarchical namespace for the bucket.
    """


    enabled?: bool


schema StorageGcpmUpboundIoV1beta1BucketStatusAtProviderIPFilter:
    r"""
    The bucket IP filtering configuration. Specifies the network sources that can access the bucket, as well as its underlying objects. Structure is documented below.

    Attributes
    ----------
    allowAllServiceAgentAccess : bool, default is Undefined, optional
        While set true, allows all service agents to access the bucket regardless of the IP filter configuration.
    allowCrossOrgVpcs : bool, default is Undefined, optional
        While set true, allows cross-org VPCs in the bucket's IP filter configuration.
    mode : str, default is Undefined, optional
        The state of the IP filter configuration. Valid values are Enabled and Disabled. When set to Enabled, IP filtering rules are applied to a bucket and all incoming requests to the bucket are evaluated against these rules. When set to Disabled, IP filtering rules are not applied to a bucket. Note: allow_all_service_agent_access must be supplied when mode is set to Enabled, it can be ommited for other values.
    vpcNetworkSources : [StorageGcpmUpboundIoV1beta1BucketStatusAtProviderIPFilterVpcNetworkSourcesItems0], default is Undefined, optional
        The list of VPC networks that can access the bucket. Structure is documented below.
    publicNetworkSource : StorageGcpmUpboundIoV1beta1BucketStatusAtProviderIPFilterPublicNetworkSource, default is Undefined, optional
        public network source
    """


    allowAllServiceAgentAccess?: bool

    allowCrossOrgVpcs?: bool

    mode?: str

    vpcNetworkSources?: [StorageGcpmUpboundIoV1beta1BucketStatusAtProviderIPFilterVpcNetworkSourcesItems0]

    publicNetworkSource?: StorageGcpmUpboundIoV1beta1BucketStatusAtProviderIPFilterPublicNetworkSource


schema StorageGcpmUpboundIoV1beta1BucketStatusAtProviderIPFilterPublicNetworkSource:
    r"""
    The public network IP address ranges that can access the bucket and its data. Structure is documented below.

    Attributes
    ----------
    allowedIpCidrRanges : [str], default is Undefined, optional
        The list of public or private IPv4 and IPv6 CIDR ranges that can access the bucket.
    """


    allowedIpCidrRanges?: [str]


schema StorageGcpmUpboundIoV1beta1BucketStatusAtProviderIPFilterVpcNetworkSourcesItems0:
    r"""
    storage gcpm upbound io v1beta1 bucket status at provider IP filter vpc network sources items0

    Attributes
    ----------
    allowedIpCidrRanges : [str], default is Undefined, optional
        The list of public or private IPv4 and IPv6 CIDR ranges that can access the bucket.
    network : str, default is Undefined, optional
        Name of the network. Format: projects/PROJECT_ID/global/networks/NETWORK_NAME
    """


    allowedIpCidrRanges?: [str]

    network?: str


schema StorageGcpmUpboundIoV1beta1BucketStatusAtProviderLifecycleRuleItems0:
    r"""
    storage gcpm upbound io v1beta1 bucket status at provider lifecycle rule items0

    Attributes
    ----------
    action : StorageGcpmUpboundIoV1beta1BucketStatusAtProviderLifecycleRuleItems0Action, default is Undefined, optional
        action
    condition : StorageGcpmUpboundIoV1beta1BucketStatusAtProviderLifecycleRuleItems0Condition, default is Undefined, optional
        condition
    """


    action?: StorageGcpmUpboundIoV1beta1BucketStatusAtProviderLifecycleRuleItems0Action

    condition?: StorageGcpmUpboundIoV1beta1BucketStatusAtProviderLifecycleRuleItems0Condition


schema StorageGcpmUpboundIoV1beta1BucketStatusAtProviderLifecycleRuleItems0Action:
    r"""
    The Lifecycle Rule's action configuration. A single block of this type is supported. Structure is documented below.

    Attributes
    ----------
    storageClass : str, default is Undefined, optional
        The Storage Class of the new bucket. Supported values include: STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE.
    $type : str, default is Undefined, optional
        The type of the action of this Lifecycle Rule. Supported values include: Delete, SetStorageClass and AbortIncompleteMultipartUpload.
    """


    storageClass?: str

    $type?: str


schema StorageGcpmUpboundIoV1beta1BucketStatusAtProviderLifecycleRuleItems0Condition:
    r"""
    The Lifecycle Rule's condition configuration. A single block of this type is supported. Structure is documented below.

    Attributes
    ----------
    age : float, default is Undefined, optional
        Minimum age of an object in days to satisfy this condition. Note To set 0 value of age, send_age_if_zero should be set true otherwise 0 value of age field will be ignored.
    createdBefore : str, default is Undefined, optional
        A date in the RFC 3339 format YYYY-MM-DD. This condition is satisfied when an object is created before midnight of the specified date in UTC.
    customTimeBefore : str, default is Undefined, optional
        A date in the RFC 3339 format YYYY-MM-DD. This condition is satisfied when the customTime metadata for the object is set to an earlier date than the date used in this lifecycle condition.
    daysSinceCustomTime : float, default is Undefined, optional
        Days since the date set in the customTime metadata for the object. This condition is satisfied when the current date and time is at least the specified number of days after the customTime. When set to 0 it will be ignored, and your state will treat it as though you supplied no days_since_custom_time condition.
    daysSinceNoncurrentTime : float, default is Undefined, optional
        Relevant only for versioned objects. Number of days elapsed since the noncurrent timestamp of an object. When set to 0 it will be ignored, and your state will treat it as though you supplied no days_since_noncurrent_time condition.
    matchesPrefix : [str], default is Undefined, optional
        One or more matching name prefixes to satisfy this condition.
    matchesStorageClass : [str], default is Undefined, optional
        Storage Class of objects to satisfy this condition. Supported values include: STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE, DURABLE_REDUCED_AVAILABILITY.
    matchesSuffix : [str], default is Undefined, optional
        One or more matching name suffixes to satisfy this condition.
    noncurrentTimeBefore : str, default is Undefined, optional
        Relevant only for versioned objects. The date in RFC 3339 (e.g. 2017-06-13) when the object became nonconcurrent. When set to 0 it will be ignored, and your state will treat it as though you supplied no noncurrent_time_before condition.
    numNewerVersions : float, default is Undefined, optional
        Relevant only for versioned objects. The number of newer versions of an object to satisfy this condition. When set to 0 it will be ignored and your state will treat it as though you supplied no num_newer_versions condition.
    sendAgeIfZero : bool, default is Undefined, optional
        While set true, age value will be sent in the request even for zero value of the field. This field is only useful and required for setting 0 value to the age field. It can be used alone or together with age attribute. NOTE age attibute with 0 value will be ommitted from the API request if send_age_if_zero field is having false value.
    sendDaysSinceCustomTimeIfZero : bool, default is Undefined, optional
        While set true, days_since_custom_time value will be sent in the request even for zero value of the field. This field is only useful for setting 0 value to the days_since_custom_time field. It can be used alone or together with days_since_custom_time.
    sendDaysSinceNoncurrentTimeIfZero : bool, default is Undefined, optional
        While set true, days_since_noncurrent_time value will be sent in the request even for zero value of the field. This field is only useful for setting 0 value to the days_since_noncurrent_time field. It can be used alone or together with days_since_noncurrent_time.
    sendNumNewerVersionsIfZero : bool, default is Undefined, optional
        While set true, num_newer_versions value will be sent in the request even for zero value of the field. This field is only useful for setting 0 value to the num_newer_versions field. It can be used alone or together with num_newer_versions.
    withState : str, default is Undefined, optional
        Match to live and/or archived objects. Unversioned buckets have only live objects. Supported values include: "LIVE", "ARCHIVED", "ANY".
    """


    age?: float

    createdBefore?: str

    customTimeBefore?: str

    daysSinceCustomTime?: float

    daysSinceNoncurrentTime?: float

    matchesPrefix?: [str]

    matchesStorageClass?: [str]

    matchesSuffix?: [str]

    noncurrentTimeBefore?: str

    numNewerVersions?: float

    sendAgeIfZero?: bool

    sendDaysSinceCustomTimeIfZero?: bool

    sendDaysSinceNoncurrentTimeIfZero?: bool

    sendNumNewerVersionsIfZero?: bool

    withState?: str


schema StorageGcpmUpboundIoV1beta1BucketStatusAtProviderLogging:
    r"""
    The bucket's Access & Storage Logs configuration. Structure is documented below.

    Attributes
    ----------
    logBucket : str, default is Undefined, optional
        The bucket that will receive log objects.
    logObjectPrefix : str, default is Undefined, optional
        The object prefix for log objects. If it's not provided,
        by default GCS sets this to this bucket's name.
    """


    logBucket?: str

    logObjectPrefix?: str


schema StorageGcpmUpboundIoV1beta1BucketStatusAtProviderRetentionPolicy:
    r"""
    Configuration of the bucket's data retention policy for how long objects in the bucket should be retained. Structure is documented below.

    Attributes
    ----------
    isLocked : bool, default is Undefined, optional
        If set to true, the bucket will be locked and permanently restrict edits to the bucket's retention policy.  Caution: Locking a bucket is an irreversible action.
    retentionPeriod : float, default is Undefined, optional
        The period of time, in seconds, that objects in the bucket must be retained and cannot be deleted, overwritten, or archived. The value must be less than 2,147,483,647 seconds.
    """


    isLocked?: bool

    retentionPeriod?: float


schema StorageGcpmUpboundIoV1beta1BucketStatusAtProviderSoftDeletePolicy:
    r"""
    The bucket's soft delete policy, which defines the period of time that soft-deleted objects will be retained, and cannot be permanently deleted. Structure is documented below.

    Attributes
    ----------
    effectiveTime : str, default is Undefined, optional
        (Computed) Server-determined value that indicates the time from which the policy, or one with a greater retention, was effective. This value is in RFC 3339 format.
    retentionDurationSeconds : float, default is Undefined, optional
        The duration in seconds that soft-deleted objects in the bucket will be retained and cannot be permanently deleted. Default value is 604800. The value must be in between 604800(7 days) and 7776000(90 days). Note: To disable the soft delete policy on a bucket, This field must be set to 0.
    """


    effectiveTime?: str

    retentionDurationSeconds?: float


schema StorageGcpmUpboundIoV1beta1BucketStatusAtProviderVersioning:
    r"""
    The bucket's Versioning configuration.  Structure is documented below.

    Attributes
    ----------
    enabled : bool, default is Undefined, optional
        While set to true, versioning is fully enabled for this bucket.
    """


    enabled?: bool


schema StorageGcpmUpboundIoV1beta1BucketStatusAtProviderWebsite:
    r"""
    Configuration if the bucket acts as a website. Structure is documented below.

    Attributes
    ----------
    mainPageSuffix : str, default is Undefined, optional
        Behaves as the bucket's directory index where
        missing objects are treated as potential directories.
    notFoundPage : str, default is Undefined, optional
        The custom object to return when a requested
        resource is not found.
    """


    mainPageSuffix?: str

    notFoundPage?: str


schema StorageGcpmUpboundIoV1beta1BucketStatusConditionsItems0:
    r"""
    A Condition that may apply to a resource.

    Attributes
    ----------
    lastTransitionTime : str, default is Undefined, required
        LastTransitionTime is the last time this condition transitioned from one
        status to another.
    message : str, default is Undefined, optional
        A Message containing details about this condition's last transition from
        one status to another, if any.
    observedGeneration : int, default is Undefined, optional
        ObservedGeneration represents the .metadata.generation that the condition was set based upon.
        For instance, if .metadata.generation is currently 12, but the .status.conditions[x].observedGeneration is 9, the condition is out of date
        with respect to the current state of the instance.
    reason : str, default is Undefined, required
        A Reason for this condition's last transition from one status to another.
    status : str, default is Undefined, required
        Status of this condition; is it currently True, False, or Unknown?
    $type : str, default is Undefined, required
        Type of this condition. At most one of each condition type may apply to
        a resource at any point in time.
    """


    lastTransitionTime: str

    message?: str

    observedGeneration?: int

    reason: str

    status: str

    $type: str






schema BucketIAMMember:
    r"""
    BucketIAMMember is the Schema for the BucketIAMMembers API. <no value>

    Attributes
    ----------
    apiVersion : str, default is "storage.gcp.m.upbound.io/v1beta1", required
        APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
    kind : str, default is "BucketIAMMember", required
        Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
    metadata : v1.ObjectMeta, default is Undefined, optional
        metadata
    spec : StorageGcpmUpboundIoV1beta1BucketIAMMemberSpec, default is Undefined, required
        spec
    status : StorageGcpmUpboundIoV1beta1BucketIAMMemberStatus, default is Undefined, optional
        status
    """


    apiVersion: "storage.gcp.m.upbound.io/v1beta1" = "storage.gcp.m.upbound.io/v1beta1"

    kind: "BucketIAMMember" = "BucketIAMMember"

    metadata?: v1.ObjectMeta

    spec: StorageGcpmUpboundIoV1beta1BucketIAMMemberSpec

    status?: StorageGcpmUpboundIoV1beta1BucketIAMMemberStatus


schema StorageGcpmUpboundIoV1beta1BucketIAMMemberSpec:
    r"""
    BucketIAMMemberSpec defines the desired state of BucketIAMMember

    Attributes
    ----------
    managementPolicies : [str], default is ["*"], optional
        THIS IS A BETA FIELD. It is on by default but can be opted out
        through a Crossplane feature flag.
        ManagementPolicies specify the array of actions Crossplane is allowed to
        take on the managed and external resources.
        See the design doc for more information: https://github.com/crossplane/crossplane/blob/499895a25d1a1a0ba1604944ef98ac7a1a71f197/design/design-doc-observe-only-resources.md?plain=1#L223
        and this one: https://github.com/crossplane/crossplane/blob/444267e84783136daa93568b364a5f01228cacbe/design/one-pager-ignore-changes.md
    forProvider : StorageGcpmUpboundIoV1beta1BucketIAMMemberSpecForProvider, default is Undefined, required
        for provider
    initProvider : StorageGcpmUpboundIoV1beta1BucketIAMMemberSpecInitProvider, default is Undefined, optional
        init provider
    providerConfigRef : StorageGcpmUpboundIoV1beta1BucketIAMMemberSpecProviderConfigRef, default is Undefined, optional
        provider config ref
    writeConnectionSecretToRef : StorageGcpmUpboundIoV1beta1BucketIAMMemberSpecWriteConnectionSecretToRef, default is Undefined, optional
        write connection secret to ref
    """


    managementPolicies?: [str] = ["*"]

    forProvider: StorageGcpmUpboundIoV1beta1BucketIAMMemberSpecForProvider

    initProvider?: StorageGcpmUpboundIoV1beta1BucketIAMMemberSpecInitProvider

    providerConfigRef?: StorageGcpmUpboundIoV1beta1BucketIAMMemberSpecProviderConfigRef

    writeConnectionSecretToRef?: StorageGcpmUpboundIoV1beta1BucketIAMMemberSpecWriteConnectionSecretToRef


schema StorageGcpmUpboundIoV1beta1BucketIAMMemberSpecForProvider:
    r"""
    storage gcpm upbound io v1beta1 bucket i a m member spec for provider

    Attributes
    ----------
    bucket : str, default is Undefined, optional
        bucket
    member : str, default is Undefined, optional
        member
    role : str, default is Undefined, optional
        role
    bucketRef : StorageGcpmUpboundIoV1beta1BucketIAMMemberSpecForProviderBucketRef, default is Undefined, optional
        bucket ref
    bucketSelector : StorageGcpmUpboundIoV1beta1BucketIAMMemberSpecForProviderBucketSelector, default is Undefined, optional
        bucket selector
    condition : StorageGcpmUpboundIoV1beta1BucketIAMMemberSpecForProviderCondition, default is Undefined, optional
        condition
    """


    bucket?: str

    member?: str

    role?: str

    bucketRef?: StorageGcpmUpboundIoV1beta1BucketIAMMemberSpecForProviderBucketRef

    bucketSelector?: StorageGcpmUpboundIoV1beta1BucketIAMMemberSpecForProviderBucketSelector

    condition?: StorageGcpmUpboundIoV1beta1BucketIAMMemberSpecForProviderCondition


schema StorageGcpmUpboundIoV1beta1BucketIAMMemberSpecForProviderBucketRef:
    r"""
    Reference to a Bucket in storage to populate bucket.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : StorageGcpmUpboundIoV1beta1BucketIAMMemberSpecForProviderBucketRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: StorageGcpmUpboundIoV1beta1BucketIAMMemberSpecForProviderBucketRefPolicy


schema StorageGcpmUpboundIoV1beta1BucketIAMMemberSpecForProviderBucketRefPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"


schema StorageGcpmUpboundIoV1beta1BucketIAMMemberSpecForProviderBucketSelector:
    r"""
    Selector for a Bucket in storage to populate bucket.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : StorageGcpmUpboundIoV1beta1BucketIAMMemberSpecForProviderBucketSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: StorageGcpmUpboundIoV1beta1BucketIAMMemberSpecForProviderBucketSelectorPolicy


schema StorageGcpmUpboundIoV1beta1BucketIAMMemberSpecForProviderBucketSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"


schema StorageGcpmUpboundIoV1beta1BucketIAMMemberSpecForProviderCondition:
    r"""
    storage gcpm upbound io v1beta1 bucket i a m member spec for provider condition

    Attributes
    ----------
    description : str, default is Undefined, optional
        description
    expression : str, default is Undefined, optional
        expression
    title : str, default is Undefined, optional
        title
    """


    description?: str

    expression?: str

    title?: str


schema StorageGcpmUpboundIoV1beta1BucketIAMMemberSpecInitProvider:
    r"""
    THIS IS A BETA FIELD. It will be honored
    unless the Management Policies feature flag is disabled.
    InitProvider holds the same fields as ForProvider, with the exception
    of Identifier and other resource reference fields. The fields that are
    in InitProvider are merged into ForProvider when the resource is created.
    The same fields are also added to the terraform ignore_changes hook, to
    avoid updating them after creation. This is useful for fields that are
    required on creation, but we do not desire to update them after creation,
    for example because of an external controller is managing them, like an
    autoscaler.

    Attributes
    ----------
    bucket : str, default is Undefined, optional
        bucket
    member : str, default is Undefined, optional
        member
    role : str, default is Undefined, optional
        role
    bucketRef : StorageGcpmUpboundIoV1beta1BucketIAMMemberSpecInitProviderBucketRef, default is Undefined, optional
        bucket ref
    bucketSelector : StorageGcpmUpboundIoV1beta1BucketIAMMemberSpecInitProviderBucketSelector, default is Undefined, optional
        bucket selector
    condition : StorageGcpmUpboundIoV1beta1BucketIAMMemberSpecInitProviderCondition, default is Undefined, optional
        condition
    """


    bucket?: str

    member?: str

    role?: str

    bucketRef?: StorageGcpmUpboundIoV1beta1BucketIAMMemberSpecInitProviderBucketRef

    bucketSelector?: StorageGcpmUpboundIoV1beta1BucketIAMMemberSpecInitProviderBucketSelector

    condition?: StorageGcpmUpboundIoV1beta1BucketIAMMemberSpecInitProviderCondition


schema StorageGcpmUpboundIoV1beta1BucketIAMMemberSpecInitProviderBucketRef:
    r"""
    Reference to a Bucket in storage to populate bucket.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object
    policy : StorageGcpmUpboundIoV1beta1BucketIAMMemberSpecInitProviderBucketRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    namespace?: str

    policy?: StorageGcpmUpboundIoV1beta1BucketIAMMemberSpecInitProviderBucketRefPolicy


schema StorageGcpmUpboundIoV1beta1BucketIAMMemberSpecInitProviderBucketRefPolicy:
    r"""
    Policies for referencing.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"


schema StorageGcpmUpboundIoV1beta1BucketIAMMemberSpecInitProviderBucketSelector:
    r"""
    Selector for a Bucket in storage to populate bucket.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    namespace : str, default is Undefined, optional
        Namespace for the selector
    policy : StorageGcpmUpboundIoV1beta1BucketIAMMemberSpecInitProviderBucketSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    namespace?: str

    policy?: StorageGcpmUpboundIoV1beta1BucketIAMMemberSpecInitProviderBucketSelectorPolicy


schema StorageGcpmUpboundIoV1beta1BucketIAMMemberSpecInitProviderBucketSelectorPolicy:
    r"""
    Policies for selection.

    Attributes
    ----------
    resolution : str, default is "Required", optional
        Resolution specifies whether resolution of this reference is required.
        The default is 'Required', which means the reconcile will fail if the
        reference cannot be resolved. 'Optional' means this reference will be
        a no-op if it cannot be resolved.
    resolve : str, default is Undefined, optional
        Resolve specifies when this reference should be resolved. The default
        is 'IfNotPresent', which will attempt to resolve the reference only when
        the corresponding field is not present. Use 'Always' to resolve the
        reference on every reconcile.
    """


    resolution?: "Required" | "Optional" = "Required"

    resolve?: "Always" | "IfNotPresent"


schema StorageGcpmUpboundIoV1beta1BucketIAMMemberSpecInitProviderCondition:
    r"""
    storage gcpm upbound io v1beta1 bucket i a m member spec init provider condition

    Attributes
    ----------
    description : str, default is Undefined, optional
        description
    expression : str, default is Undefined, optional
        expression
    title : str, default is Undefined, optional
        title
    """


    description?: str

    expression?: str

    title?: str


schema StorageGcpmUpboundIoV1beta1BucketIAMMemberSpecProviderConfigRef:
    r"""
    ProviderConfigReference specifies how the provider that will be used to
    create, observe, update, and delete this managed resource should be
    configured.

    Attributes
    ----------
    kind : str, default is Undefined, required
        Kind of the referenced object.
    name : str, default is Undefined, required
        Name of the referenced object.
    """


    kind: str

    name: str


schema StorageGcpmUpboundIoV1beta1BucketIAMMemberSpecWriteConnectionSecretToRef:
    r"""
    WriteConnectionSecretToReference specifies the namespace and name of a
    Secret to which any connection details for this managed resource should
    be written. Connection details frequently include the endpoint, username,
    and password required to connect to the managed resource.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the secret.
    """


    name: str


schema StorageGcpmUpboundIoV1beta1BucketIAMMemberStatus:
    r"""
    BucketIAMMemberStatus defines the observed state of BucketIAMMember.

    Attributes
    ----------
    conditions : [StorageGcpmUpboundIoV1beta1BucketIAMMemberStatusConditionsItems0], default is Undefined, optional
        Conditions of the resource.
    observedGeneration : int, default is Undefined, optional
        ObservedGeneration is the latest metadata.generation
        which resulted in either a ready state, or stalled due to error
        it can not recover from without human intervention.
    atProvider : StorageGcpmUpboundIoV1beta1BucketIAMMemberStatusAtProvider, default is Undefined, optional
        at provider
    """


    conditions?: [StorageGcpmUpboundIoV1beta1BucketIAMMemberStatusConditionsItems0]

    observedGeneration?: int

    atProvider?: StorageGcpmUpboundIoV1beta1BucketIAMMemberStatusAtProvider


schema StorageGcpmUpboundIoV1beta1BucketIAMMemberStatusAtProvider:
    r"""
    storage gcpm upbound io v1beta1 bucket i a m member status at provider

    Attributes
    ----------
    bucket : str, default is Undefined, optional
        bucket
    etag : str, default is Undefined, optional
        etag
    id : str, default is Undefined, optional
        id
    member : str, default is Undefined, optional
        member
    role : str, default is Undefined, optional
        role
    condition : StorageGcpmUpboundIoV1beta1BucketIAMMemberStatusAtProviderCondition, default is Undefined, optional
        condition
    """


    bucket?: str

    etag?: str

    id?: str

    member?: str

    role?: str

    condition?: StorageGcpmUpboundIoV1beta1BucketIAMMemberStatusAtProviderCondition


schema StorageGcpmUpboundIoV1beta1BucketIAMMemberStatusAtProviderCondition:
    r"""
    storage gcpm upbound io v1beta1 bucket i a m member status at provider condition

    Attributes
    ----------
    description : str, default is Undefined, optional
        description
    expression : str, default is Undefined, optional
        expression
    title : str, default is Undefined, optional
        title
    """


    description?: str

    expression?: str

    title?: str


schema StorageGcpmUpboundIoV1beta1BucketIAMMemberStatusConditionsItems0:
    r"""
    A Condition that may apply to a resource.

    Attributes
    ----------
    lastTransitionTime : str, default is Undefined, required
        LastTransitionTime is the last time this condition transitioned from one
        status to another.
    message : str, default is Undefined, optional
        A Message containing details about this condition's last transition from
        one status to another, if any.
    observedGeneration : int, default is Undefined, optional
        ObservedGeneration represents the .metadata.generation that the condition was set based upon.
        For instance, if .metadata.generation is currently 12, but the .status.conditions[x].observedGeneration is 9, the condition is out of date
        with respect to the current state of the instance.
    reason : str, default is Undefined, required
        A Reason for this condition's last transition from one status to another.
    status : str, default is Undefined, required
        Status of this condition; is it currently True, False, or Unknown?
    $type : str, default is Undefined, required
        Type of this condition. At most one of each condition type may apply to
        a resource at any point in time.
    """


    lastTransitionTime: str

    message?: str

    observedGeneration?: int

    reason: str

    status: str

    $type: str





schema ManagedFieldsEntry:
    r"""
    ManagedFieldsEntry is a workflow-id, a FieldSet and the group version of the resource that the fieldset applies to.

    Attributes
    ----------
    apiVersion : str, default is Undefined, optional
        APIVersion defines the version of this resource that this field set applies to. The format is "group/version" just like the top-level APIVersion field. It is necessary to track the version of a field set because it cannot be automatically converted.
    fieldsType : str, default is Undefined, optional
        FieldsType is the discriminator for the different fields format and version. There is currently only one possible value: "FieldsV1"
    fieldsV1 : any, default is Undefined, optional
        FieldsV1 holds the first JSON version format as described in the "FieldsV1" type.
    manager : str, default is Undefined, optional
        Manager is an identifier of the workflow managing these fields.
    operation : str, default is Undefined, optional
        Operation is the type of operation which lead to this ManagedFieldsEntry being created. The only valid values for this field are 'Apply' and 'Update'.
    time : str, default is Undefined, optional
        Time is timestamp of when these fields were set. It should always be empty if Operation is 'Apply'
    """


    apiVersion?: str

    fieldsType?: str

    fieldsV1?: any

    manager?: str

    operation?: str

    time?: str





schema ObjectMeta:
    r"""
    ObjectMeta is metadata that all persisted resources must have, which includes all objects users must create.

    Attributes
    ----------
    annotations : {str:str}, default is Undefined, optional
        Annotations is an unstructured key value map stored with a resource that may be set by external tools to store and retrieve arbitrary metadata. They are not queryable and should be preserved when modifying objects. More info: http://kubernetes.io/docs/user-guide/annotations
    clusterName : str, default is Undefined, optional
        The name of the cluster which the object belongs to. This is used to distinguish resources with same name and namespace in different clusters. This field is not set anywhere right now and apiserver is going to ignore it if set in create or update request.
    creationTimestamp : str, default is Undefined, optional
        CreationTimestamp is a timestamp representing the server time when this object was created. It is not guaranteed to be set in happens-before order across separate operations. Clients may not set this value. It is represented in RFC3339 form and is in UTC.

        Populated by the system. Read-only. Null for lists. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata
    deletionGracePeriodSeconds : int, default is Undefined, optional
        Number of seconds allowed for this object to gracefully terminate before it will be removed from the system. Only set when deletionTimestamp is also set. May only be shortened. Read-only.
    deletionTimestamp : str, default is Undefined, optional
        DeletionTimestamp is RFC 3339 date and time at which this resource will be deleted. This field is set by the server when a graceful deletion is requested by the user, and is not directly settable by a client. The resource is expected to be deleted (no longer visible from resource lists, and not reachable by name) after the time in this field, once the finalizers list is empty. As long as the finalizers list contains items, deletion is blocked. Once the deletionTimestamp is set, this value may not be unset or be set further into the future, although it may be shortened or the resource may be deleted prior to this time. For example, a user may request that a pod is deleted in 30 seconds. The Kubelet will react by sending a graceful termination signal to the containers in the pod. After that 30 seconds, the Kubelet will send a hard termination signal (SIGKILL) to the container and after cleanup, remove the pod from the API. In the presence of network partitions, this object may still exist after this timestamp, until an administrator or automated process can determine the resource is fully terminated. If not set, graceful deletion of the object has not been requested.

        Populated by the system when a graceful deletion is requested. Read-only. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata
    finalizers : [str], default is Undefined, optional
        Must be empty before the object is deleted from the registry. Each entry is an identifier for the responsible component that will remove the entry from the list. If the deletionTimestamp of the object is non-nil, entries in this list can only be removed. Finalizers may be processed and removed in any order.  Order is NOT enforced because it introduces significant risk of stuck finalizers. finalizers is a shared field, any actor with permission can reorder it. If the finalizer list is processed in order, then this can lead to a situation in which the component responsible for the first finalizer in the list is waiting for a signal (field value, external system, or other) produced by a component responsible for a finalizer later in the list, resulting in a deadlock. Without enforced ordering finalizers are free to order amongst themselves and are not vulnerable to ordering changes in the list.
    generateName : str, default is Undefined, optional
        GenerateName is an optional prefix, used by the server, to generate a unique name ONLY IF the Name field has not been provided. If this field is used, the name returned to the client will be different than the name passed. This value will also be combined with a unique suffix. The provided value has the same validation rules as the Name field, and may be truncated by the length of the suffix required to make the value unique on the server.

        If this field is specified and the generated name exists, the server will NOT return a 409 - instead, it will either return 201 Created or 500 with Reason ServerTimeout indicating a unique name could not be found in the time allotted, and the client should retry (optionally after the time indicated in the Retry-After header).

        Applied only if Name is not specified. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#idempotency
    generation : int, default is Undefined, optional
        A sequence number representing a specific generation of the desired state. Populated by the system. Read-only.
    labels : {str:str}, default is Undefined, optional
        Map of string keys and values that can be used to organize and categorize (scope and select) objects. May match selectors of replication controllers and services. More info: http://kubernetes.io/docs/user-guide/labels
    managedFields : [ManagedFieldsEntry], default is Undefined, optional
        ManagedFields maps workflow-id and version to the set of fields that are managed by that workflow. This is mostly for internal housekeeping, and users typically shouldn't need to set or understand this field. A workflow can be the user's name, a controller's name, or the name of a specific apply path like "ci-cd". The set of fields is always in the version that the workflow used when modifying the object.
    name : str, default is Undefined, optional
        Name must be unique within a namespace. Is required when creating resources, although some resources may allow a client to request the generation of an appropriate name automatically. Name is primarily intended for creation idempotence and configuration definition. Cannot be updated. More info: http://kubernetes.io/docs/user-guide/identifiers#names
    namespace : str, default is Undefined, optional
        Namespace defines the space within each name must be unique. An empty namespace is equivalent to the "default" namespace, but "default" is the canonical representation. Not all objects are required to be scoped to a namespace - the value of this field for those objects will be empty.

        Must be a DNS_LABEL. Cannot be updated. More info: http://kubernetes.io/docs/user-guide/namespaces
    ownerReferences : [OwnerReference], default is Undefined, optional
        List of objects depended by this object. If ALL objects in the list have been deleted, this object will be garbage collected. If this object is managed by a controller, then an entry in this list will point to this controller, with the controller field set to true. There cannot be more than one managing controller.
    resourceVersion : str, default is Undefined, optional
        An opaque value that represents the internal version of this object that can be used by clients to determine when objects have changed. May be used for optimistic concurrency, change detection, and the watch operation on a resource or set of resources. Clients must treat these values as opaque and passed unmodified back to the server. They may only be valid for a particular resource or set of resources.

        Populated by the system. Read-only. Value must be treated as opaque by clients and . More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#concurrency-control-and-consistency
    selfLink : str, default is Undefined, optional
        SelfLink is a URL representing this object. Populated by the system. Read-only.

        DEPRECATED Kubernetes will stop propagating this field in 1.20 release and the field is planned to be removed in 1.21 release.
    uid : str, default is Undefined, optional
        UID is the unique in time and space value for this object. It is typically generated by the server on successful creation of a resource and is not allowed to change on PUT operations.

        Populated by the system. Read-only. More info: http://kubernetes.io/docs/user-guide/identifiers#uids
    """


    annotations?: {str:str}

    clusterName?: str

    creationTimestamp?: str

    deletionGracePeriodSeconds?: int

    deletionTimestamp?: str

    finalizers?: [str]

    generateName?: str

    generation?: int

    labels?: {str:str}

    managedFields?: [ManagedFieldsEntry]

    name?: str

    namespace?: str

    ownerReferences?: [OwnerReference]

    resourceVersion?: str

    selfLink?: str

    uid?: str





schema OwnerReference:
    r"""
    OwnerReference contains enough information to let you identify an owning object. An owning object must be in the same namespace as the dependent, or be cluster-scoped, so there is no namespace field.

    Attributes
    ----------
    apiVersion : str, default is Undefined, required
        API version of the referent.
    blockOwnerDeletion : bool, default is Undefined, optional
        If true, AND if the owner has the "foregroundDeletion" finalizer, then the owner cannot be deleted from the key-value store until this reference is removed. Defaults to false. To set this field, a user needs "delete" permission of the owner, otherwise 422 (Unprocessable Entity) will be returned.
    controller : bool, default is Undefined, optional
        If true, this reference points to the managing controller.
    kind : str, default is Undefined, required
        Kind of the referent. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
    name : str, default is Undefined, required
        Name of the referent. More info: http://kubernetes.io/docs/user-guide/identifiers#names
    uid : str, default is Undefined, required
        UID of the referent. More info: http://kubernetes.io/docs/user-guide/identifiers#uids
    """


    apiVersion: str

    blockOwnerDeletion?: bool

    controller?: bool

    kind: str

    name: str

    uid: str






schema Object:
    r"""
    A Object is an provider Kubernetes API type

    Attributes
    ----------
    apiVersion : str, default is "kubernetes.m.crossplane.io/v1alpha1", required
        APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
    kind : str, default is "Object", required
        Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
    metadata : v1.ObjectMeta, default is Undefined, optional
        metadata
    spec : KubernetesmCrossplaneIoV1alpha1ObjectSpec, default is Undefined, required
        spec
    status : KubernetesmCrossplaneIoV1alpha1ObjectStatus, default is Undefined, optional
        status
    """


    apiVersion: "kubernetes.m.crossplane.io/v1alpha1" = "kubernetes.m.crossplane.io/v1alpha1"

    kind: "Object" = "Object"

    metadata?: v1.ObjectMeta

    spec: KubernetesmCrossplaneIoV1alpha1ObjectSpec

    status?: KubernetesmCrossplaneIoV1alpha1ObjectStatus


schema KubernetesmCrossplaneIoV1alpha1ObjectSpec:
    r"""
    A ObjectSpec defines the desired state of a Object.

    Attributes
    ----------
    connectionDetails : [KubernetesmCrossplaneIoV1alpha1ObjectSpecConnectionDetailsItems0], default is Undefined, optional
        connection details
    managementPolicies : [str], default is ["*"], optional
        THIS IS A BETA FIELD. It is on by default but can be opted out
        through a Crossplane feature flag.
        ManagementPolicies specify the array of actions Crossplane is allowed to
        take on the managed and external resources.
        See the design doc for more information: https://github.com/crossplane/crossplane/blob/499895a25d1a1a0ba1604944ef98ac7a1a71f197/design/design-doc-observe-only-resources.md?plain=1#L223
        and this one: https://github.com/crossplane/crossplane/blob/444267e84783136daa93568b364a5f01228cacbe/design/one-pager-ignore-changes.md
    references : [KubernetesmCrossplaneIoV1alpha1ObjectSpecReferencesItems0], default is Undefined, optional
        references
    watch : bool, default is Undefined, optional
        Watch enables watching the referenced or managed kubernetes resources.

        THIS IS AN ALPHA FIELD. Do not use it in production. It is not honored
        unless "watches" feature gate is enabled, and may be changed or removed
        without notice.
    forProvider : KubernetesmCrossplaneIoV1alpha1ObjectSpecForProvider, default is Undefined, required
        for provider
    providerConfigRef : KubernetesmCrossplaneIoV1alpha1ObjectSpecProviderConfigRef, default is Undefined, optional
        provider config ref
    readiness : KubernetesmCrossplaneIoV1alpha1ObjectSpecReadiness, default is Undefined, optional
        readiness
    writeConnectionSecretToRef : KubernetesmCrossplaneIoV1alpha1ObjectSpecWriteConnectionSecretToRef, default is Undefined, optional
        write connection secret to ref
    """


    connectionDetails?: [KubernetesmCrossplaneIoV1alpha1ObjectSpecConnectionDetailsItems0]

    managementPolicies?: [str] = ["*"]

    references?: [KubernetesmCrossplaneIoV1alpha1ObjectSpecReferencesItems0]

    watch?: bool = False

    forProvider: KubernetesmCrossplaneIoV1alpha1ObjectSpecForProvider

    providerConfigRef?: KubernetesmCrossplaneIoV1alpha1ObjectSpecProviderConfigRef

    readiness?: KubernetesmCrossplaneIoV1alpha1ObjectSpecReadiness

    writeConnectionSecretToRef?: KubernetesmCrossplaneIoV1alpha1ObjectSpecWriteConnectionSecretToRef


schema KubernetesmCrossplaneIoV1alpha1ObjectSpecConnectionDetailsItems0:
    r"""
    ConnectionDetail represents an entry in the connection secret for an Object

    Attributes
    ----------
    apiVersion : str, default is Undefined, optional
        API version of the referent.
    fieldPath : str, default is Undefined, optional
        If referring to a piece of an object instead of an entire object, this string
        should contain a valid JSON/Go field access statement, such as desiredState.manifest.containers[2].
        For example, if the object reference is to a container within a pod, this would take on a value like:
        "spec.containers{name}" (where "name" refers to the name of the container that triggered
        the event) or if no container name is specified "spec.containers[2]" (container with
        index 2 in this pod). This syntax is chosen only to have some well-defined way of
        referencing a part of an object.
    kind : str, default is Undefined, optional
        Kind of the referent.
        More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
    name : str, default is Undefined, optional
        Name of the referent.
        More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
    namespace : str, default is Undefined, optional
        Namespace of the referent.
        More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/
    resourceVersion : str, default is Undefined, optional
        Specific resourceVersion to which this reference is made, if any.
        More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#concurrency-control-and-consistency
    toConnectionSecretKey : str, default is Undefined, optional
        to connection secret key
    uid : str, default is Undefined, optional
        UID of the referent.
        More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#uids
    """


    apiVersion?: str

    fieldPath?: str

    kind?: str

    name?: str

    namespace?: str

    resourceVersion?: str

    toConnectionSecretKey?: str

    uid?: str


schema KubernetesmCrossplaneIoV1alpha1ObjectSpecForProvider:
    r"""
    ObjectParameters are the configurable fields of a Object.

    Attributes
    ----------
    manifest : any, default is Undefined, required
        Raw JSON representation of the kubernetes object to be created.
    """


    manifest: any


schema KubernetesmCrossplaneIoV1alpha1ObjectSpecProviderConfigRef:
    r"""
    ProviderConfigReference specifies how the provider that will be used to
    create, observe, update, and delete this managed resource should be
    configured.

    Attributes
    ----------
    kind : str, default is Undefined, required
        Kind of the referenced object.
    name : str, default is Undefined, required
        Name of the referenced object.
    """


    kind: str

    name: str


schema KubernetesmCrossplaneIoV1alpha1ObjectSpecReadiness:
    r"""
    Readiness defines how the object's readiness condition should be computed,
    if not specified it will be considered ready as soon as the underlying external
    resource is considered up-to-date.

    Attributes
    ----------
    celQuery : str, default is Undefined, optional
        CelQuery defines a cel query to evaluate the readiness. The
        observed object is passed to the cel query with the word `object`.
        Cel macros are available to be used, see https://github.com/google/cel-spec/blob/master/doc/langdef.md#macros
        for more information.
        Examples:
         `object.status.isReady == true`: checks for a boolean field called isReady on status.
         `object.status.conditions.all(x, x.status == "True")` mimics the behavior of the AllTrue readiness policy
         `object.status.conditions.exists(c, c.type == "condition1" && c.status == "True" )` checks just one condition
    policy : str, default is "SuccessfulCreate", optional
        Policy defines how the Object's readiness condition should be computed.
    """


    celQuery?: str

    policy?: "SuccessfulCreate" | "DeriveFromObject" | "AllTrue" | "DeriveFromCelQuery" = "SuccessfulCreate"


schema KubernetesmCrossplaneIoV1alpha1ObjectSpecReferencesItems0:
    r"""
    Reference refers to an Object or arbitrary Kubernetes resource and optionally
    patch values from that resource to the current Object.

    Attributes
    ----------
    dependsOn : KubernetesmCrossplaneIoV1alpha1ObjectSpecReferencesItems0DependsOn, default is Undefined, optional
        depends on
    patchesFrom : KubernetesmCrossplaneIoV1alpha1ObjectSpecReferencesItems0PatchesFrom, default is Undefined, optional
        patches from
    toFieldPath : str, default is Undefined, optional
        ToFieldPath is the path of the field on the resource whose value will
        be changed with the result of transforms. Leave empty if you'd like to
        propagate to the same path as patchesFrom.fieldPath.
    """


    dependsOn?: KubernetesmCrossplaneIoV1alpha1ObjectSpecReferencesItems0DependsOn

    patchesFrom?: KubernetesmCrossplaneIoV1alpha1ObjectSpecReferencesItems0PatchesFrom

    toFieldPath?: str


schema KubernetesmCrossplaneIoV1alpha1ObjectSpecReferencesItems0DependsOn:
    r"""
    DependsOn is used to declare dependency on other Object or arbitrary
    Kubernetes resource.

    Attributes
    ----------
    apiVersion : str, default is "kubernetes.m.crossplane.io/v1alpha1", optional
        APIVersion of the referenced object.
    kind : str, default is "Object", optional
        Kind of the referenced object.
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object.
    """


    apiVersion?: str = "kubernetes.m.crossplane.io/v1alpha1"

    kind?: str = "Object"

    name: str

    namespace?: str


schema KubernetesmCrossplaneIoV1alpha1ObjectSpecReferencesItems0PatchesFrom:
    r"""
    PatchesFrom is used to declare dependency on other Object or arbitrary
    Kubernetes resource, and also patch fields from this object.

    Attributes
    ----------
    apiVersion : str, default is "kubernetes.m.crossplane.io/v1alpha1", optional
        APIVersion of the referenced object.
    fieldPath : str, default is Undefined, required
        FieldPath is the path of the field on the resource whose value is to be
        used as input.
    kind : str, default is "Object", optional
        Kind of the referenced object.
    name : str, default is Undefined, required
        Name of the referenced object.
    namespace : str, default is Undefined, optional
        Namespace of the referenced object.
    """


    apiVersion?: str = "kubernetes.m.crossplane.io/v1alpha1"

    fieldPath: str

    kind?: str = "Object"

    name: str

    namespace?: str


schema KubernetesmCrossplaneIoV1alpha1ObjectSpecWriteConnectionSecretToRef:
    r"""
    WriteConnectionSecretToReference specifies the namespace and name of a
    Secret to which any connection details for this managed resource should
    be written. Connection details frequently include the endpoint, username,
    and password required to connect to the managed resource.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the secret.
    """


    name: str


schema KubernetesmCrossplaneIoV1alpha1ObjectStatus:
    r"""
    A ObjectStatus represents the observed state of a Object.

    Attributes
    ----------
    conditions : [KubernetesmCrossplaneIoV1alpha1ObjectStatusConditionsItems0], default is Undefined, optional
        Conditions of the resource.
    observedGeneration : int, default is Undefined, optional
        ObservedGeneration is the latest metadata.generation
        which resulted in either a ready state, or stalled due to error
        it can not recover from without human intervention.
    atProvider : KubernetesmCrossplaneIoV1alpha1ObjectStatusAtProvider, default is Undefined, optional
        at provider
    """


    conditions?: [KubernetesmCrossplaneIoV1alpha1ObjectStatusConditionsItems0]

    observedGeneration?: int

    atProvider?: KubernetesmCrossplaneIoV1alpha1ObjectStatusAtProvider


schema KubernetesmCrossplaneIoV1alpha1ObjectStatusAtProvider:
    r"""
    ObjectObservation are the observable fields of a Object.

    Attributes
    ----------
    manifest : any, default is Undefined, optional
        Raw JSON representation of the remote object.
    """


    manifest?: any


schema KubernetesmCrossplaneIoV1alpha1ObjectStatusConditionsItems0:
    r"""
    A Condition that may apply to a resource.

    Attributes
    ----------
    lastTransitionTime : str, default is Undefined, required
        LastTransitionTime is the last time this condition transitioned from one
        status to another.
    message : str, default is Undefined, optional
        A Message containing details about this condition's last transition from
        one status to another, if any.
    observedGeneration : int, default is Undefined, optional
        ObservedGeneration represents the .metadata.generation that the condition was set based upon.
        For instance, if .metadata.generation is currently 12, but the .status.conditions[x].observedGeneration is 9, the condition is out of date
        with respect to the current state of the instance.
    reason : str, default is Undefined, required
        A Reason for this condition's last transition from one status to another.
    status : str, default is Undefined, required
        Status of this condition; is it currently True, False, or Unknown?
    $type : str, default is Undefined, required
        Type of this condition. At most one of each condition type may apply to
        a resource at any point in time.
    """


    lastTransitionTime: str

    message?: str

    observedGeneration?: int

    reason: str

    status: str

    $type: str






# --- CONTEXT ---


params = option("params") or {}
ctx = params["ctx"] if "ctx" in params else {}
obs = params["obs"] if "obs" in params else {
    "resources": {}
}
oxr = params["oxr"] if "oxr" in params else {}

env = ctx["apiextensions.crossplane.io/environment"] if "apiextensions.crossplane.io/environment" in ctx else {}
metadata = oxr["metadata"] if "metadata" in oxr else {}
spec = oxr["spec"] if "spec" in oxr else {}

_cmk_spec = spec["cmk"] if "cmk" in spec else {}
backup = spec["backup"] if "backup" in spec else {}
cmkEnabled = _cmk_spec["enabled"] if "enabled" in _cmk_spec else False
databaseSpec = spec["database"] if "database" in spec else {}
environmentId = spec["environmentId"] if "environmentId" in spec else ""
forceDestroy = spec["forceDestroy"] if "forceDestroy" in spec else False
namespace = metadata["namespace"] if "namespace" in metadata else ""
overlay = spec["overlay"] if "overlay" in spec else {}
overlayEnabled = overlay["enabled"] if "enabled" in overlay else False
projectId = spec["projectId"] if "projectId" in spec else ""
region = databaseSpec["region"] if "region" in databaseSpec else (spec["region"] if "region" in spec else "")
storage_spec = spec["storage"] if "storage" in spec else {}

projectIdFull = "{}-{}".format(projectId, environmentId)
uidHash = crypto.sha256("{}-{}".format(env["projectNumber"] if "projectNumber" in env else "", projectIdFull))[:6:]

baseName = "{}-{}".format(projectIdFull[:18:], uidHash)
cmkKeyName = "projects/{}/locations/{}/keyRings/{}-keyring/cryptoKeys/{}-key".format(env["projectId"] if "projectId" in env else "", region, baseName, baseName)
databaseIamUser = "{}@{}.iam".format("{}-sa".format(baseName), env["projectId"] if "projectId" in env else "")
databaseInstanceName = "{}-db-instance".format(baseName)
databaseObjectName = "{}-db".format(baseName)
databaseUserObjectName = "{}-db-user".format(baseName)
databaseName = databaseSpec["name"] if "name" in databaseSpec else "lportal"
databasePort = "5432"
gsaEmail = "{}@{}.iam.gserviceaccount.com".format("{}-sa".format(baseName), env["projectId"] if "projectId" in env else "")
gsaName = "{}-sa".format(baseName)
instanceConnectionName = "{}:{}:{}".format(env["projectId"] if "projectId" in env else "", region, databaseInstanceName)
jobName = "{}-db-grant".format(baseName)
searchName = "{}-es".format(baseName)
searchNamespace = "{}-elasticsearch".format(namespace)
searchSecretName = "{}-es-elastic-user".format(searchName)

labels = {
    "app": "liferay"
    "deployment-name": env["deploymentName"] if "deploymentName" in env else ""
    "environment-id": environmentId
    "project-id": projectId
}
if "commonTags" in spec and spec["commonTags"]:
    labels.update(spec["commonTags"])

backupTargetLabels = {**labels, "active": "true", "should-back-up": "true"}
orphan = spec["orphanOnDelete"] if "orphanOnDelete" in spec else False
managementPolicies = ["Create", "Observe", "Update"] if orphan else ["*"]
managementPolicy = "ObserveCreateUpdate" if orphan else "Default"
managementPoliciesNoUpdate = ["Create", "Observe"] if orphan else ["Create", "Delete", "Observe"]
managementPoliciesOnce = ["Create", "Observe", "Delete"]


schema init_layer:


    get_items = lambda obs: any, vars: {str:any} -> [any] {
        _items: [any] = []
        _items
    }

    _vars = {
        "labels": labels
        "managementPolicies": managementPolicies
        "metadata": metadata
        "namespace": namespace
        "projectId": projectId
        "region": region
    }

    _res = obs?.resources or {}
    _status = _res?["managed-service-details-configmap"]?.resource?.status?.atProvider?.manifest?.status or {}
    _conditions = _status?.conditions or []
    _is_ready_ctx = any c in _conditions {c.type == "Ready" and c.status == "True"}

    items: {str:any} = {
        "items": get_items(obs, _vars)
        "status": {"managedServiceDetailsReady": _is_ready_ctx}
    }


_init = init_layer {}
items_init = _init.items

schema security_layer:








    get_items = lambda obs: any, vars: {str:any} -> [any] {
        _env = vars["env"] if "env" in vars else {}
        _labels = vars["labels"] if "labels" in vars else {}
        _gsaName = str(vars["gsaName"] if "gsaName" in vars else "")
        _gsaEmail = str(vars["gsaEmail"] if "gsaEmail" in vars else "")
        _baseName = str(vars["baseName"] if "baseName" in vars else "")
        _projectId = str(_env["projectId"] if "projectId" in _env else "")
        _namespace = str(vars["namespace"] if "namespace" in vars else "")
        _managementPolicies = vars["managementPolicies"] if "managementPolicies" in vars else ["*"]

        _security_items: [any] = [
            ServiceAccount {
                apiVersion = "cloudplatform.gcp.m.upbound.io/v1beta1"
                kind = "ServiceAccount"
                metadata = {
                    annotations = {"crossplane.io/composition-resource-name": "liferay-gsa"}
                    labels = _labels
                    name = _gsaName
                }
                spec = {
                    forProvider = {
                        displayName = "Liferay {} Service Account".format(_gsaName)
                    }
                    managementPolicies = _managementPolicies
                }
            },
            ServiceAccountIAMMember {
                apiVersion = "cloudplatform.gcp.m.upbound.io/v1beta1"
                kind = "ServiceAccountIAMMember"
                metadata = {
                    annotations = {"crossplane.io/composition-resource-name": "liferay-wi-binding"}
                    labels = _labels
                }
                spec = {
                    forProvider = {
                        member = "serviceAccount:{}.svc.id.goog[{}/liferay-default]".format(_projectId, _namespace)
                        role = "roles/iam.workloadIdentityUser"
                        serviceAccountIdRef = {
                            name = _gsaName
                        }
                    }
                    managementPolicies = _managementPolicies
                }
            }
        ]

        _security_items += [ProjectIAMMember {
                apiVersion = "cloudplatform.gcp.m.upbound.io/v1beta1"
                kind = "ProjectIAMMember"
            metadata = {
                annotations = {"crossplane.io/composition-resource-name": "liferay-sql-instance-user-role"}
                labels = _labels
            }
            spec = {
                forProvider = {
                    member = "serviceAccount:{}".format(_gsaEmail)
                    project = _projectId
                    role = "roles/cloudsql.instanceUser"
                }
                managementPolicies = _managementPolicies
            }
        }]

        _security_items += [ProjectIAMMember {
                apiVersion = "cloudplatform.gcp.m.upbound.io/v1beta1"
                kind = "ProjectIAMMember"
            metadata = {
                annotations = {"crossplane.io/composition-resource-name": "liferay-sql-client-role"}
                labels = _labels
            }
            spec = {
                forProvider = {
                    member = "serviceAccount:{}".format(_gsaEmail)
                    project = _projectId
                    role = "roles/cloudsql.client"
                }
                managementPolicies = _managementPolicies
            }
        }]

        if bool(vars["cmkEnabled"] if "cmkEnabled" in vars else False):
            _security_items += [
                KeyRing {
                apiVersion = "kms.gcp.m.upbound.io/v1beta1"
                kind = "KeyRing"
                    metadata = {
                        annotations = {"crossplane.io/composition-resource-name": "liferay-keyring"}
                        labels = _labels
                        name = "{}-keyring".format(_baseName)
                    }
                    spec = {
                        forProvider = {"location": str(vars["region"] if "region" in vars else "")}
                        managementPolicies = _managementPolicies
                    }
                },
                CryptoKey {
                apiVersion = "kms.gcp.m.upbound.io/v1beta1"
                kind = "CryptoKey"
                    metadata = {
                        annotations = {"crossplane.io/composition-resource-name": "liferay-cryptokey"}
                        labels = _labels
                        name = "{}-key".format(_baseName)
                    }
                    spec = {
                        forProvider = {
                            keyRingSelector = {"matchControllerRef": True}
                            purpose = "ENCRYPT_DECRYPT"
                            rotationPeriod = "86400s"
                        }
                        managementPolicies = _managementPolicies
                    }
                }
            ]

            _kms_targets = [
                {"name": "sql", "svc": "gcp-sa-cloud-sql"}
                {"name": "storage", "svc": "gs-project-accounts"}
            ]
            _security_items += [CryptoKeyIAMMember {
                apiVersion = "kms.gcp.m.upbound.io/v1beta1"
                kind = "CryptoKeyIAMMember"
                metadata = {
                    annotations = {"crossplane.io/composition-resource-name": "liferay-{}-kms-binding".format(t["name"])}
                    labels = _labels
                }
                spec = {
                    forProvider = {
                        cryptoKeyIdRef = {"name": "{}-key".format(_baseName)}
                        member = "serviceAccount:service-{}@{}.iam.gserviceaccount.com".format(str(_env["projectNumber"] if "projectNumber" in _env else ""), t["svc"])
                        role = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
                    }
                    managementPolicies = _managementPolicies
                }
            } for t in _kms_targets]

        _security_items
    }

    _vars = {
        "baseName": baseName
        "cmkEnabled": cmkEnabled
        "cmkKeyName": cmkKeyName
        "env": env
        "gsaEmail": gsaEmail
        "gsaName": gsaName
        "labels": labels
        "managementPolicies": managementPolicies
        "namespace": namespace
        "region": region
    }

    items: {str:any} = {"items": get_items(obs, _vars)}


_security = security_layer {}
items_security = _security.items

schema sql_layer:





    _get_items_impl = lambda obs: any, vars: {str:any} -> [any] {
        _db_spec = vars["database"] if "database" in vars else {}
        _env = vars["env"] if "env" in vars else {}
        _labels = vars["labels"] if "labels" in vars else {}
        _managementPolicies = vars["managementPolicies"] if "managementPolicies" in vars else ["*"]

        _items: [any] = [
            DatabaseInstance {
                apiVersion = "sql.gcp.m.upbound.io/v1beta1"
                kind = "DatabaseInstance"
                metadata = {
                    annotations = {"crossplane.io/composition-resource-name": "database-primary"}
                    labels = _labels
                    name = str(vars["databaseInstanceName"] if "databaseInstanceName" in vars else "")
                }
                spec = {
                    forProvider = {
                        databaseVersion = str(_db_spec["databaseVersion"] if "databaseVersion" in _db_spec else "POSTGRES_18")
                        deletionProtection = bool(_db_spec["deletionProtection"] if "deletionProtection" in _db_spec else False)
                        region = str(vars["region"] if "region" in vars else "")
                        rootPasswordSecretRef = {
                            key = "password"
                            name = str(_db_spec["rootPasswordSecretName"] if "rootPasswordSecretName" in _db_spec else "placeholder")
                        
                        }
                        settings = {
                            databaseFlags = [{"name": "cloudsql.iam_authentication", "value": "on"}]
                            diskSize = int(_db_spec["storageGB"] if "storageGB" in _db_spec else 10)
                            diskType = "PD_SSD"
                            edition = "ENTERPRISE"
                            insightsConfig = {
                                queryInsightsEnabled = bool(_db_spec["queryInsightsEnabled"] if "queryInsightsEnabled" in _db_spec else True)
                            }
                            ipConfiguration = {
                                ipv4Enabled = False
                                privateNetwork = "projects/{}/global/networks/{}".format(str(vars["projectId"] if "projectId" in vars else ""), str(_env["vpcName"] if "vpcName" in _env else ""))
                                sslMode = "TRUSTED_CLIENT_CERTIFICATE_REQUIRED"
                            }
                            tier = str(_db_spec["instanceType"] if "instanceType" in _db_spec else "db-custom-1-3840")
                            userLabels = _labels | {"active": "true", "should-back-up": "true"}
                        }
                    }
                    managementPolicies = _managementPolicies
                }
            }
            Database {
                apiVersion = "sql.gcp.m.upbound.io/v1beta1"
                kind = "Database"
                metadata = {
                    annotations = {
                        "crossplane.io/composition-resource-name": "liferay-db"
                        "crossplane.io/external-name": str(vars["databaseName"] if "databaseName" in vars else "lportal")
                    }
                    labels = _labels
                    name = str(vars["databaseObjectName"] if "databaseObjectName" in vars else "{}-db".format(str(vars["baseName"] if "baseName" in vars else "")))
                }
                spec = {
                    forProvider = {
                        instanceRef = {
                            name = str(vars["databaseInstanceName"] if "databaseInstanceName" in vars else "")
                        }
                        project = str(vars["projectId"] if "projectId" in vars else "")
                    }
                    managementPolicies = _managementPolicies
                }
            }
            User {
                apiVersion = "sql.gcp.m.upbound.io/v1beta1"
                kind = "User"
                metadata = {
                    annotations = {
                        "crossplane.io/composition-resource-name": "liferay-iam-user"
                        "crossplane.io/external-name": str(vars["databaseIamUser"] if "databaseIamUser" in vars else "")
                    }
                    labels = _labels
                    name = str(vars["databaseUserObjectName"] if "databaseUserObjectName" in vars else "{}-db-user".format(str(vars["baseName"] if "baseName" in vars else "")))
                }
                spec = {
                    forProvider = {
                        instanceRef = {
                            name = str(vars["databaseInstanceName"] if "databaseInstanceName" in vars else "")
                        }
                        project = str(vars["projectId"] if "projectId" in vars else "")
                        $type = "CLOUD_IAM_SERVICE_ACCOUNT"
                    }
                    managementPolicies = _managementPolicies
                }
            }
            {
                apiVersion = "protection.crossplane.io/v1beta1"
                kind = "Usage"
                metadata = {
                    annotations = {"crossplane.io/composition-resource-name": "usage-instance-by-database"}
                    name = "{}-instance-by-database".format(str(vars["baseName"] if "baseName" in vars else ""))
                }
                spec = {
                    of = {
                        apiVersion = "sql.gcp.m.upbound.io/v1beta1"
                        kind = "DatabaseInstance"
                        resourceRef = {name = str(vars["databaseInstanceName"] if "databaseInstanceName" in vars else "")}
                    }
                    by = {
                        apiVersion = "sql.gcp.m.upbound.io/v1beta1"
                        kind = "Database"
                        resourceRef = {name = str(vars["databaseObjectName"] if "databaseObjectName" in vars else "{}-db".format(str(vars["baseName"] if "baseName" in vars else "")))}
                    }
                }
            }
            {
                apiVersion = "protection.crossplane.io/v1beta1"
                kind = "Usage"
                metadata = {
                    annotations = {"crossplane.io/composition-resource-name": "usage-instance-by-user"}
                    name = "{}-instance-by-user".format(str(vars["baseName"] if "baseName" in vars else ""))
                }
                spec = {
                    of = {
                        apiVersion = "sql.gcp.m.upbound.io/v1beta1"
                        kind = "DatabaseInstance"
                        resourceRef = {name = str(vars["databaseInstanceName"] if "databaseInstanceName" in vars else "")}
                    }
                    by = {
                        apiVersion = "sql.gcp.m.upbound.io/v1beta1"
                        kind = "User"
                        resourceRef = {name = str(vars["databaseUserObjectName"] if "databaseUserObjectName" in vars else "{}-db-user".format(str(vars["baseName"] if "baseName" in vars else "")))}
                    }
                }
            }
        ]

        _items
    }

    get_items = _get_items_impl

    _vars = {
        "baseName": baseName
        "database": databaseSpec
        "databaseIamUser": databaseIamUser
        "databaseInstanceName": databaseInstanceName
        "databaseName": databaseName
        "databaseObjectName": databaseObjectName
        "databaseUserObjectName": databaseUserObjectName
        "env": env
        "labels": labels
        "managementPolicies": managementPolicies
        "projectId": env["projectId"] if "projectId" in env else ""
        "region": region
    }

    items: {str:any} = {"items": get_items(obs, _vars)}


_sql = sql_layer {}
items_sql = _sql.items

schema storage_layer:




    get_items = lambda obs: any, vars: {str:any} -> [any] {
        _storage_spec = vars["storage_spec"] if "storage_spec" in vars else {}
        _labels = vars["labels"] if "labels" in vars else {}
        _baseName = vars["baseName"] if "baseName" in vars else ""
        _bucket_name = str(vars["bucketName"] if "bucketName" in vars else "{}-dl".format(_baseName))
        _managementPolicies = vars["managementPolicies"] if "managementPolicies" in vars else ["*"]

        _items: [any] = [
            Bucket {
                apiVersion = "storage.gcp.m.upbound.io/v1beta1"
                kind = "Bucket"
                metadata = {
                    annotations = {"crossplane.io/composition-resource-name": "liferay-gcs-bucket"}
                    labels = _labels
                    name = _bucket_name
                }
                spec = {
                    forProvider = {
                        forceDestroy = bool(vars["forceDestroy"] if "forceDestroy" in vars else False)
                        labels = _labels | {"active": "true", "should-back-up": "true"}
                        location = str(vars["region"] if "region" in vars else "")
                        storageClass = str(_storage_spec["storageClass"] if "storageClass" in _storage_spec else "STANDARD")
                        uniformBucketLevelAccess = True
                        versioning = {enabled = bool(_storage_spec["enableVersioning"] if "enableVersioning" in _storage_spec else True)}
                    }
                    if vars["cmkEnabled"] if "cmkEnabled" in vars else False:
                        forProvider.encryption = {
                            defaultKmsKeyName = str(vars["cmkKeyName"] if "cmkKeyName" in vars else "")
                        }
                    managementPolicies = _managementPolicies
                }
            },
            BucketIAMMember {
                apiVersion = "storage.gcp.m.upbound.io/v1beta1"
                kind = "BucketIAMMember"
                metadata = {
                    annotations = {"crossplane.io/composition-resource-name": "liferay-gcs-iam"}
                    labels = _labels
                }
                spec = {
                    forProvider = {
                        member = "serviceAccount:{}".format(str(vars["gsaEmail"] if "gsaEmail" in vars else ""))
                        role = "roles/storage.admin"
                        bucketRef = {
                            name = _bucket_name
                        }
                    }
                    managementPolicies = _managementPolicies
                }
            }
        ]

        _items
    }

    _vars = {
        "baseName": baseName
        "cmkEnabled": cmkEnabled
        "cmkKeyName": cmkKeyName
        "forceDestroy": forceDestroy
        "gsaEmail": gsaEmail
        "labels": labels
        "managementPolicies": managementPolicies
        "region": region
        "storage_spec": storage_spec
    }

    items: {str:any} = {"items": get_items(obs, _vars)}


_storage = storage_layer {}
items_storage = _storage.items

schema overlay_layer:





    get_items = lambda obs: any, vars: {str:any} -> [any] {
        _labels = vars["labels"] if "labels" in vars else {}
        _baseName = vars["baseName"] if "baseName" in vars else ""
        _overlayBucketName = str(vars["overlayBucketName"] if "overlayBucketName" in vars else "{}-overlay".format(_baseName))
        _gsaEmail = str(vars["gsaEmail"] if "gsaEmail" in vars else "")
        _namespace = str(vars["namespace"] if "namespace" in vars else "")
        _managementPolicies = vars["managementPolicies"] if "managementPolicies" in vars else ["*"]

        _items: [any] = []

        if bool(vars["overlayEnabled"] if "overlayEnabled" in vars else False):
            _items += [Bucket {
                apiVersion = "storage.gcp.m.upbound.io/v1beta1"
                kind = "Bucket"
                metadata = {
                    annotations = {"crossplane.io/composition-resource-name": "liferay-overlay-bucket"}
                    labels = _labels
                    name = _overlayBucketName
                }
                spec = {
                    forProvider = {
                        forceDestroy = bool(vars["forceDestroy"] if "forceDestroy" in vars else False)
                        labels = _labels
                        location = str(vars["overlayRegion"] if "overlayRegion" in vars and vars["overlayRegion"] else (vars["region"] if "region" in vars else ""))
                        project = str(vars["projectId"] if "projectId" in vars else "")
                        storageClass = "STANDARD"
                        uniformBucketLevelAccess = True
                    }
                    managementPolicies = _managementPolicies
                }
            }]

            _items += [BucketIAMMember {
                apiVersion = "storage.gcp.m.upbound.io/v1beta1"
                kind = "BucketIAMMember"
                metadata = {
                    annotations = {"crossplane.io/composition-resource-name": "liferay-gsa-overlay-bucket-iam"}
                    labels = _labels
                }
                spec = {
                    forProvider = {
                        bucketRef = {"name": _overlayBucketName}
                        member = "serviceAccount:{}".format(_gsaEmail)
                        role = "roles/storage.objectViewer"
                    }
                    managementPolicies = _managementPolicies
                }
            }]

        _items
    }

    _vars = {
        "baseName": baseName
        "forceDestroy": forceDestroy
        "gsaEmail": gsaEmail
        "labels": labels
        "managementPolicies": managementPolicies
        "namespace": namespace
        "overlayEnabled": overlayEnabled
        "overlayRegion": overlay["region"] if "region" in overlay else ""
        "projectId": env["projectId"] if "projectId" in env else ""
        "region": region
    }

    items: {str:any} = {"items": get_items(obs, _vars)}


_overlay = overlay_layer {}
items_overlay = _overlay.items

schema k8s_resources_layer:





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
            Object {
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

        _k8s_items += [Object {
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
        "databaseIamUser": databaseIamUser
        "databaseName": databaseName
        "databasePort": databasePort
        "databaseSpec": databaseSpec
        "gsaEmail": gsaEmail
        "instanceConnectionName": instanceConnectionName
        "jobName": jobName
        "labels": labels
        "managementPolicies": managementPolicies
        "managementPolicy": managementPolicy
        "metadata": metadata
        "namespace": namespace
    }

    items: {str:any} = {"items": get_items(obs, _vars)}


_k8s_resources = k8s_resources_layer {}
items_k8s_resources = _k8s_resources.items

schema elasticsearch_layer:




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
            Object {
                apiVersion = "kubernetes.m.crossplane.io/v1alpha1"
                kind = "Object"
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
                                "name": str(vars["searchName"] if "searchName" in vars else "")
                                "namespace": str(vars["searchNamespace"] if "searchNamespace" in vars else "")
                            }
                        }
                    }
                    managementPolicies = ["Observe"]
                }
            }
            Object {
                apiVersion = "kubernetes.m.crossplane.io/v1alpha1"
                kind = "Object"
                metadata = {
                    annotations = {"crossplane.io/composition-resource-name": "elasticsearch-secret-observer"}
                    name = "{}-es-es-elastic-user-observer".format(_name)
                }
                spec = {
                    forProvider = {
                        manifest = k8s_core.Secret {
                apiVersion = "v1"
                kind = "Secret"
                            metadata = {
                                name = str(vars["searchSecretName"] if "searchSecretName" in vars else "")
                                namespace = str(vars["searchNamespace"] if "searchNamespace" in vars else "")
                            }
                        }
                    }
                    managementPolicies = ["Observe"]
                }
            }
        ]

        if _is_ready:
            _items += [Object {
                apiVersion = "kubernetes.m.crossplane.io/v1alpha1"
                kind = "Object"
                metadata = {
                    annotations = {
                        "crossplane.io/external-name": "elasticsearch-connection-details"
                        "crossplane.io/composition-resource-name": "elasticsearch-connection-details-secret"
                    }
                    labels = vars["labels"] if "labels" in vars else {}
                    name = "{}-elasticsearch-connection-details-secret".format(_name)
                }
                spec = {
                    forProvider = {
                        manifest = k8s_core.Secret {
                apiVersion = "v1"
                kind = "Secret"
                            data = {"ELASTICSEARCH_PASSWORD": _password}
                            metadata = {
                                labels = vars["labels"] if "labels" in vars else {}
                                name = "elasticsearch-connection-details"
                                namespace = str(vars["namespace"] if "namespace" in vars else "")
                            }
                            stringData = {
                                "ELASTICSEARCH_URL": "http://{}-es-http.{}.svc:9200".format(str(vars["searchName"] if "searchName" in vars else ""), str(vars["searchNamespace"] if "searchNamespace" in vars else ""))
                                "ELASTICSEARCH_USERNAME": "elastic"
                            }
                            type = "Opaque"
                        }
                    }
                    managementPolicies = vars["managementPolicies"] if "managementPolicies" in vars else ["Default"]
                }
            }]

        _items
    }

    _vars = {
        "labels": labels
        "managementPolicies": managementPolicies
        "metadata": metadata
        "namespace": namespace
        "searchName": searchName
        "searchNamespace": searchNamespace
        "searchSecretName": searchSecretName
    }

    items: {str:any} = {"items": get_items(obs, _vars)}


_elasticsearch = elasticsearch_layer {}
items_elasticsearch = _elasticsearch.items

schema backup_layer:








    get_items = lambda obs: any, vars: {str:any} -> [any] {
        _backup = (vars["backup"] if "backup" in vars else {}) or {}
        _backup_items: [any] = []
        _baseName = str(vars["baseName"] if "baseName" in vars else "")
        _labels = vars["labels"] if "labels" in vars else {}
        _meta_name = str(vars["metadata"]["name"] if "metadata" in vars and "name" in vars["metadata"] else "")
        _gsaEmail = str(vars["gsaEmail"] if "gsaEmail" in vars else "")
        _namespace = str(vars["namespace"] if "namespace" in vars else "")
        _managementPolicies = vars["managementPolicies"] if "managementPolicies" in vars else ["*"]
        _managementPolicy = vars["managementPolicy"] if "managementPolicy" in vars else "Default"

        _get_iam_name = lambda role: str, bucket: str -> str {
            _hash = crypto.sha256(_meta_name + role + "serviceAccount:" + _gsaEmail + bucket)[:12:]
            "{}-{}".format(_meta_name, _hash)
        }

        if bool(_backup["enabled"] if "enabled" in _backup else False):
            _backup_vault_labels = _labels | {"is-backup-vault": "true"}
            _bucket_name = "{}-vault".format(_baseName)

            _backup_items += [Bucket {
                apiVersion = "storage.gcp.m.upbound.io/v1beta1"
                kind = "Bucket"
                metadata = {
                    annotations = {"crossplane.io/composition-resource-name": "liferay-gcs-backup"}
                    labels = _backup_vault_labels
                    name = _bucket_name
                }
                spec = {
                    forProvider = {
                        forceDestroy = bool(vars["forceDestroy"] if "forceDestroy" in vars else False)
                        labels = _backup_vault_labels
                        lifecycleRule = [{
                            action = {$type = "Delete"}
                            condition = {age = (int(_backup["retentionDays"] if "retentionDays" in _backup else 30)) + 2}
                        }]
                        location = str(_backup["region"] if "region" in _backup else (vars["region"] if "region" in vars else ""))
                        storageClass = str(_backup["storageClass"] if "storageClass" in _backup else "NEARLINE")
                        uniformBucketLevelAccess = True
                    }
                    if bool(vars["cmkEnabled"] if "cmkEnabled" in vars else False):
                        forProvider.encryption = {
                            defaultKmsKeyName = str(vars["cmkKeyName"] if "cmkKeyName" in vars else "")
                        }
                    managementPolicies = _managementPolicies
                }
            }]

            _backup_items += [BucketIAMMember {
                apiVersion = "storage.gcp.m.upbound.io/v1beta1"
                kind = "BucketIAMMember"
                metadata = {
                    annotations = {"crossplane.io/composition-resource-name": "liferay-gcs-backup-iam"}
                    labels = _labels
                    name = _get_iam_name("roles/storage.admin", _bucket_name)
                }
                spec = {
                    forProvider = {
                        bucketRef = {"name": _bucket_name}
                        member = "serviceAccount:{}".format(_gsaEmail)
                        role = "roles/storage.admin"
                    }
                    managementPolicies = _managementPolicies
                }
            }]

            _backup_cr = k8s_rbac.ClusterRole {
                apiVersion = "rbac.authorization.k8s.io/v1"
                kind = "ClusterRole"
                metadata = {
                    labels = _labels
                    name = "backup-create-cluster-role"
                }
                rules = [{
                    apiGroups = [""]
                    resources = ["serviceaccounts"]
                    verbs = ["create", "delete", "get", "list", "watch"]
                }]
            }

            _backup_crb = k8s_rbac.ClusterRoleBinding {
                apiVersion = "rbac.authorization.k8s.io/v1"
                kind = "ClusterRoleBinding"
                metadata = {
                    labels = _labels
                    name = "backup-create-cluster-role-binding"
                }
                roleRef = {
                    apiGroup = "rbac.authorization.k8s.io"
                    kind = "ClusterRole"
                    name = "backup-create-cluster-role"
                }
                subjects = [{
                    kind = "ServiceAccount"
                    name = "backup-create-service-account"
                    namespace = _namespace
                }]
            }

            _backup_items += [
                Object {
                apiVersion = "kubernetes.m.crossplane.io/v1alpha1"
                kind = "Object"
                    metadata = {
                        annotations = {"crossplane.io/composition-resource-name": "backup-create-cluster-role"}
                        labels = _labels
                        name = "backup-create-cluster-role"
                    }
                    spec = {
                        forProvider = {"manifest": _backup_cr}
                        managementPolicies = [_managementPolicy]
                    }
                },
                Object {
                apiVersion = "kubernetes.m.crossplane.io/v1alpha1"
                kind = "Object"
                    metadata = {
                        annotations = {"crossplane.io/composition-resource-name": "backup-create-cluster-role-binding"}
                        labels = _labels
                        name = "backup-create-cluster-role-binding"
                    }
                    spec = {
                        forProvider = {"manifest": _backup_crb}
                        managementPolicies = [_managementPolicy]
                    }
                }
            ]

        _backup_items
    }

    _vars = {
        "backup": backup
        "baseName": baseName
        "cmkEnabled": cmkEnabled
        "cmkKeyName": cmkKeyName
        "forceDestroy": forceDestroy
        "gsaEmail": gsaEmail
        "labels": labels
        "managementPolicies": managementPolicies
        "managementPolicy": managementPolicy
        "metadata": metadata
        "namespace": namespace
        "region": region
    }

    items: {str:any} = {"items": get_items(obs, _vars)}


_backup = backup_layer {}
items_backup = _backup.items

schema managed_service_details_layer:




    get_items = lambda obs: any, vars: {str:any} -> [any] {
        _labels = vars["labels"] if "labels" in vars else {}
        _namespace = str(vars["namespace"] if "namespace" in vars else "")
        _baseName = str(vars["baseName"] if "baseName" in vars else "")

        _managed_service_details_secret = k8s_core.Secret {
            apiVersion = "v1"
            kind = "Secret"
            metadata = {
                labels = _labels
                name = "managed-service-details"
                namespace = _namespace
            }
            stringData = {
                "DATABASE_ENDPOINT": "localhost"
                "DATABASE_INSTANCE_NAME": "{}:us-central1:{}-db-instance".format(str(vars["projectId"] if "projectId" in vars else ""), _baseName)
                "DATABASE_PORT": "5432"
                "DATABASE_USERNAME": "{}-sa@{}.iam".format(_baseName, str(vars["projectId"] if "projectId" in vars else ""))
                "LIFERAY_GCS_BUCKET_NAME": str(vars["bucketName"] if "bucketName" in vars else "{}-dl".format(_baseName))
                "LIFERAY_OVERLAY_BUCKET_NAME": str(vars["overlayBucketName"] if "overlayBucketName" in vars else "{}-overlay".format(_baseName))
            }
        }

        _items: [any] = [
            Object {
                apiVersion = "kubernetes.m.crossplane.io/v1alpha1"
                kind = "Object"
                metadata = {
                    annotations = {"crossplane.io/composition-resource-name": "managed-service-details-secret"}
                    labels = _labels
                    name = "{}-managed-service-details-secret".format(_baseName)
                }
                spec = {
                    forProvider = {"manifest": _managed_service_details_secret}
                    managementPolicies = vars["managementPolicies"] if "managementPolicies" in vars else ["*"]
                }
            }
        ]

        _items
    }

    _vars = {
        "baseName": baseName
        "gsaEmail": gsaEmail
        "labels": labels
        "managementPolicies": managementPolicies
        "namespace": namespace
        "projectId": env["projectId"] if "projectId" in env else ""
    }

    items: {str:any} = {"items": get_items(obs, _vars)}


_managed_service_details = managed_service_details_layer {}
items_managed_service_details = _managed_service_details.items

_layer_items = lambda layer {
    _items = []
    if typeof(layer) == "list":
        _items = layer
    elif layer and "items" in layer:
        _items = layer.items
    _items
}
items = {"items": [item for layer in [items_init,items_security,items_sql,items_storage,items_overlay,items_k8s_resources,items_elasticsearch,items_backup,items_managed_service_details] for item in _layer_items(layer)]}
