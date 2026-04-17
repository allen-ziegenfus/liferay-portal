import crypto
import yaml
import json
import k8s.api.core.v1 as k8s_core
import k8s.api.batch.v1 as k8s_batch
import k8s.api.rbac.v1 as k8s_rbac
import k8s.apimachinery.pkg.apis.meta.v1 as v1

# --- MODELS ---



schema VPNTunnel:
    r"""
    VPNTunnel is the Schema for the VPNTunnels API. VPN tunnel resource.

    Attributes
    ----------
    apiVersion : str, default is "compute.gcp.upbound.io/v1beta1", required
        APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
    kind : str, default is "VPNTunnel", required
        Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
    metadata : v1.ObjectMeta, default is Undefined, optional
        metadata
    spec : ComputeGcpUpboundIoV1beta1VPNTunnelSpec, default is Undefined, required
        spec
    status : ComputeGcpUpboundIoV1beta1VPNTunnelStatus, default is Undefined, optional
        status
    """


    apiVersion: "compute.gcp.upbound.io/v1beta1" = "compute.gcp.upbound.io/v1beta1"

    kind: "VPNTunnel" = "VPNTunnel"

    metadata?: v1.ObjectMeta

    spec: ComputeGcpUpboundIoV1beta1VPNTunnelSpec

    status?: ComputeGcpUpboundIoV1beta1VPNTunnelStatus


schema ComputeGcpUpboundIoV1beta1VPNTunnelSpec:
    r"""
    VPNTunnelSpec defines the desired state of VPNTunnel

    Attributes
    ----------
    deletionPolicy : str, default is "Delete", optional
        DeletionPolicy specifies what will happen to the underlying external
        when this managed resource is deleted - either "Delete" or "Orphan" the
        external resource.
        This field is planned to be deprecated in favor of the ManagementPolicies
        field in a future release. Currently, both could be set independently and
        non-default values would be honored if the feature flag is enabled.
        See the design doc for more information: https://github.com/crossplane/crossplane/blob/499895a25d1a1a0ba1604944ef98ac7a1a71f197/design/design-doc-observe-only-resources.md?plain=1#L223
    managementPolicies : [str], default is ["*"], optional
        THIS IS A BETA FIELD. It is on by default but can be opted out
        through a Crossplane feature flag.
        ManagementPolicies specify the array of actions Crossplane is allowed to
        take on the managed and external resources.
        This field is planned to replace the DeletionPolicy field in a future
        release. Currently, both could be set independently and non-default
        values would be honored if the feature flag is enabled. If both are
        custom, the DeletionPolicy field will be ignored.
        See the design doc for more information: https://github.com/crossplane/crossplane/blob/499895a25d1a1a0ba1604944ef98ac7a1a71f197/design/design-doc-observe-only-resources.md?plain=1#L223
        and this one: https://github.com/crossplane/crossplane/blob/444267e84783136daa93568b364a5f01228cacbe/design/one-pager-ignore-changes.md
    forProvider : ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProvider, default is Undefined, required
        for provider
    initProvider : ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProvider, default is Undefined, optional
        init provider
    providerConfigRef : ComputeGcpUpboundIoV1beta1VPNTunnelSpecProviderConfigRef, default is Undefined, optional
        provider config ref
    writeConnectionSecretToRef : ComputeGcpUpboundIoV1beta1VPNTunnelSpecWriteConnectionSecretToRef, default is Undefined, optional
        write connection secret to ref
    """


    deletionPolicy?: "Orphan" | "Delete" = "Delete"

    managementPolicies?: [str] = ["*"]

    forProvider: ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProvider

    initProvider?: ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProvider

    providerConfigRef?: ComputeGcpUpboundIoV1beta1VPNTunnelSpecProviderConfigRef

    writeConnectionSecretToRef?: ComputeGcpUpboundIoV1beta1VPNTunnelSpecWriteConnectionSecretToRef


schema ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProvider:
    r"""
    compute gcp upbound io v1beta1 v p n tunnel spec for provider

    Attributes
    ----------
    description : str, default is Undefined, optional
        An optional description of this resource.
    ikeVersion : float, default is Undefined, optional
        IKE protocol version to use when establishing the VPN tunnel with
        peer VPN gateway.
        Acceptable IKE versions are 1 or 2. Default version is 2.
    labels : {str:str}, default is Undefined, optional
        Labels to apply to this VpnTunnel.
        Note: This field is non-authoritative, and will only manage the labels present in your configuration.
        Please refer to the field effective_labels for all of the labels present on the resource.
    localTrafficSelector : [str], default is Undefined, optional
        Local traffic selector to use when establishing the VPN tunnel with
        peer VPN gateway. The value should be a CIDR formatted string,
        for example 192.168.0.0/16. The ranges should be disjoint.
        Only IPv4 is supported.
    peerExternalGateway : str, default is Undefined, optional
        URL of the peer side external VPN gateway to which this VPN tunnel is connected.
    peerExternalGatewayInterface : float, default is Undefined, optional
        The interface ID of the external VPN gateway to which this VPN tunnel is connected.
    peerGcpGateway : str, default is Undefined, optional
        URL of the peer side HA GCP VPN gateway to which this VPN tunnel is connected.
        If provided, the VPN tunnel will automatically use the same vpn_gateway_interface
        ID in the peer GCP VPN gateway.
        This field must reference a google_compute_ha_vpn_gateway resource.
    peerIp : str, default is Undefined, optional
        IP address of the peer VPN gateway. Only IPv4 is supported.
    project : str, default is Undefined, optional
        The ID of the project in which the resource belongs.
        If it is not provided, the provider project is used.
    region : str, default is Undefined, required
        The region where the tunnel is located. If unset, is set to the region of target_vpn_gateway.
    remoteTrafficSelector : [str], default is Undefined, optional
        Remote traffic selector to use when establishing the VPN tunnel with
        peer VPN gateway. The value should be a CIDR formatted string,
        for example 192.168.0.0/16. The ranges should be disjoint.
        Only IPv4 is supported.
    router : str, default is Undefined, optional
        URL of router resource to be used for dynamic routing.
    targetVpnGateway : str, default is Undefined, optional
        URL of the Target VPN gateway with which this VPN tunnel is
        associated.
    vpnGateway : str, default is Undefined, optional
        URL of the VPN gateway with which this VPN tunnel is associated.
        This must be used if a High Availability VPN gateway resource is created.
        This field must reference a google_compute_ha_vpn_gateway resource.
    vpnGatewayInterface : float, default is Undefined, optional
        The interface ID of the VPN gateway with which this VPN tunnel is associated.
    peerExternalGatewayRef : ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProviderPeerExternalGatewayRef, default is Undefined, optional
        peer external gateway ref
    peerExternalGatewaySelector : ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProviderPeerExternalGatewaySelector, default is Undefined, optional
        peer external gateway selector
    routerRef : ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProviderRouterRef, default is Undefined, optional
        router ref
    routerSelector : ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProviderRouterSelector, default is Undefined, optional
        router selector
    sharedSecretSecretRef : ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProviderSharedSecretSecretRef, default is Undefined, optional
        shared secret secret ref
    targetVpnGatewayRef : ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProviderTargetVpnGatewayRef, default is Undefined, optional
        target vpn gateway ref
    targetVpnGatewaySelector : ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProviderTargetVpnGatewaySelector, default is Undefined, optional
        target vpn gateway selector
    vpnGatewayRef : ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProviderVpnGatewayRef, default is Undefined, optional
        vpn gateway ref
    vpnGatewaySelector : ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProviderVpnGatewaySelector, default is Undefined, optional
        vpn gateway selector
    """


    description?: str

    ikeVersion?: float

    labels?: {str:str}

    localTrafficSelector?: [str]

    peerExternalGateway?: str

    peerExternalGatewayInterface?: float

    peerGcpGateway?: str

    peerIp?: str

    project?: str

    region: str

    remoteTrafficSelector?: [str]

    router?: str

    targetVpnGateway?: str

    vpnGateway?: str

    vpnGatewayInterface?: float

    peerExternalGatewayRef?: ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProviderPeerExternalGatewayRef

    peerExternalGatewaySelector?: ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProviderPeerExternalGatewaySelector

    routerRef?: ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProviderRouterRef

    routerSelector?: ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProviderRouterSelector

    sharedSecretSecretRef?: ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProviderSharedSecretSecretRef

    targetVpnGatewayRef?: ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProviderTargetVpnGatewayRef

    targetVpnGatewaySelector?: ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProviderTargetVpnGatewaySelector

    vpnGatewayRef?: ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProviderVpnGatewayRef

    vpnGatewaySelector?: ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProviderVpnGatewaySelector


schema ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProviderPeerExternalGatewayRef:
    r"""
    Reference to a ExternalVPNGateway in compute to populate peerExternalGateway.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    policy : ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProviderPeerExternalGatewayRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    policy?: ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProviderPeerExternalGatewayRefPolicy


schema ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProviderPeerExternalGatewayRefPolicy:
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


schema ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProviderPeerExternalGatewaySelector:
    r"""
    Selector for a ExternalVPNGateway in compute to populate peerExternalGateway.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    policy : ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProviderPeerExternalGatewaySelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    policy?: ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProviderPeerExternalGatewaySelectorPolicy


schema ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProviderPeerExternalGatewaySelectorPolicy:
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


schema ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProviderRouterRef:
    r"""
    Reference to a Router in compute to populate router.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    policy : ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProviderRouterRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    policy?: ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProviderRouterRefPolicy


schema ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProviderRouterRefPolicy:
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


schema ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProviderRouterSelector:
    r"""
    Selector for a Router in compute to populate router.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    policy : ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProviderRouterSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    policy?: ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProviderRouterSelectorPolicy


schema ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProviderRouterSelectorPolicy:
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


schema ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProviderSharedSecretSecretRef:
    r"""
    Shared secret used to set the secure session between the Cloud VPN
    gateway and the peer VPN gateway.
    Note: This property is sensitive and will not be displayed in the plan.

    Attributes
    ----------
    key : str, default is Undefined, required
        The key to select.
    name : str, default is Undefined, required
        Name of the secret.
    namespace : str, default is Undefined, required
        Namespace of the secret.
    """


    key: str

    name: str

    namespace: str


schema ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProviderTargetVpnGatewayRef:
    r"""
    Reference to a VPNGateway in compute to populate targetVpnGateway.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    policy : ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProviderTargetVpnGatewayRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    policy?: ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProviderTargetVpnGatewayRefPolicy


schema ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProviderTargetVpnGatewayRefPolicy:
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


schema ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProviderTargetVpnGatewaySelector:
    r"""
    Selector for a VPNGateway in compute to populate targetVpnGateway.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    policy : ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProviderTargetVpnGatewaySelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    policy?: ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProviderTargetVpnGatewaySelectorPolicy


schema ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProviderTargetVpnGatewaySelectorPolicy:
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


schema ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProviderVpnGatewayRef:
    r"""
    Reference to a HaVPNGateway in compute to populate vpnGateway.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    policy : ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProviderVpnGatewayRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    policy?: ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProviderVpnGatewayRefPolicy


schema ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProviderVpnGatewayRefPolicy:
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


schema ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProviderVpnGatewaySelector:
    r"""
    Selector for a HaVPNGateway in compute to populate vpnGateway.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    policy : ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProviderVpnGatewaySelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    policy?: ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProviderVpnGatewaySelectorPolicy


schema ComputeGcpUpboundIoV1beta1VPNTunnelSpecForProviderVpnGatewaySelectorPolicy:
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


schema ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProvider:
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
    description : str, default is Undefined, optional
        An optional description of this resource.
    ikeVersion : float, default is Undefined, optional
        IKE protocol version to use when establishing the VPN tunnel with
        peer VPN gateway.
        Acceptable IKE versions are 1 or 2. Default version is 2.
    labels : {str:str}, default is Undefined, optional
        Labels to apply to this VpnTunnel.
        Note: This field is non-authoritative, and will only manage the labels present in your configuration.
        Please refer to the field effective_labels for all of the labels present on the resource.
    localTrafficSelector : [str], default is Undefined, optional
        Local traffic selector to use when establishing the VPN tunnel with
        peer VPN gateway. The value should be a CIDR formatted string,
        for example 192.168.0.0/16. The ranges should be disjoint.
        Only IPv4 is supported.
    peerExternalGateway : str, default is Undefined, optional
        URL of the peer side external VPN gateway to which this VPN tunnel is connected.
    peerExternalGatewayInterface : float, default is Undefined, optional
        The interface ID of the external VPN gateway to which this VPN tunnel is connected.
    peerGcpGateway : str, default is Undefined, optional
        URL of the peer side HA GCP VPN gateway to which this VPN tunnel is connected.
        If provided, the VPN tunnel will automatically use the same vpn_gateway_interface
        ID in the peer GCP VPN gateway.
        This field must reference a google_compute_ha_vpn_gateway resource.
    peerIp : str, default is Undefined, optional
        IP address of the peer VPN gateway. Only IPv4 is supported.
    project : str, default is Undefined, optional
        The ID of the project in which the resource belongs.
        If it is not provided, the provider project is used.
    remoteTrafficSelector : [str], default is Undefined, optional
        Remote traffic selector to use when establishing the VPN tunnel with
        peer VPN gateway. The value should be a CIDR formatted string,
        for example 192.168.0.0/16. The ranges should be disjoint.
        Only IPv4 is supported.
    router : str, default is Undefined, optional
        URL of router resource to be used for dynamic routing.
    targetVpnGateway : str, default is Undefined, optional
        URL of the Target VPN gateway with which this VPN tunnel is
        associated.
    vpnGateway : str, default is Undefined, optional
        URL of the VPN gateway with which this VPN tunnel is associated.
        This must be used if a High Availability VPN gateway resource is created.
        This field must reference a google_compute_ha_vpn_gateway resource.
    vpnGatewayInterface : float, default is Undefined, optional
        The interface ID of the VPN gateway with which this VPN tunnel is associated.
    peerExternalGatewayRef : ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProviderPeerExternalGatewayRef, default is Undefined, optional
        peer external gateway ref
    peerExternalGatewaySelector : ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProviderPeerExternalGatewaySelector, default is Undefined, optional
        peer external gateway selector
    routerRef : ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProviderRouterRef, default is Undefined, optional
        router ref
    routerSelector : ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProviderRouterSelector, default is Undefined, optional
        router selector
    sharedSecretSecretRef : ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProviderSharedSecretSecretRef, default is Undefined, required
        shared secret secret ref
    targetVpnGatewayRef : ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProviderTargetVpnGatewayRef, default is Undefined, optional
        target vpn gateway ref
    targetVpnGatewaySelector : ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProviderTargetVpnGatewaySelector, default is Undefined, optional
        target vpn gateway selector
    vpnGatewayRef : ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProviderVpnGatewayRef, default is Undefined, optional
        vpn gateway ref
    vpnGatewaySelector : ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProviderVpnGatewaySelector, default is Undefined, optional
        vpn gateway selector
    """


    description?: str

    ikeVersion?: float

    labels?: {str:str}

    localTrafficSelector?: [str]

    peerExternalGateway?: str

    peerExternalGatewayInterface?: float

    peerGcpGateway?: str

    peerIp?: str

    project?: str

    remoteTrafficSelector?: [str]

    router?: str

    targetVpnGateway?: str

    vpnGateway?: str

    vpnGatewayInterface?: float

    peerExternalGatewayRef?: ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProviderPeerExternalGatewayRef

    peerExternalGatewaySelector?: ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProviderPeerExternalGatewaySelector

    routerRef?: ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProviderRouterRef

    routerSelector?: ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProviderRouterSelector

    sharedSecretSecretRef: ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProviderSharedSecretSecretRef

    targetVpnGatewayRef?: ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProviderTargetVpnGatewayRef

    targetVpnGatewaySelector?: ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProviderTargetVpnGatewaySelector

    vpnGatewayRef?: ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProviderVpnGatewayRef

    vpnGatewaySelector?: ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProviderVpnGatewaySelector


schema ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProviderPeerExternalGatewayRef:
    r"""
    Reference to a ExternalVPNGateway in compute to populate peerExternalGateway.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    policy : ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProviderPeerExternalGatewayRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    policy?: ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProviderPeerExternalGatewayRefPolicy


schema ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProviderPeerExternalGatewayRefPolicy:
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


schema ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProviderPeerExternalGatewaySelector:
    r"""
    Selector for a ExternalVPNGateway in compute to populate peerExternalGateway.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    policy : ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProviderPeerExternalGatewaySelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    policy?: ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProviderPeerExternalGatewaySelectorPolicy


schema ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProviderPeerExternalGatewaySelectorPolicy:
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


schema ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProviderRouterRef:
    r"""
    Reference to a Router in compute to populate router.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    policy : ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProviderRouterRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    policy?: ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProviderRouterRefPolicy


schema ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProviderRouterRefPolicy:
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


schema ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProviderRouterSelector:
    r"""
    Selector for a Router in compute to populate router.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    policy : ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProviderRouterSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    policy?: ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProviderRouterSelectorPolicy


schema ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProviderRouterSelectorPolicy:
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


schema ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProviderSharedSecretSecretRef:
    r"""
    Shared secret used to set the secure session between the Cloud VPN
    gateway and the peer VPN gateway.
    Note: This property is sensitive and will not be displayed in the plan.

    Attributes
    ----------
    key : str, default is Undefined, required
        The key to select.
    name : str, default is Undefined, required
        Name of the secret.
    namespace : str, default is Undefined, required
        Namespace of the secret.
    """


    key: str

    name: str

    namespace: str


schema ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProviderTargetVpnGatewayRef:
    r"""
    Reference to a VPNGateway in compute to populate targetVpnGateway.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    policy : ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProviderTargetVpnGatewayRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    policy?: ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProviderTargetVpnGatewayRefPolicy


schema ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProviderTargetVpnGatewayRefPolicy:
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


schema ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProviderTargetVpnGatewaySelector:
    r"""
    Selector for a VPNGateway in compute to populate targetVpnGateway.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    policy : ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProviderTargetVpnGatewaySelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    policy?: ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProviderTargetVpnGatewaySelectorPolicy


schema ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProviderTargetVpnGatewaySelectorPolicy:
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


schema ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProviderVpnGatewayRef:
    r"""
    Reference to a HaVPNGateway in compute to populate vpnGateway.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    policy : ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProviderVpnGatewayRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    policy?: ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProviderVpnGatewayRefPolicy


schema ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProviderVpnGatewayRefPolicy:
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


schema ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProviderVpnGatewaySelector:
    r"""
    Selector for a HaVPNGateway in compute to populate vpnGateway.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    policy : ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProviderVpnGatewaySelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    policy?: ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProviderVpnGatewaySelectorPolicy


schema ComputeGcpUpboundIoV1beta1VPNTunnelSpecInitProviderVpnGatewaySelectorPolicy:
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


schema ComputeGcpUpboundIoV1beta1VPNTunnelSpecProviderConfigRef:
    r"""
    ProviderConfigReference specifies how the provider that will be used to
    create, observe, update, and delete this managed resource should be
    configured.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    policy : ComputeGcpUpboundIoV1beta1VPNTunnelSpecProviderConfigRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    policy?: ComputeGcpUpboundIoV1beta1VPNTunnelSpecProviderConfigRefPolicy


schema ComputeGcpUpboundIoV1beta1VPNTunnelSpecProviderConfigRefPolicy:
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


schema ComputeGcpUpboundIoV1beta1VPNTunnelSpecWriteConnectionSecretToRef:
    r"""
    WriteConnectionSecretToReference specifies the namespace and name of a
    Secret to which any connection details for this managed resource should
    be written. Connection details frequently include the endpoint, username,
    and password required to connect to the managed resource.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the secret.
    namespace : str, default is Undefined, required
        Namespace of the secret.
    """


    name: str

    namespace: str


schema ComputeGcpUpboundIoV1beta1VPNTunnelStatus:
    r"""
    VPNTunnelStatus defines the observed state of VPNTunnel.

    Attributes
    ----------
    conditions : [ComputeGcpUpboundIoV1beta1VPNTunnelStatusConditionsItems0], default is Undefined, optional
        Conditions of the resource.
    observedGeneration : int, default is Undefined, optional
        ObservedGeneration is the latest metadata.generation
        which resulted in either a ready state, or stalled due to error
        it can not recover from without human intervention.
    atProvider : ComputeGcpUpboundIoV1beta1VPNTunnelStatusAtProvider, default is Undefined, optional
        at provider
    """


    conditions?: [ComputeGcpUpboundIoV1beta1VPNTunnelStatusConditionsItems0]

    observedGeneration?: int

    atProvider?: ComputeGcpUpboundIoV1beta1VPNTunnelStatusAtProvider


schema ComputeGcpUpboundIoV1beta1VPNTunnelStatusAtProvider:
    r"""
    compute gcp upbound io v1beta1 v p n tunnel status at provider

    Attributes
    ----------
    creationTimestamp : str, default is Undefined, optional
        Creation timestamp in RFC3339 text format.
    description : str, default is Undefined, optional
        An optional description of this resource.
    detailedStatus : str, default is Undefined, optional
        Detailed status message for the VPN tunnel.
    effectiveLabels : {str:str}, default is Undefined, optional
        effective labels
    id : str, default is Undefined, optional
        an identifier for the resource with format projects/{{project}}/regions/{{region}}/vpnTunnels/{{name}}
    ikeVersion : float, default is Undefined, optional
        IKE protocol version to use when establishing the VPN tunnel with
        peer VPN gateway.
        Acceptable IKE versions are 1 or 2. Default version is 2.
    labelFingerprint : str, default is Undefined, optional
        The fingerprint used for optimistic locking of this resource.  Used
        internally during updates.
    labels : {str:str}, default is Undefined, optional
        Labels to apply to this VpnTunnel.
        Note: This field is non-authoritative, and will only manage the labels present in your configuration.
        Please refer to the field effective_labels for all of the labels present on the resource.
    localTrafficSelector : [str], default is Undefined, optional
        Local traffic selector to use when establishing the VPN tunnel with
        peer VPN gateway. The value should be a CIDR formatted string,
        for example 192.168.0.0/16. The ranges should be disjoint.
        Only IPv4 is supported.
    peerExternalGateway : str, default is Undefined, optional
        URL of the peer side external VPN gateway to which this VPN tunnel is connected.
    peerExternalGatewayInterface : float, default is Undefined, optional
        The interface ID of the external VPN gateway to which this VPN tunnel is connected.
    peerGcpGateway : str, default is Undefined, optional
        URL of the peer side HA GCP VPN gateway to which this VPN tunnel is connected.
        If provided, the VPN tunnel will automatically use the same vpn_gateway_interface
        ID in the peer GCP VPN gateway.
        This field must reference a google_compute_ha_vpn_gateway resource.
    peerIp : str, default is Undefined, optional
        IP address of the peer VPN gateway. Only IPv4 is supported.
    project : str, default is Undefined, optional
        The ID of the project in which the resource belongs.
        If it is not provided, the provider project is used.
    region : str, default is Undefined, optional
        The region where the tunnel is located. If unset, is set to the region of target_vpn_gateway.
    remoteTrafficSelector : [str], default is Undefined, optional
        Remote traffic selector to use when establishing the VPN tunnel with
        peer VPN gateway. The value should be a CIDR formatted string,
        for example 192.168.0.0/16. The ranges should be disjoint.
        Only IPv4 is supported.
    router : str, default is Undefined, optional
        URL of router resource to be used for dynamic routing.
    selfLink : str, default is Undefined, optional
        The URI of the created resource.
    sharedSecretHash : str, default is Undefined, optional
        Hash of the shared secret.
    targetVpnGateway : str, default is Undefined, optional
        URL of the Target VPN gateway with which this VPN tunnel is
        associated.
    terraformLabels : {str:str}, default is Undefined, optional
        The combination of labels configured directly on the resource
        and default labels configured on the provider.
    tunnelId : str, default is Undefined, optional
        The unique identifier for the resource. This identifier is defined by the server.
    vpnGateway : str, default is Undefined, optional
        URL of the VPN gateway with which this VPN tunnel is associated.
        This must be used if a High Availability VPN gateway resource is created.
        This field must reference a google_compute_ha_vpn_gateway resource.
    vpnGatewayInterface : float, default is Undefined, optional
        The interface ID of the VPN gateway with which this VPN tunnel is associated.
    """


    creationTimestamp?: str

    description?: str

    detailedStatus?: str

    effectiveLabels?: {str:str}

    id?: str

    ikeVersion?: float

    labelFingerprint?: str

    labels?: {str:str}

    localTrafficSelector?: [str]

    peerExternalGateway?: str

    peerExternalGatewayInterface?: float

    peerGcpGateway?: str

    peerIp?: str

    project?: str

    region?: str

    remoteTrafficSelector?: [str]

    router?: str

    selfLink?: str

    sharedSecretHash?: str

    targetVpnGateway?: str

    terraformLabels?: {str:str}

    tunnelId?: str

    vpnGateway?: str

    vpnGatewayInterface?: float


schema ComputeGcpUpboundIoV1beta1VPNTunnelStatusConditionsItems0:
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
    apiVersion : str, default is "sql.gcp.upbound.io/v1beta2", required
        APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
    kind : str, default is "User", required
        Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
    metadata : v1.ObjectMeta, default is Undefined, optional
        metadata
    spec : SQLGcpUpboundIoV1beta2UserSpec, default is Undefined, required
        spec
    status : SQLGcpUpboundIoV1beta2UserStatus, default is Undefined, optional
        status
    """


    apiVersion: "sql.gcp.upbound.io/v1beta2" = "sql.gcp.upbound.io/v1beta2"

    kind: "User" = "User"

    metadata?: v1.ObjectMeta

    spec: SQLGcpUpboundIoV1beta2UserSpec

    status?: SQLGcpUpboundIoV1beta2UserStatus


schema SQLGcpUpboundIoV1beta2UserSpec:
    r"""
    UserSpec defines the desired state of User

    Attributes
    ----------
    deletionPolicy : str, default is "Delete", optional
        DeletionPolicy specifies what will happen to the underlying external
        when this managed resource is deleted - either "Delete" or "Orphan" the
        external resource.
        This field is planned to be deprecated in favor of the ManagementPolicies
        field in a future release. Currently, both could be set independently and
        non-default values would be honored if the feature flag is enabled.
        See the design doc for more information: https://github.com/crossplane/crossplane/blob/499895a25d1a1a0ba1604944ef98ac7a1a71f197/design/design-doc-observe-only-resources.md?plain=1#L223
    managementPolicies : [str], default is ["*"], optional
        THIS IS A BETA FIELD. It is on by default but can be opted out
        through a Crossplane feature flag.
        ManagementPolicies specify the array of actions Crossplane is allowed to
        take on the managed and external resources.
        This field is planned to replace the DeletionPolicy field in a future
        release. Currently, both could be set independently and non-default
        values would be honored if the feature flag is enabled. If both are
        custom, the DeletionPolicy field will be ignored.
        See the design doc for more information: https://github.com/crossplane/crossplane/blob/499895a25d1a1a0ba1604944ef98ac7a1a71f197/design/design-doc-observe-only-resources.md?plain=1#L223
        and this one: https://github.com/crossplane/crossplane/blob/444267e84783136daa93568b364a5f01228cacbe/design/one-pager-ignore-changes.md
    forProvider : SQLGcpUpboundIoV1beta2UserSpecForProvider, default is Undefined, required
        for provider
    initProvider : SQLGcpUpboundIoV1beta2UserSpecInitProvider, default is Undefined, optional
        init provider
    providerConfigRef : SQLGcpUpboundIoV1beta2UserSpecProviderConfigRef, default is Undefined, optional
        provider config ref
    writeConnectionSecretToRef : SQLGcpUpboundIoV1beta2UserSpecWriteConnectionSecretToRef, default is Undefined, optional
        write connection secret to ref
    """


    deletionPolicy?: "Orphan" | "Delete" = "Delete"

    managementPolicies?: [str] = ["*"]

    forProvider: SQLGcpUpboundIoV1beta2UserSpecForProvider

    initProvider?: SQLGcpUpboundIoV1beta2UserSpecInitProvider

    providerConfigRef?: SQLGcpUpboundIoV1beta2UserSpecProviderConfigRef

    writeConnectionSecretToRef?: SQLGcpUpboundIoV1beta2UserSpecWriteConnectionSecretToRef


schema SQLGcpUpboundIoV1beta2UserSpecForProvider:
    r"""
    SQL gcp upbound io v1beta2 user spec for provider

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
    instanceRef : SQLGcpUpboundIoV1beta2UserSpecForProviderInstanceRef, default is Undefined, optional
        instance ref
    instanceSelector : SQLGcpUpboundIoV1beta2UserSpecForProviderInstanceSelector, default is Undefined, optional
        instance selector
    passwordPolicy : SQLGcpUpboundIoV1beta2UserSpecForProviderPasswordPolicy, default is Undefined, optional
        password policy
    passwordSecretRef : SQLGcpUpboundIoV1beta2UserSpecForProviderPasswordSecretRef, default is Undefined, optional
        password secret ref
    """


    deletionPolicy?: str

    host?: str

    instance?: str

    passwordWo?: str

    passwordWoVersion?: float

    project?: str

    $type?: str

    instanceRef?: SQLGcpUpboundIoV1beta2UserSpecForProviderInstanceRef

    instanceSelector?: SQLGcpUpboundIoV1beta2UserSpecForProviderInstanceSelector

    passwordPolicy?: SQLGcpUpboundIoV1beta2UserSpecForProviderPasswordPolicy

    passwordSecretRef?: SQLGcpUpboundIoV1beta2UserSpecForProviderPasswordSecretRef


schema SQLGcpUpboundIoV1beta2UserSpecForProviderInstanceRef:
    r"""
    Reference to a DatabaseInstance in sql to populate instance.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    policy : SQLGcpUpboundIoV1beta2UserSpecForProviderInstanceRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    policy?: SQLGcpUpboundIoV1beta2UserSpecForProviderInstanceRefPolicy


schema SQLGcpUpboundIoV1beta2UserSpecForProviderInstanceRefPolicy:
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


schema SQLGcpUpboundIoV1beta2UserSpecForProviderInstanceSelector:
    r"""
    Selector for a DatabaseInstance in sql to populate instance.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    policy : SQLGcpUpboundIoV1beta2UserSpecForProviderInstanceSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    policy?: SQLGcpUpboundIoV1beta2UserSpecForProviderInstanceSelectorPolicy


schema SQLGcpUpboundIoV1beta2UserSpecForProviderInstanceSelectorPolicy:
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


schema SQLGcpUpboundIoV1beta2UserSpecForProviderPasswordPolicy:
    r"""
    SQL gcp upbound io v1beta2 user spec for provider password policy

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


schema SQLGcpUpboundIoV1beta2UserSpecForProviderPasswordSecretRef:
    r"""
    The password for the user. Can be updated. For Postgres
    instances this is a Required field, unless type is set to either CLOUD_IAM_USER
    or CLOUD_IAM_SERVICE_ACCOUNT. Don't set this field for CLOUD_IAM_USER
    and CLOUD_IAM_SERVICE_ACCOUNT user types for any Cloud SQL instance.

    Attributes
    ----------
    key : str, default is Undefined, required
        The key to select.
    name : str, default is Undefined, required
        Name of the secret.
    namespace : str, default is Undefined, required
        Namespace of the secret.
    """


    key: str

    name: str

    namespace: str


schema SQLGcpUpboundIoV1beta2UserSpecInitProvider:
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
    instanceRef : SQLGcpUpboundIoV1beta2UserSpecInitProviderInstanceRef, default is Undefined, optional
        instance ref
    instanceSelector : SQLGcpUpboundIoV1beta2UserSpecInitProviderInstanceSelector, default is Undefined, optional
        instance selector
    passwordPolicy : SQLGcpUpboundIoV1beta2UserSpecInitProviderPasswordPolicy, default is Undefined, optional
        password policy
    passwordSecretRef : SQLGcpUpboundIoV1beta2UserSpecInitProviderPasswordSecretRef, default is Undefined, optional
        password secret ref
    """


    deletionPolicy?: str

    host?: str

    instance?: str

    passwordWo?: str

    passwordWoVersion?: float

    project?: str

    $type?: str

    instanceRef?: SQLGcpUpboundIoV1beta2UserSpecInitProviderInstanceRef

    instanceSelector?: SQLGcpUpboundIoV1beta2UserSpecInitProviderInstanceSelector

    passwordPolicy?: SQLGcpUpboundIoV1beta2UserSpecInitProviderPasswordPolicy

    passwordSecretRef?: SQLGcpUpboundIoV1beta2UserSpecInitProviderPasswordSecretRef


schema SQLGcpUpboundIoV1beta2UserSpecInitProviderInstanceRef:
    r"""
    Reference to a DatabaseInstance in sql to populate instance.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    policy : SQLGcpUpboundIoV1beta2UserSpecInitProviderInstanceRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    policy?: SQLGcpUpboundIoV1beta2UserSpecInitProviderInstanceRefPolicy


schema SQLGcpUpboundIoV1beta2UserSpecInitProviderInstanceRefPolicy:
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


schema SQLGcpUpboundIoV1beta2UserSpecInitProviderInstanceSelector:
    r"""
    Selector for a DatabaseInstance in sql to populate instance.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    policy : SQLGcpUpboundIoV1beta2UserSpecInitProviderInstanceSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    policy?: SQLGcpUpboundIoV1beta2UserSpecInitProviderInstanceSelectorPolicy


schema SQLGcpUpboundIoV1beta2UserSpecInitProviderInstanceSelectorPolicy:
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


schema SQLGcpUpboundIoV1beta2UserSpecInitProviderPasswordPolicy:
    r"""
    SQL gcp upbound io v1beta2 user spec init provider password policy

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


schema SQLGcpUpboundIoV1beta2UserSpecInitProviderPasswordSecretRef:
    r"""
    The password for the user. Can be updated. For Postgres
    instances this is a Required field, unless type is set to either CLOUD_IAM_USER
    or CLOUD_IAM_SERVICE_ACCOUNT. Don't set this field for CLOUD_IAM_USER
    and CLOUD_IAM_SERVICE_ACCOUNT user types for any Cloud SQL instance.

    Attributes
    ----------
    key : str, default is Undefined, required
        The key to select.
    name : str, default is Undefined, required
        Name of the secret.
    namespace : str, default is Undefined, required
        Namespace of the secret.
    """


    key: str

    name: str

    namespace: str


schema SQLGcpUpboundIoV1beta2UserSpecProviderConfigRef:
    r"""
    ProviderConfigReference specifies how the provider that will be used to
    create, observe, update, and delete this managed resource should be
    configured.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    policy : SQLGcpUpboundIoV1beta2UserSpecProviderConfigRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    policy?: SQLGcpUpboundIoV1beta2UserSpecProviderConfigRefPolicy


schema SQLGcpUpboundIoV1beta2UserSpecProviderConfigRefPolicy:
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


schema SQLGcpUpboundIoV1beta2UserSpecWriteConnectionSecretToRef:
    r"""
    WriteConnectionSecretToReference specifies the namespace and name of a
    Secret to which any connection details for this managed resource should
    be written. Connection details frequently include the endpoint, username,
    and password required to connect to the managed resource.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the secret.
    namespace : str, default is Undefined, required
        Namespace of the secret.
    """


    name: str

    namespace: str


schema SQLGcpUpboundIoV1beta2UserStatus:
    r"""
    UserStatus defines the observed state of User.

    Attributes
    ----------
    conditions : [SQLGcpUpboundIoV1beta2UserStatusConditionsItems0], default is Undefined, optional
        Conditions of the resource.
    observedGeneration : int, default is Undefined, optional
        ObservedGeneration is the latest metadata.generation
        which resulted in either a ready state, or stalled due to error
        it can not recover from without human intervention.
    atProvider : SQLGcpUpboundIoV1beta2UserStatusAtProvider, default is Undefined, optional
        at provider
    """


    conditions?: [SQLGcpUpboundIoV1beta2UserStatusConditionsItems0]

    observedGeneration?: int

    atProvider?: SQLGcpUpboundIoV1beta2UserStatusAtProvider


schema SQLGcpUpboundIoV1beta2UserStatusAtProvider:
    r"""
    SQL gcp upbound io v1beta2 user status at provider

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
    sqlServerUserDetails : [SQLGcpUpboundIoV1beta2UserStatusAtProviderSQLServerUserDetailsItems0], default is Undefined, optional
        sql server user details
    $type : str, default is Undefined, optional
        The user type. It determines the method to authenticate the
        user during login. The default is the database's built-in user type. Flags
        include "BUILT_IN", "CLOUD_IAM_USER", "CLOUD_IAM_SERVICE_ACCOUNT", "CLOUD_IAM_GROUP",
        "CLOUD_IAM_GROUP_USER" and "CLOUD_IAM_GROUP_SERVICE_ACCOUNT" for
        Postgres
        and MySQL.
    passwordPolicy : SQLGcpUpboundIoV1beta2UserStatusAtProviderPasswordPolicy, default is Undefined, optional
        password policy
    """


    deletionPolicy?: str

    host?: str

    id?: str

    instance?: str

    passwordWo?: str

    passwordWoVersion?: float

    project?: str

    sqlServerUserDetails?: [SQLGcpUpboundIoV1beta2UserStatusAtProviderSQLServerUserDetailsItems0]

    $type?: str

    passwordPolicy?: SQLGcpUpboundIoV1beta2UserStatusAtProviderPasswordPolicy


schema SQLGcpUpboundIoV1beta2UserStatusAtProviderPasswordPolicy:
    r"""
    SQL gcp upbound io v1beta2 user status at provider password policy

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
    status : [SQLGcpUpboundIoV1beta2UserStatusAtProviderPasswordPolicyStatusItems0], default is Undefined, optional
        status
    """


    allowedFailedAttempts?: float

    enableFailedAttemptsCheck?: bool

    enablePasswordVerification?: bool

    passwordExpirationDuration?: str

    status?: [SQLGcpUpboundIoV1beta2UserStatusAtProviderPasswordPolicyStatusItems0]


schema SQLGcpUpboundIoV1beta2UserStatusAtProviderPasswordPolicyStatusItems0:
    r"""
    SQL gcp upbound io v1beta2 user status at provider password policy status items0

    Attributes
    ----------
    locked : bool, default is Undefined, optional
        (read only) If true, user does not have login privileges.
    passwordExpirationTime : str, default is Undefined, optional
        (read only) Password expiration duration with one week grace period.
    """


    locked?: bool

    passwordExpirationTime?: str


schema SQLGcpUpboundIoV1beta2UserStatusAtProviderSQLServerUserDetailsItems0:
    r"""
    SQL gcp upbound io v1beta2 user status at provider SQL server user details items0

    Attributes
    ----------
    disabled : bool, default is Undefined, optional
        disabled
    serverRoles : [str], default is Undefined, optional
        server roles
    """


    disabled?: bool

    serverRoles?: [str]


schema SQLGcpUpboundIoV1beta2UserStatusConditionsItems0:
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






schema SQLGcpUpboundIoV1beta1UserSpec:
    r"""
    UserSpec defines the desired state of User

    Attributes
    ----------
    deletionPolicy : str, default is "Delete", optional
        DeletionPolicy specifies what will happen to the underlying external
        when this managed resource is deleted - either "Delete" or "Orphan" the
        external resource.
        This field is planned to be deprecated in favor of the ManagementPolicies
        field in a future release. Currently, both could be set independently and
        non-default values would be honored if the feature flag is enabled.
        See the design doc for more information: https://github.com/crossplane/crossplane/blob/499895a25d1a1a0ba1604944ef98ac7a1a71f197/design/design-doc-observe-only-resources.md?plain=1#L223
    managementPolicies : [str], default is ["*"], optional
        THIS IS A BETA FIELD. It is on by default but can be opted out
        through a Crossplane feature flag.
        ManagementPolicies specify the array of actions Crossplane is allowed to
        take on the managed and external resources.
        This field is planned to replace the DeletionPolicy field in a future
        release. Currently, both could be set independently and non-default
        values would be honored if the feature flag is enabled. If both are
        custom, the DeletionPolicy field will be ignored.
        See the design doc for more information: https://github.com/crossplane/crossplane/blob/499895a25d1a1a0ba1604944ef98ac7a1a71f197/design/design-doc-observe-only-resources.md?plain=1#L223
        and this one: https://github.com/crossplane/crossplane/blob/444267e84783136daa93568b364a5f01228cacbe/design/one-pager-ignore-changes.md
    forProvider : SQLGcpUpboundIoV1beta1UserSpecForProvider, default is Undefined, required
        for provider
    initProvider : SQLGcpUpboundIoV1beta1UserSpecInitProvider, default is Undefined, optional
        init provider
    providerConfigRef : SQLGcpUpboundIoV1beta1UserSpecProviderConfigRef, default is Undefined, optional
        provider config ref
    writeConnectionSecretToRef : SQLGcpUpboundIoV1beta1UserSpecWriteConnectionSecretToRef, default is Undefined, optional
        write connection secret to ref
    """


    deletionPolicy?: "Orphan" | "Delete" = "Delete"

    managementPolicies?: [str] = ["*"]

    forProvider: SQLGcpUpboundIoV1beta1UserSpecForProvider

    initProvider?: SQLGcpUpboundIoV1beta1UserSpecInitProvider

    providerConfigRef?: SQLGcpUpboundIoV1beta1UserSpecProviderConfigRef

    writeConnectionSecretToRef?: SQLGcpUpboundIoV1beta1UserSpecWriteConnectionSecretToRef


schema SQLGcpUpboundIoV1beta1UserSpecForProvider:
    r"""
    SQL gcp upbound io v1beta1 user spec for provider

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
    passwordPolicy : [SQLGcpUpboundIoV1beta1UserSpecForProviderPasswordPolicyItems0], default is Undefined, optional
        password policy
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
    instanceRef : SQLGcpUpboundIoV1beta1UserSpecForProviderInstanceRef, default is Undefined, optional
        instance ref
    instanceSelector : SQLGcpUpboundIoV1beta1UserSpecForProviderInstanceSelector, default is Undefined, optional
        instance selector
    passwordSecretRef : SQLGcpUpboundIoV1beta1UserSpecForProviderPasswordSecretRef, default is Undefined, optional
        password secret ref
    """


    deletionPolicy?: str

    host?: str

    instance?: str

    passwordPolicy?: [SQLGcpUpboundIoV1beta1UserSpecForProviderPasswordPolicyItems0]

    passwordWo?: str

    passwordWoVersion?: float

    project?: str

    $type?: str

    instanceRef?: SQLGcpUpboundIoV1beta1UserSpecForProviderInstanceRef

    instanceSelector?: SQLGcpUpboundIoV1beta1UserSpecForProviderInstanceSelector

    passwordSecretRef?: SQLGcpUpboundIoV1beta1UserSpecForProviderPasswordSecretRef


schema SQLGcpUpboundIoV1beta1UserSpecForProviderInstanceRef:
    r"""
    Reference to a DatabaseInstance in sql to populate instance.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    policy : SQLGcpUpboundIoV1beta1UserSpecForProviderInstanceRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    policy?: SQLGcpUpboundIoV1beta1UserSpecForProviderInstanceRefPolicy


schema SQLGcpUpboundIoV1beta1UserSpecForProviderInstanceRefPolicy:
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


schema SQLGcpUpboundIoV1beta1UserSpecForProviderInstanceSelector:
    r"""
    Selector for a DatabaseInstance in sql to populate instance.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    policy : SQLGcpUpboundIoV1beta1UserSpecForProviderInstanceSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    policy?: SQLGcpUpboundIoV1beta1UserSpecForProviderInstanceSelectorPolicy


schema SQLGcpUpboundIoV1beta1UserSpecForProviderInstanceSelectorPolicy:
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


schema SQLGcpUpboundIoV1beta1UserSpecForProviderPasswordPolicyItems0:
    r"""
    SQL gcp upbound io v1beta1 user spec for provider password policy items0

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


schema SQLGcpUpboundIoV1beta1UserSpecForProviderPasswordSecretRef:
    r"""
    The password for the user. Can be updated. For Postgres
    instances this is a Required field, unless type is set to either CLOUD_IAM_USER
    or CLOUD_IAM_SERVICE_ACCOUNT. Don't set this field for CLOUD_IAM_USER
    and CLOUD_IAM_SERVICE_ACCOUNT user types for any Cloud SQL instance.

    Attributes
    ----------
    key : str, default is Undefined, required
        The key to select.
    name : str, default is Undefined, required
        Name of the secret.
    namespace : str, default is Undefined, required
        Namespace of the secret.
    """


    key: str

    name: str

    namespace: str


schema SQLGcpUpboundIoV1beta1UserSpecInitProvider:
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
    passwordPolicy : [SQLGcpUpboundIoV1beta1UserSpecInitProviderPasswordPolicyItems0], default is Undefined, optional
        password policy
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
    instanceRef : SQLGcpUpboundIoV1beta1UserSpecInitProviderInstanceRef, default is Undefined, optional
        instance ref
    instanceSelector : SQLGcpUpboundIoV1beta1UserSpecInitProviderInstanceSelector, default is Undefined, optional
        instance selector
    passwordSecretRef : SQLGcpUpboundIoV1beta1UserSpecInitProviderPasswordSecretRef, default is Undefined, optional
        password secret ref
    """


    deletionPolicy?: str

    host?: str

    instance?: str

    passwordPolicy?: [SQLGcpUpboundIoV1beta1UserSpecInitProviderPasswordPolicyItems0]

    passwordWo?: str

    passwordWoVersion?: float

    project?: str

    $type?: str

    instanceRef?: SQLGcpUpboundIoV1beta1UserSpecInitProviderInstanceRef

    instanceSelector?: SQLGcpUpboundIoV1beta1UserSpecInitProviderInstanceSelector

    passwordSecretRef?: SQLGcpUpboundIoV1beta1UserSpecInitProviderPasswordSecretRef


schema SQLGcpUpboundIoV1beta1UserSpecInitProviderInstanceRef:
    r"""
    Reference to a DatabaseInstance in sql to populate instance.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    policy : SQLGcpUpboundIoV1beta1UserSpecInitProviderInstanceRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    policy?: SQLGcpUpboundIoV1beta1UserSpecInitProviderInstanceRefPolicy


schema SQLGcpUpboundIoV1beta1UserSpecInitProviderInstanceRefPolicy:
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


schema SQLGcpUpboundIoV1beta1UserSpecInitProviderInstanceSelector:
    r"""
    Selector for a DatabaseInstance in sql to populate instance.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    policy : SQLGcpUpboundIoV1beta1UserSpecInitProviderInstanceSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    policy?: SQLGcpUpboundIoV1beta1UserSpecInitProviderInstanceSelectorPolicy


schema SQLGcpUpboundIoV1beta1UserSpecInitProviderInstanceSelectorPolicy:
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


schema SQLGcpUpboundIoV1beta1UserSpecInitProviderPasswordPolicyItems0:
    r"""
    SQL gcp upbound io v1beta1 user spec init provider password policy items0

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


schema SQLGcpUpboundIoV1beta1UserSpecInitProviderPasswordSecretRef:
    r"""
    The password for the user. Can be updated. For Postgres
    instances this is a Required field, unless type is set to either CLOUD_IAM_USER
    or CLOUD_IAM_SERVICE_ACCOUNT. Don't set this field for CLOUD_IAM_USER
    and CLOUD_IAM_SERVICE_ACCOUNT user types for any Cloud SQL instance.

    Attributes
    ----------
    key : str, default is Undefined, required
        The key to select.
    name : str, default is Undefined, required
        Name of the secret.
    namespace : str, default is Undefined, required
        Namespace of the secret.
    """


    key: str

    name: str

    namespace: str


schema SQLGcpUpboundIoV1beta1UserSpecProviderConfigRef:
    r"""
    ProviderConfigReference specifies how the provider that will be used to
    create, observe, update, and delete this managed resource should be
    configured.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    policy : SQLGcpUpboundIoV1beta1UserSpecProviderConfigRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    policy?: SQLGcpUpboundIoV1beta1UserSpecProviderConfigRefPolicy


schema SQLGcpUpboundIoV1beta1UserSpecProviderConfigRefPolicy:
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


schema SQLGcpUpboundIoV1beta1UserSpecWriteConnectionSecretToRef:
    r"""
    WriteConnectionSecretToReference specifies the namespace and name of a
    Secret to which any connection details for this managed resource should
    be written. Connection details frequently include the endpoint, username,
    and password required to connect to the managed resource.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the secret.
    namespace : str, default is Undefined, required
        Namespace of the secret.
    """


    name: str

    namespace: str


schema SQLGcpUpboundIoV1beta1UserStatus:
    r"""
    UserStatus defines the observed state of User.

    Attributes
    ----------
    conditions : [SQLGcpUpboundIoV1beta1UserStatusConditionsItems0], default is Undefined, optional
        Conditions of the resource.
    observedGeneration : int, default is Undefined, optional
        ObservedGeneration is the latest metadata.generation
        which resulted in either a ready state, or stalled due to error
        it can not recover from without human intervention.
    atProvider : SQLGcpUpboundIoV1beta1UserStatusAtProvider, default is Undefined, optional
        at provider
    """


    conditions?: [SQLGcpUpboundIoV1beta1UserStatusConditionsItems0]

    observedGeneration?: int

    atProvider?: SQLGcpUpboundIoV1beta1UserStatusAtProvider


schema SQLGcpUpboundIoV1beta1UserStatusAtProvider:
    r"""
    SQL gcp upbound io v1beta1 user status at provider

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
    passwordPolicy : [SQLGcpUpboundIoV1beta1UserStatusAtProviderPasswordPolicyItems0], default is Undefined, optional
        password policy
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
    sqlServerUserDetails : [SQLGcpUpboundIoV1beta1UserStatusAtProviderSQLServerUserDetailsItems0], default is Undefined, optional
        sql server user details
    $type : str, default is Undefined, optional
        The user type. It determines the method to authenticate the
        user during login. The default is the database's built-in user type. Flags
        include "BUILT_IN", "CLOUD_IAM_USER", "CLOUD_IAM_SERVICE_ACCOUNT", "CLOUD_IAM_GROUP",
        "CLOUD_IAM_GROUP_USER" and "CLOUD_IAM_GROUP_SERVICE_ACCOUNT" for
        Postgres
        and MySQL.
    """


    deletionPolicy?: str

    host?: str

    id?: str

    instance?: str

    passwordPolicy?: [SQLGcpUpboundIoV1beta1UserStatusAtProviderPasswordPolicyItems0]

    passwordWo?: str

    passwordWoVersion?: float

    project?: str

    sqlServerUserDetails?: [SQLGcpUpboundIoV1beta1UserStatusAtProviderSQLServerUserDetailsItems0]

    $type?: str


schema SQLGcpUpboundIoV1beta1UserStatusAtProviderPasswordPolicyItems0:
    r"""
    SQL gcp upbound io v1beta1 user status at provider password policy items0

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
    status : [SQLGcpUpboundIoV1beta1UserStatusAtProviderPasswordPolicyItems0StatusItems0], default is Undefined, optional
        status
    """


    allowedFailedAttempts?: float

    enableFailedAttemptsCheck?: bool

    enablePasswordVerification?: bool

    passwordExpirationDuration?: str

    status?: [SQLGcpUpboundIoV1beta1UserStatusAtProviderPasswordPolicyItems0StatusItems0]


schema SQLGcpUpboundIoV1beta1UserStatusAtProviderPasswordPolicyItems0StatusItems0:
    r"""
    SQL gcp upbound io v1beta1 user status at provider password policy items0 status items0

    Attributes
    ----------
    locked : bool, default is Undefined, optional
        (read only) If true, user does not have login privileges.
    passwordExpirationTime : str, default is Undefined, optional
        (read only) Password expiration duration with one week grace period.
    """


    locked?: bool

    passwordExpirationTime?: str


schema SQLGcpUpboundIoV1beta1UserStatusAtProviderSQLServerUserDetailsItems0:
    r"""
    SQL gcp upbound io v1beta1 user status at provider SQL server user details items0

    Attributes
    ----------
    disabled : bool, default is Undefined, optional
        disabled
    serverRoles : [str], default is Undefined, optional
        server roles
    """


    disabled?: bool

    serverRoles?: [str]


schema SQLGcpUpboundIoV1beta1UserStatusConditionsItems0:
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






schema ServiceNetworkingPeeredDNSDomain:
    r"""
    ServiceNetworkingPeeredDNSDomain is the Schema for the ServiceNetworkingPeeredDNSDomains API. Allows management of a single peered DNS domain on a project.

    Attributes
    ----------
    apiVersion : str, default is "cloudplatform.gcp.upbound.io/v1beta1", required
        APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
    kind : str, default is "ServiceNetworkingPeeredDNSDomain", required
        Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
    metadata : v1.ObjectMeta, default is Undefined, optional
        metadata
    spec : CloudplatformGcpUpboundIoV1beta1ServiceNetworkingPeeredDNSDomainSpec, default is Undefined, required
        spec
    status : CloudplatformGcpUpboundIoV1beta1ServiceNetworkingPeeredDNSDomainStatus, default is Undefined, optional
        status
    """


    apiVersion: "cloudplatform.gcp.upbound.io/v1beta1" = "cloudplatform.gcp.upbound.io/v1beta1"

    kind: "ServiceNetworkingPeeredDNSDomain" = "ServiceNetworkingPeeredDNSDomain"

    metadata?: v1.ObjectMeta

    spec: CloudplatformGcpUpboundIoV1beta1ServiceNetworkingPeeredDNSDomainSpec

    status?: CloudplatformGcpUpboundIoV1beta1ServiceNetworkingPeeredDNSDomainStatus


schema CloudplatformGcpUpboundIoV1beta1ServiceNetworkingPeeredDNSDomainSpec:
    r"""
    ServiceNetworkingPeeredDNSDomainSpec defines the desired state of ServiceNetworkingPeeredDNSDomain

    Attributes
    ----------
    deletionPolicy : str, default is "Delete", optional
        DeletionPolicy specifies what will happen to the underlying external
        when this managed resource is deleted - either "Delete" or "Orphan" the
        external resource.
        This field is planned to be deprecated in favor of the ManagementPolicies
        field in a future release. Currently, both could be set independently and
        non-default values would be honored if the feature flag is enabled.
        See the design doc for more information: https://github.com/crossplane/crossplane/blob/499895a25d1a1a0ba1604944ef98ac7a1a71f197/design/design-doc-observe-only-resources.md?plain=1#L223
    managementPolicies : [str], default is ["*"], optional
        THIS IS A BETA FIELD. It is on by default but can be opted out
        through a Crossplane feature flag.
        ManagementPolicies specify the array of actions Crossplane is allowed to
        take on the managed and external resources.
        This field is planned to replace the DeletionPolicy field in a future
        release. Currently, both could be set independently and non-default
        values would be honored if the feature flag is enabled. If both are
        custom, the DeletionPolicy field will be ignored.
        See the design doc for more information: https://github.com/crossplane/crossplane/blob/499895a25d1a1a0ba1604944ef98ac7a1a71f197/design/design-doc-observe-only-resources.md?plain=1#L223
        and this one: https://github.com/crossplane/crossplane/blob/444267e84783136daa93568b364a5f01228cacbe/design/one-pager-ignore-changes.md
    forProvider : CloudplatformGcpUpboundIoV1beta1ServiceNetworkingPeeredDNSDomainSpecForProvider, default is Undefined, required
        for provider
    initProvider : CloudplatformGcpUpboundIoV1beta1ServiceNetworkingPeeredDNSDomainSpecInitProvider, default is Undefined, optional
        init provider
    providerConfigRef : CloudplatformGcpUpboundIoV1beta1ServiceNetworkingPeeredDNSDomainSpecProviderConfigRef, default is Undefined, optional
        provider config ref
    writeConnectionSecretToRef : CloudplatformGcpUpboundIoV1beta1ServiceNetworkingPeeredDNSDomainSpecWriteConnectionSecretToRef, default is Undefined, optional
        write connection secret to ref
    """


    deletionPolicy?: "Orphan" | "Delete" = "Delete"

    managementPolicies?: [str] = ["*"]

    forProvider: CloudplatformGcpUpboundIoV1beta1ServiceNetworkingPeeredDNSDomainSpecForProvider

    initProvider?: CloudplatformGcpUpboundIoV1beta1ServiceNetworkingPeeredDNSDomainSpecInitProvider

    providerConfigRef?: CloudplatformGcpUpboundIoV1beta1ServiceNetworkingPeeredDNSDomainSpecProviderConfigRef

    writeConnectionSecretToRef?: CloudplatformGcpUpboundIoV1beta1ServiceNetworkingPeeredDNSDomainSpecWriteConnectionSecretToRef


schema CloudplatformGcpUpboundIoV1beta1ServiceNetworkingPeeredDNSDomainSpecForProvider:
    r"""
    cloudplatform gcp upbound io v1beta1 service networking peered DNS domain spec for provider

    Attributes
    ----------
    dnsSuffix : str, default is Undefined, optional
        The DNS domain suffix of the peered DNS domain. Make sure to suffix with a . (dot).
    network : str, default is Undefined, required
        The network in the consumer project.
    project : str, default is Undefined, optional
        The producer project number. If not provided, the provider project is used.
    service : str, default is Undefined, required
        Private service connection between service and consumer network, defaults to servicenetworking.googleapis.com
    """


    dnsSuffix?: str

    network: str

    project?: str

    service: str


schema CloudplatformGcpUpboundIoV1beta1ServiceNetworkingPeeredDNSDomainSpecInitProvider:
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
    dnsSuffix : str, default is Undefined, optional
        The DNS domain suffix of the peered DNS domain. Make sure to suffix with a . (dot).
    project : str, default is Undefined, optional
        The producer project number. If not provided, the provider project is used.
    """


    dnsSuffix?: str

    project?: str


schema CloudplatformGcpUpboundIoV1beta1ServiceNetworkingPeeredDNSDomainSpecProviderConfigRef:
    r"""
    ProviderConfigReference specifies how the provider that will be used to
    create, observe, update, and delete this managed resource should be
    configured.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    policy : CloudplatformGcpUpboundIoV1beta1ServiceNetworkingPeeredDNSDomainSpecProviderConfigRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    policy?: CloudplatformGcpUpboundIoV1beta1ServiceNetworkingPeeredDNSDomainSpecProviderConfigRefPolicy


schema CloudplatformGcpUpboundIoV1beta1ServiceNetworkingPeeredDNSDomainSpecProviderConfigRefPolicy:
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


schema CloudplatformGcpUpboundIoV1beta1ServiceNetworkingPeeredDNSDomainSpecWriteConnectionSecretToRef:
    r"""
    WriteConnectionSecretToReference specifies the namespace and name of a
    Secret to which any connection details for this managed resource should
    be written. Connection details frequently include the endpoint, username,
    and password required to connect to the managed resource.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the secret.
    namespace : str, default is Undefined, required
        Namespace of the secret.
    """


    name: str

    namespace: str


schema CloudplatformGcpUpboundIoV1beta1ServiceNetworkingPeeredDNSDomainStatus:
    r"""
    ServiceNetworkingPeeredDNSDomainStatus defines the observed state of ServiceNetworkingPeeredDNSDomain.

    Attributes
    ----------
    conditions : [CloudplatformGcpUpboundIoV1beta1ServiceNetworkingPeeredDNSDomainStatusConditionsItems0], default is Undefined, optional
        Conditions of the resource.
    observedGeneration : int, default is Undefined, optional
        ObservedGeneration is the latest metadata.generation
        which resulted in either a ready state, or stalled due to error
        it can not recover from without human intervention.
    atProvider : CloudplatformGcpUpboundIoV1beta1ServiceNetworkingPeeredDNSDomainStatusAtProvider, default is Undefined, optional
        at provider
    """


    conditions?: [CloudplatformGcpUpboundIoV1beta1ServiceNetworkingPeeredDNSDomainStatusConditionsItems0]

    observedGeneration?: int

    atProvider?: CloudplatformGcpUpboundIoV1beta1ServiceNetworkingPeeredDNSDomainStatusAtProvider


schema CloudplatformGcpUpboundIoV1beta1ServiceNetworkingPeeredDNSDomainStatusAtProvider:
    r"""
    cloudplatform gcp upbound io v1beta1 service networking peered DNS domain status at provider

    Attributes
    ----------
    dnsSuffix : str, default is Undefined, optional
        The DNS domain suffix of the peered DNS domain. Make sure to suffix with a . (dot).
    id : str, default is Undefined, optional
        an identifier for the resource with format services/{{service}}/projects/{{project}}/global/networks/{{network}}/peeredDnsDomains/{{name}}
    network : str, default is Undefined, optional
        The network in the consumer project.
    parent : str, default is Undefined, optional
        an identifier for the resource with format services/{{service}}/projects/{{project}}/global/networks/{{network}}
    project : str, default is Undefined, optional
        The producer project number. If not provided, the provider project is used.
    service : str, default is Undefined, optional
        Private service connection between service and consumer network, defaults to servicenetworking.googleapis.com
    """


    dnsSuffix?: str

    id?: str

    network?: str

    parent?: str

    project?: str

    service?: str


schema CloudplatformGcpUpboundIoV1beta1ServiceNetworkingPeeredDNSDomainStatusConditionsItems0:
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






schema SecretCiphertext:
    r"""
    SecretCiphertext is the Schema for the SecretCiphertexts API. Encrypts secret data with Google Cloud KMS and provides access to the ciphertext.

    Attributes
    ----------
    apiVersion : str, default is "kms.gcp.upbound.io/v1beta1", required
        APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
    kind : str, default is "SecretCiphertext", required
        Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
    metadata : v1.ObjectMeta, default is Undefined, optional
        metadata
    spec : KmsGcpUpboundIoV1beta1SecretCiphertextSpec, default is Undefined, required
        spec
    status : KmsGcpUpboundIoV1beta1SecretCiphertextStatus, default is Undefined, optional
        status
    """


    apiVersion: "kms.gcp.upbound.io/v1beta1" = "kms.gcp.upbound.io/v1beta1"

    kind: "SecretCiphertext" = "SecretCiphertext"

    metadata?: v1.ObjectMeta

    spec: KmsGcpUpboundIoV1beta1SecretCiphertextSpec

    status?: KmsGcpUpboundIoV1beta1SecretCiphertextStatus


schema KmsGcpUpboundIoV1beta1SecretCiphertextSpec:
    r"""
    SecretCiphertextSpec defines the desired state of SecretCiphertext

    Attributes
    ----------
    deletionPolicy : str, default is "Delete", optional
        DeletionPolicy specifies what will happen to the underlying external
        when this managed resource is deleted - either "Delete" or "Orphan" the
        external resource.
        This field is planned to be deprecated in favor of the ManagementPolicies
        field in a future release. Currently, both could be set independently and
        non-default values would be honored if the feature flag is enabled.
        See the design doc for more information: https://github.com/crossplane/crossplane/blob/499895a25d1a1a0ba1604944ef98ac7a1a71f197/design/design-doc-observe-only-resources.md?plain=1#L223
    managementPolicies : [str], default is ["*"], optional
        THIS IS A BETA FIELD. It is on by default but can be opted out
        through a Crossplane feature flag.
        ManagementPolicies specify the array of actions Crossplane is allowed to
        take on the managed and external resources.
        This field is planned to replace the DeletionPolicy field in a future
        release. Currently, both could be set independently and non-default
        values would be honored if the feature flag is enabled. If both are
        custom, the DeletionPolicy field will be ignored.
        See the design doc for more information: https://github.com/crossplane/crossplane/blob/499895a25d1a1a0ba1604944ef98ac7a1a71f197/design/design-doc-observe-only-resources.md?plain=1#L223
        and this one: https://github.com/crossplane/crossplane/blob/444267e84783136daa93568b364a5f01228cacbe/design/one-pager-ignore-changes.md
    forProvider : KmsGcpUpboundIoV1beta1SecretCiphertextSpecForProvider, default is Undefined, required
        for provider
    initProvider : KmsGcpUpboundIoV1beta1SecretCiphertextSpecInitProvider, default is Undefined, optional
        init provider
    providerConfigRef : KmsGcpUpboundIoV1beta1SecretCiphertextSpecProviderConfigRef, default is Undefined, optional
        provider config ref
    writeConnectionSecretToRef : KmsGcpUpboundIoV1beta1SecretCiphertextSpecWriteConnectionSecretToRef, default is Undefined, optional
        write connection secret to ref
    """


    deletionPolicy?: "Orphan" | "Delete" = "Delete"

    managementPolicies?: [str] = ["*"]

    forProvider: KmsGcpUpboundIoV1beta1SecretCiphertextSpecForProvider

    initProvider?: KmsGcpUpboundIoV1beta1SecretCiphertextSpecInitProvider

    providerConfigRef?: KmsGcpUpboundIoV1beta1SecretCiphertextSpecProviderConfigRef

    writeConnectionSecretToRef?: KmsGcpUpboundIoV1beta1SecretCiphertextSpecWriteConnectionSecretToRef


schema KmsGcpUpboundIoV1beta1SecretCiphertextSpecForProvider:
    r"""
    kms gcp upbound io v1beta1 secret ciphertext spec for provider

    Attributes
    ----------
    cryptoKey : str, default is Undefined, optional
        The full name of the CryptoKey that will be used to encrypt the provided plaintext.
        Format: 'projects/{{project}}/locations/{{location}}/keyRings/{{keyRing}}/cryptoKeys/{{cryptoKey}}'
    plaintext : str, default is Undefined, optional
        The plaintext to be encrypted.
        Note: This property is sensitive and will not be displayed in the plan.
    additionalAuthenticatedDataSecretRef : KmsGcpUpboundIoV1beta1SecretCiphertextSpecForProviderAdditionalAuthenticatedDataSecretRef, default is Undefined, optional
        additional authenticated data secret ref
    cryptoKeyRef : KmsGcpUpboundIoV1beta1SecretCiphertextSpecForProviderCryptoKeyRef, default is Undefined, optional
        crypto key ref
    cryptoKeySelector : KmsGcpUpboundIoV1beta1SecretCiphertextSpecForProviderCryptoKeySelector, default is Undefined, optional
        crypto key selector
    """


    cryptoKey?: str

    plaintext?: str

    additionalAuthenticatedDataSecretRef?: KmsGcpUpboundIoV1beta1SecretCiphertextSpecForProviderAdditionalAuthenticatedDataSecretRef

    cryptoKeyRef?: KmsGcpUpboundIoV1beta1SecretCiphertextSpecForProviderCryptoKeyRef

    cryptoKeySelector?: KmsGcpUpboundIoV1beta1SecretCiphertextSpecForProviderCryptoKeySelector


schema KmsGcpUpboundIoV1beta1SecretCiphertextSpecForProviderAdditionalAuthenticatedDataSecretRef:
    r"""
    The additional authenticated data used for integrity checks during encryption and decryption.
    Note: This property is sensitive and will not be displayed in the plan.

    Attributes
    ----------
    key : str, default is Undefined, required
        The key to select.
    name : str, default is Undefined, required
        Name of the secret.
    namespace : str, default is Undefined, required
        Namespace of the secret.
    """


    key: str

    name: str

    namespace: str


schema KmsGcpUpboundIoV1beta1SecretCiphertextSpecForProviderCryptoKeyRef:
    r"""
    Reference to a CryptoKey in kms to populate cryptoKey.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    policy : KmsGcpUpboundIoV1beta1SecretCiphertextSpecForProviderCryptoKeyRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    policy?: KmsGcpUpboundIoV1beta1SecretCiphertextSpecForProviderCryptoKeyRefPolicy


schema KmsGcpUpboundIoV1beta1SecretCiphertextSpecForProviderCryptoKeyRefPolicy:
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


schema KmsGcpUpboundIoV1beta1SecretCiphertextSpecForProviderCryptoKeySelector:
    r"""
    Selector for a CryptoKey in kms to populate cryptoKey.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    policy : KmsGcpUpboundIoV1beta1SecretCiphertextSpecForProviderCryptoKeySelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    policy?: KmsGcpUpboundIoV1beta1SecretCiphertextSpecForProviderCryptoKeySelectorPolicy


schema KmsGcpUpboundIoV1beta1SecretCiphertextSpecForProviderCryptoKeySelectorPolicy:
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


schema KmsGcpUpboundIoV1beta1SecretCiphertextSpecInitProvider:
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
    cryptoKey : str, default is Undefined, optional
        The full name of the CryptoKey that will be used to encrypt the provided plaintext.
        Format: 'projects/{{project}}/locations/{{location}}/keyRings/{{keyRing}}/cryptoKeys/{{cryptoKey}}'
    plaintext : str, default is Undefined, optional
        The plaintext to be encrypted.
        Note: This property is sensitive and will not be displayed in the plan.
    additionalAuthenticatedDataSecretRef : KmsGcpUpboundIoV1beta1SecretCiphertextSpecInitProviderAdditionalAuthenticatedDataSecretRef, default is Undefined, optional
        additional authenticated data secret ref
    cryptoKeyRef : KmsGcpUpboundIoV1beta1SecretCiphertextSpecInitProviderCryptoKeyRef, default is Undefined, optional
        crypto key ref
    cryptoKeySelector : KmsGcpUpboundIoV1beta1SecretCiphertextSpecInitProviderCryptoKeySelector, default is Undefined, optional
        crypto key selector
    """


    cryptoKey?: str

    plaintext?: str

    additionalAuthenticatedDataSecretRef?: KmsGcpUpboundIoV1beta1SecretCiphertextSpecInitProviderAdditionalAuthenticatedDataSecretRef

    cryptoKeyRef?: KmsGcpUpboundIoV1beta1SecretCiphertextSpecInitProviderCryptoKeyRef

    cryptoKeySelector?: KmsGcpUpboundIoV1beta1SecretCiphertextSpecInitProviderCryptoKeySelector


schema KmsGcpUpboundIoV1beta1SecretCiphertextSpecInitProviderAdditionalAuthenticatedDataSecretRef:
    r"""
    The additional authenticated data used for integrity checks during encryption and decryption.
    Note: This property is sensitive and will not be displayed in the plan.

    Attributes
    ----------
    key : str, default is Undefined, required
        The key to select.
    name : str, default is Undefined, required
        Name of the secret.
    namespace : str, default is Undefined, required
        Namespace of the secret.
    """


    key: str

    name: str

    namespace: str


schema KmsGcpUpboundIoV1beta1SecretCiphertextSpecInitProviderCryptoKeyRef:
    r"""
    Reference to a CryptoKey in kms to populate cryptoKey.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    policy : KmsGcpUpboundIoV1beta1SecretCiphertextSpecInitProviderCryptoKeyRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    policy?: KmsGcpUpboundIoV1beta1SecretCiphertextSpecInitProviderCryptoKeyRefPolicy


schema KmsGcpUpboundIoV1beta1SecretCiphertextSpecInitProviderCryptoKeyRefPolicy:
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


schema KmsGcpUpboundIoV1beta1SecretCiphertextSpecInitProviderCryptoKeySelector:
    r"""
    Selector for a CryptoKey in kms to populate cryptoKey.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    policy : KmsGcpUpboundIoV1beta1SecretCiphertextSpecInitProviderCryptoKeySelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    policy?: KmsGcpUpboundIoV1beta1SecretCiphertextSpecInitProviderCryptoKeySelectorPolicy


schema KmsGcpUpboundIoV1beta1SecretCiphertextSpecInitProviderCryptoKeySelectorPolicy:
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


schema KmsGcpUpboundIoV1beta1SecretCiphertextSpecProviderConfigRef:
    r"""
    ProviderConfigReference specifies how the provider that will be used to
    create, observe, update, and delete this managed resource should be
    configured.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    policy : KmsGcpUpboundIoV1beta1SecretCiphertextSpecProviderConfigRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    policy?: KmsGcpUpboundIoV1beta1SecretCiphertextSpecProviderConfigRefPolicy


schema KmsGcpUpboundIoV1beta1SecretCiphertextSpecProviderConfigRefPolicy:
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


schema KmsGcpUpboundIoV1beta1SecretCiphertextSpecWriteConnectionSecretToRef:
    r"""
    WriteConnectionSecretToReference specifies the namespace and name of a
    Secret to which any connection details for this managed resource should
    be written. Connection details frequently include the endpoint, username,
    and password required to connect to the managed resource.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the secret.
    namespace : str, default is Undefined, required
        Namespace of the secret.
    """


    name: str

    namespace: str


schema KmsGcpUpboundIoV1beta1SecretCiphertextStatus:
    r"""
    SecretCiphertextStatus defines the observed state of SecretCiphertext.

    Attributes
    ----------
    conditions : [KmsGcpUpboundIoV1beta1SecretCiphertextStatusConditionsItems0], default is Undefined, optional
        Conditions of the resource.
    observedGeneration : int, default is Undefined, optional
        ObservedGeneration is the latest metadata.generation
        which resulted in either a ready state, or stalled due to error
        it can not recover from without human intervention.
    atProvider : KmsGcpUpboundIoV1beta1SecretCiphertextStatusAtProvider, default is Undefined, optional
        at provider
    """


    conditions?: [KmsGcpUpboundIoV1beta1SecretCiphertextStatusConditionsItems0]

    observedGeneration?: int

    atProvider?: KmsGcpUpboundIoV1beta1SecretCiphertextStatusAtProvider


schema KmsGcpUpboundIoV1beta1SecretCiphertextStatusAtProvider:
    r"""
    kms gcp upbound io v1beta1 secret ciphertext status at provider

    Attributes
    ----------
    ciphertext : str, default is Undefined, optional
        Contains the result of encrypting the provided plaintext, encoded in base64.
    cryptoKey : str, default is Undefined, optional
        The full name of the CryptoKey that will be used to encrypt the provided plaintext.
        Format: 'projects/{{project}}/locations/{{location}}/keyRings/{{keyRing}}/cryptoKeys/{{cryptoKey}}'
    id : str, default is Undefined, optional
        an identifier for the resource with format {{crypto_key}}/{{ciphertext}}
    plaintext : str, default is Undefined, optional
        The plaintext to be encrypted.
        Note: This property is sensitive and will not be displayed in the plan.
    """


    ciphertext?: str

    cryptoKey?: str

    id?: str

    plaintext?: str


schema KmsGcpUpboundIoV1beta1SecretCiphertextStatusConditionsItems0:
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






schema ProviderConfigUsage:
    r"""
    A ProviderConfigUsage indicates that a resource is using a ProviderConfig.

    Attributes
    ----------
    apiVersion : str, default is "kubernetes.m.crossplane.io/v1alpha1", required
        APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
    kind : str, default is "ProviderConfigUsage", required
        Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
    metadata : v1.ObjectMeta, default is Undefined, optional
        metadata
    providerConfigRef : KubernetesmCrossplaneIoV1alpha1ProviderConfigUsageProviderConfigRef, default is Undefined, required
        provider config ref
    resourceRef : KubernetesmCrossplaneIoV1alpha1ProviderConfigUsageResourceRef, default is Undefined, required
        resource ref
    """


    apiVersion: "kubernetes.m.crossplane.io/v1alpha1" = "kubernetes.m.crossplane.io/v1alpha1"

    kind: "ProviderConfigUsage" = "ProviderConfigUsage"

    metadata?: v1.ObjectMeta

    providerConfigRef: KubernetesmCrossplaneIoV1alpha1ProviderConfigUsageProviderConfigRef

    resourceRef: KubernetesmCrossplaneIoV1alpha1ProviderConfigUsageResourceRef


schema KubernetesmCrossplaneIoV1alpha1ProviderConfigUsageProviderConfigRef:
    r"""
    ProviderConfigReference to the provider config being used.

    Attributes
    ----------
    kind : str, default is Undefined, required
        Kind of the referenced object.
    name : str, default is Undefined, required
        Name of the referenced object.
    """


    kind: str

    name: str


schema KubernetesmCrossplaneIoV1alpha1ProviderConfigUsageResourceRef:
    r"""
    ResourceReference to the managed resource using the provider config.

    Attributes
    ----------
    apiVersion : str, default is Undefined, required
        APIVersion of the referenced object.
    kind : str, default is Undefined, required
        Kind of the referenced object.
    name : str, default is Undefined, required
        Name of the referenced object.
    uid : str, default is Undefined, optional
        UID of the referenced object.
    """


    apiVersion: str

    kind: str

    name: str

    uid?: str






schema GcpUpboundIoV1beta1ProviderConfigUsageProviderConfigRef:
    r"""
    ProviderConfigReference to the provider config being used.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    policy : GcpUpboundIoV1beta1ProviderConfigUsageProviderConfigRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    policy?: GcpUpboundIoV1beta1ProviderConfigUsageProviderConfigRefPolicy


schema GcpUpboundIoV1beta1ProviderConfigUsageProviderConfigRefPolicy:
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


schema GcpUpboundIoV1beta1ProviderConfigUsageResourceRef:
    r"""
    ResourceReference to the managed resource using the provider config.

    Attributes
    ----------
    apiVersion : str, default is Undefined, required
        APIVersion of the referenced object.
    kind : str, default is Undefined, required
        Kind of the referenced object.
    name : str, default is Undefined, required
        Name of the referenced object.
    uid : str, default is Undefined, optional
        UID of the referenced object.
    """


    apiVersion: str

    kind: str

    name: str

    uid?: str






schema ObjectACL:
    r"""
    ObjectACL is the Schema for the ObjectACLs API. Creates a new object ACL in Google Cloud Storage.

    Attributes
    ----------
    apiVersion : str, default is "storage.gcp.upbound.io/v1beta1", required
        APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
    kind : str, default is "ObjectACL", required
        Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
    metadata : v1.ObjectMeta, default is Undefined, optional
        metadata
    spec : StorageGcpUpboundIoV1beta1ObjectACLSpec, default is Undefined, required
        spec
    status : StorageGcpUpboundIoV1beta1ObjectACLStatus, default is Undefined, optional
        status
    """


    apiVersion: "storage.gcp.upbound.io/v1beta1" = "storage.gcp.upbound.io/v1beta1"

    kind: "ObjectACL" = "ObjectACL"

    metadata?: v1.ObjectMeta

    spec: StorageGcpUpboundIoV1beta1ObjectACLSpec

    status?: StorageGcpUpboundIoV1beta1ObjectACLStatus


schema StorageGcpUpboundIoV1beta1ObjectACLSpec:
    r"""
    ObjectACLSpec defines the desired state of ObjectACL

    Attributes
    ----------
    deletionPolicy : str, default is "Delete", optional
        DeletionPolicy specifies what will happen to the underlying external
        when this managed resource is deleted - either "Delete" or "Orphan" the
        external resource.
        This field is planned to be deprecated in favor of the ManagementPolicies
        field in a future release. Currently, both could be set independently and
        non-default values would be honored if the feature flag is enabled.
        See the design doc for more information: https://github.com/crossplane/crossplane/blob/499895a25d1a1a0ba1604944ef98ac7a1a71f197/design/design-doc-observe-only-resources.md?plain=1#L223
    managementPolicies : [str], default is ["*"], optional
        THIS IS A BETA FIELD. It is on by default but can be opted out
        through a Crossplane feature flag.
        ManagementPolicies specify the array of actions Crossplane is allowed to
        take on the managed and external resources.
        This field is planned to replace the DeletionPolicy field in a future
        release. Currently, both could be set independently and non-default
        values would be honored if the feature flag is enabled. If both are
        custom, the DeletionPolicy field will be ignored.
        See the design doc for more information: https://github.com/crossplane/crossplane/blob/499895a25d1a1a0ba1604944ef98ac7a1a71f197/design/design-doc-observe-only-resources.md?plain=1#L223
        and this one: https://github.com/crossplane/crossplane/blob/444267e84783136daa93568b364a5f01228cacbe/design/one-pager-ignore-changes.md
    forProvider : StorageGcpUpboundIoV1beta1ObjectACLSpecForProvider, default is Undefined, required
        for provider
    initProvider : StorageGcpUpboundIoV1beta1ObjectACLSpecInitProvider, default is Undefined, optional
        init provider
    providerConfigRef : StorageGcpUpboundIoV1beta1ObjectACLSpecProviderConfigRef, default is Undefined, optional
        provider config ref
    writeConnectionSecretToRef : StorageGcpUpboundIoV1beta1ObjectACLSpecWriteConnectionSecretToRef, default is Undefined, optional
        write connection secret to ref
    """


    deletionPolicy?: "Orphan" | "Delete" = "Delete"

    managementPolicies?: [str] = ["*"]

    forProvider: StorageGcpUpboundIoV1beta1ObjectACLSpecForProvider

    initProvider?: StorageGcpUpboundIoV1beta1ObjectACLSpecInitProvider

    providerConfigRef?: StorageGcpUpboundIoV1beta1ObjectACLSpecProviderConfigRef

    writeConnectionSecretToRef?: StorageGcpUpboundIoV1beta1ObjectACLSpecWriteConnectionSecretToRef


schema StorageGcpUpboundIoV1beta1ObjectACLSpecForProvider:
    r"""
    storage gcp upbound io v1beta1 object ACL spec for provider

    Attributes
    ----------
    bucket : str, default is Undefined, optional
        The name of the bucket the object is stored in.
    object : str, default is Undefined, optional
        The name of the object to apply the acl to.
    predefinedAcl : str, default is Undefined, optional
        The "canned" predefined ACL to apply. Must be set if role_entity is not.
    roleEntity : [str], default is Undefined, optional
        List of role/entity pairs in the form ROLE:entity. See GCS Object ACL documentation for more details.
        Must be set if predefined_acl is not.
    bucketRef : StorageGcpUpboundIoV1beta1ObjectACLSpecForProviderBucketRef, default is Undefined, optional
        bucket ref
    bucketSelector : StorageGcpUpboundIoV1beta1ObjectACLSpecForProviderBucketSelector, default is Undefined, optional
        bucket selector
    objectRef : StorageGcpUpboundIoV1beta1ObjectACLSpecForProviderObjectRef, default is Undefined, optional
        object ref
    objectSelector : StorageGcpUpboundIoV1beta1ObjectACLSpecForProviderObjectSelector, default is Undefined, optional
        object selector
    """


    bucket?: str

    object?: str

    predefinedAcl?: str

    roleEntity?: [str]

    bucketRef?: StorageGcpUpboundIoV1beta1ObjectACLSpecForProviderBucketRef

    bucketSelector?: StorageGcpUpboundIoV1beta1ObjectACLSpecForProviderBucketSelector

    objectRef?: StorageGcpUpboundIoV1beta1ObjectACLSpecForProviderObjectRef

    objectSelector?: StorageGcpUpboundIoV1beta1ObjectACLSpecForProviderObjectSelector


schema StorageGcpUpboundIoV1beta1ObjectACLSpecForProviderBucketRef:
    r"""
    Reference to a Bucket in storage to populate bucket.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    policy : StorageGcpUpboundIoV1beta1ObjectACLSpecForProviderBucketRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    policy?: StorageGcpUpboundIoV1beta1ObjectACLSpecForProviderBucketRefPolicy


schema StorageGcpUpboundIoV1beta1ObjectACLSpecForProviderBucketRefPolicy:
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


schema StorageGcpUpboundIoV1beta1ObjectACLSpecForProviderBucketSelector:
    r"""
    Selector for a Bucket in storage to populate bucket.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    policy : StorageGcpUpboundIoV1beta1ObjectACLSpecForProviderBucketSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    policy?: StorageGcpUpboundIoV1beta1ObjectACLSpecForProviderBucketSelectorPolicy


schema StorageGcpUpboundIoV1beta1ObjectACLSpecForProviderBucketSelectorPolicy:
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


schema StorageGcpUpboundIoV1beta1ObjectACLSpecForProviderObjectRef:
    r"""
    Reference to a BucketObject in storage to populate object.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    policy : StorageGcpUpboundIoV1beta1ObjectACLSpecForProviderObjectRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    policy?: StorageGcpUpboundIoV1beta1ObjectACLSpecForProviderObjectRefPolicy


schema StorageGcpUpboundIoV1beta1ObjectACLSpecForProviderObjectRefPolicy:
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


schema StorageGcpUpboundIoV1beta1ObjectACLSpecForProviderObjectSelector:
    r"""
    Selector for a BucketObject in storage to populate object.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    policy : StorageGcpUpboundIoV1beta1ObjectACLSpecForProviderObjectSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    policy?: StorageGcpUpboundIoV1beta1ObjectACLSpecForProviderObjectSelectorPolicy


schema StorageGcpUpboundIoV1beta1ObjectACLSpecForProviderObjectSelectorPolicy:
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


schema StorageGcpUpboundIoV1beta1ObjectACLSpecInitProvider:
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
        The name of the bucket the object is stored in.
    object : str, default is Undefined, optional
        The name of the object to apply the acl to.
    predefinedAcl : str, default is Undefined, optional
        The "canned" predefined ACL to apply. Must be set if role_entity is not.
    roleEntity : [str], default is Undefined, optional
        List of role/entity pairs in the form ROLE:entity. See GCS Object ACL documentation for more details.
        Must be set if predefined_acl is not.
    bucketRef : StorageGcpUpboundIoV1beta1ObjectACLSpecInitProviderBucketRef, default is Undefined, optional
        bucket ref
    bucketSelector : StorageGcpUpboundIoV1beta1ObjectACLSpecInitProviderBucketSelector, default is Undefined, optional
        bucket selector
    objectRef : StorageGcpUpboundIoV1beta1ObjectACLSpecInitProviderObjectRef, default is Undefined, optional
        object ref
    objectSelector : StorageGcpUpboundIoV1beta1ObjectACLSpecInitProviderObjectSelector, default is Undefined, optional
        object selector
    """


    bucket?: str

    object?: str

    predefinedAcl?: str

    roleEntity?: [str]

    bucketRef?: StorageGcpUpboundIoV1beta1ObjectACLSpecInitProviderBucketRef

    bucketSelector?: StorageGcpUpboundIoV1beta1ObjectACLSpecInitProviderBucketSelector

    objectRef?: StorageGcpUpboundIoV1beta1ObjectACLSpecInitProviderObjectRef

    objectSelector?: StorageGcpUpboundIoV1beta1ObjectACLSpecInitProviderObjectSelector


schema StorageGcpUpboundIoV1beta1ObjectACLSpecInitProviderBucketRef:
    r"""
    Reference to a Bucket in storage to populate bucket.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    policy : StorageGcpUpboundIoV1beta1ObjectACLSpecInitProviderBucketRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    policy?: StorageGcpUpboundIoV1beta1ObjectACLSpecInitProviderBucketRefPolicy


schema StorageGcpUpboundIoV1beta1ObjectACLSpecInitProviderBucketRefPolicy:
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


schema StorageGcpUpboundIoV1beta1ObjectACLSpecInitProviderBucketSelector:
    r"""
    Selector for a Bucket in storage to populate bucket.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    policy : StorageGcpUpboundIoV1beta1ObjectACLSpecInitProviderBucketSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    policy?: StorageGcpUpboundIoV1beta1ObjectACLSpecInitProviderBucketSelectorPolicy


schema StorageGcpUpboundIoV1beta1ObjectACLSpecInitProviderBucketSelectorPolicy:
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


schema StorageGcpUpboundIoV1beta1ObjectACLSpecInitProviderObjectRef:
    r"""
    Reference to a BucketObject in storage to populate object.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    policy : StorageGcpUpboundIoV1beta1ObjectACLSpecInitProviderObjectRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    policy?: StorageGcpUpboundIoV1beta1ObjectACLSpecInitProviderObjectRefPolicy


schema StorageGcpUpboundIoV1beta1ObjectACLSpecInitProviderObjectRefPolicy:
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


schema StorageGcpUpboundIoV1beta1ObjectACLSpecInitProviderObjectSelector:
    r"""
    Selector for a BucketObject in storage to populate object.

    Attributes
    ----------
    matchControllerRef : bool, default is Undefined, optional
        MatchControllerRef ensures an object with the same controller reference
        as the selecting object is selected.
    matchLabels : {str:str}, default is Undefined, optional
        MatchLabels ensures an object with matching labels is selected.
    policy : StorageGcpUpboundIoV1beta1ObjectACLSpecInitProviderObjectSelectorPolicy, default is Undefined, optional
        policy
    """


    matchControllerRef?: bool

    matchLabels?: {str:str}

    policy?: StorageGcpUpboundIoV1beta1ObjectACLSpecInitProviderObjectSelectorPolicy


schema StorageGcpUpboundIoV1beta1ObjectACLSpecInitProviderObjectSelectorPolicy:
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


schema StorageGcpUpboundIoV1beta1ObjectACLSpecProviderConfigRef:
    r"""
    ProviderConfigReference specifies how the provider that will be used to
    create, observe, update, and delete this managed resource should be
    configured.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the referenced object.
    policy : StorageGcpUpboundIoV1beta1ObjectACLSpecProviderConfigRefPolicy, default is Undefined, optional
        policy
    """


    name: str

    policy?: StorageGcpUpboundIoV1beta1ObjectACLSpecProviderConfigRefPolicy


schema StorageGcpUpboundIoV1beta1ObjectACLSpecProviderConfigRefPolicy:
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


schema StorageGcpUpboundIoV1beta1ObjectACLSpecWriteConnectionSecretToRef:
    r"""
    WriteConnectionSecretToReference specifies the namespace and name of a
    Secret to which any connection details for this managed resource should
    be written. Connection details frequently include the endpoint, username,
    and password required to connect to the managed resource.

    Attributes
    ----------
    name : str, default is Undefined, required
        Name of the secret.
    namespace : str, default is Undefined, required
        Namespace of the secret.
    """


    name: str

    namespace: str


schema StorageGcpUpboundIoV1beta1ObjectACLStatus:
    r"""
    ObjectACLStatus defines the observed state of ObjectACL.

    Attributes
    ----------
    conditions : [StorageGcpUpboundIoV1beta1ObjectACLStatusConditionsItems0], default is Undefined, optional
        Conditions of the resource.
    observedGeneration : int, default is Undefined, optional
        ObservedGeneration is the latest metadata.generation
        which resulted in either a ready state, or stalled due to error
        it can not recover from without human intervention.
    atProvider : StorageGcpUpboundIoV1beta1ObjectACLStatusAtProvider, default is Undefined, optional
        at provider
    """


    conditions?: [StorageGcpUpboundIoV1beta1ObjectACLStatusConditionsItems0]

    observedGeneration?: int

    atProvider?: StorageGcpUpboundIoV1beta1ObjectACLStatusAtProvider


schema StorageGcpUpboundIoV1beta1ObjectACLStatusAtProvider:
    r"""
    storage gcp upbound io v1beta1 object ACL status at provider

    Attributes
    ----------
    bucket : str, default is Undefined, optional
        The name of the bucket the object is stored in.
    id : str, default is Undefined, optional
        id
    object : str, default is Undefined, optional
        The name of the object to apply the acl to.
    predefinedAcl : str, default is Undefined, optional
        The "canned" predefined ACL to apply. Must be set if role_entity is not.
    roleEntity : [str], default is Undefined, optional
        List of role/entity pairs in the form ROLE:entity. See GCS Object ACL documentation for more details.
        Must be set if predefined_acl is not.
    """


    bucket?: str

    id?: str

    object?: str

    predefinedAcl?: str

    roleEntity?: [str]


schema StorageGcpUpboundIoV1beta1ObjectACLStatusConditionsItems0:
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



"""
This is the owner_reference module in k8s.apimachinery.pkg.apis.meta.v1 package.
This file was generated by the KCL auto-gen tool. DO NOT EDIT.
Editing this file might prove futile when you re-run the KCL auto-gen generate command.
"""


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



"""
This is the object_meta module in k8s.apimachinery.pkg.apis.meta.v1 package.
This file was generated by the KCL auto-gen tool. DO NOT EDIT.
Editing this file might prove futile when you re-run the KCL auto-gen generate command.
"""


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



"""
This is the managed_fields_entry module in k8s.apimachinery.pkg.apis.meta.v1 package.
This file was generated by the KCL auto-gen tool. DO NOT EDIT.
Editing this file might prove futile when you re-run the KCL auto-gen generate command.
"""


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
        _labels = vars["labels"] if "labels" in vars else {}
        _meta = vars["metadata"] if "metadata" in vars else {}
        _name = str(_meta["name"] if "name" in _meta else "")
        _namespace = str(vars["namespace"] if "namespace" in vars else "")
        _managementPolicies = vars["managementPolicies"] if "managementPolicies" in vars else ["*"]

        _init_cm = k8s_core.ConfigMap {
                apiVersion = "v1"
                kind = "ConfigMap"
            metadata = {
                labels = _labels
                name = "init-config"
                namespace = _namespace
            }
            data = {
                "PROJECT_ID": str(vars["projectId"] if "projectId" in vars else "")
                "REGION": str(vars["region"] if "region" in vars else "")
            }
        }

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

    items = {
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
            sa.ServiceAccount {
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
            sa_iam.ServiceAccountIAMMember {
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

        _security_items += [project_iam.ProjectIAMMember {
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

        _security_items += [project_iam.ProjectIAMMember {
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
                kms_keyring.KeyRing {
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
                kms_key.CryptoKey {
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
            _security_items += [kms_iam.CryptoKeyIAMMember {
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

    items = {"items": get_items(obs, _vars)}


_security = security_layer {}
items_security = _security.items

schema sql_layer:





    _get_items_impl = lambda obs: any, vars: {str:any} -> [any] {
        _db_spec = vars["database"] if "database" in vars else {}
        _env = vars["env"] if "env" in vars else {}
        _labels = vars["labels"] if "labels" in vars else {}
        _managementPolicies = vars["managementPolicies"] if "managementPolicies" in vars else ["*"]

        _items: [any] = [
            sql_instance.DatabaseInstance {
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
            sql_db.Database {
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
            sql_user.User {
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

    if option("combined", "false") != "true":
        items = {"items": get_items(obs, _vars)}


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
            gcp.Bucket {
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
            gcp_iam.BucketIAMMember {
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

    items = {"items": get_items(obs, _vars)}


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
            _items += [gcp.Bucket {
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

            _items += [gcp_iam.BucketIAMMember {
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

    items = {"items": get_items(obs, _vars)}


_overlay = overlay_layer {}
items_overlay = _overlay.items

schema k8s_layer:





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

    if not option("combined") or option("combined") == "false":
        items = {"items": get_items(obs, _vars)}


_k8s = k8s_layer {}
items_k8s = _k8s.items

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
            kubernetes.Object {
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
            kubernetes.Object {
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
            _items += [kubernetes.Object {
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

    items = {"items": get_items(obs, _vars) if not option("combined") or option("combined") == "false" else []}


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

            _backup_items += [storage_bucket.Bucket {
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

            _backup_items += [storage_iam.BucketIAMMember {
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
                kubernetes.Object {
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
                kubernetes.Object {
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

    items = {"items": get_items(obs, _vars)}


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
            kubernetes.Object {
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

    items = {"items": get_items(obs, _vars)}


_managed_service_details = managed_service_details_layer {}
items_managed_service_details = _managed_service_details.items

items = {"items": [item for layer in [items_init,items_security,items_sql,items_storage,items_overlay,items_k8s,items_elasticsearch,items_backup,items_managed_service_details] for item in layer.items]}
