resource "google_service_account" "liferay_sa" {
	account_id="${var.deployment_name}-sa"
	display_name="Liferay workload service account"
	project=var.project_id
}
resource "google_service_account" "node_sa" {
	account_id="${var.deployment_name}-node-sa"
	display_name="gke node service account"
	project=var.project_id
}
resource "google_project_iam_member" "node_permissions" {
	for_each=toset([
		"roles/logging.logWriter",
		"roles/monitoring.metricWriter",
		"roles/artifactregistry.reader",
		"roles/gkehub.gatewayAdmin",
		"roles/gkehub.viewer",
	])
	member="serviceAccount:${google_service_account.node_sa.email}"
	project=var.project_id
	role=each.key
}
resource "google_service_account_iam_member" "liferay_wi_binding" {
	depends_on=[google_container_cluster.primary]
	member="serviceAccount:${var.project_id}.svc.id.goog[${var.deployment_namespace}/liferay-default]"
	role="roles/iam.workloadIdentityUser"
	service_account_id=google_service_account.liferay_sa.name
}
resource "google_container_cluster" "primary" {
	addons_config {
		gcs_fuse_csi_driver_config {
			enabled=true
		}
		horizontal_pod_autoscaling {
			disabled=false
		}
		http_load_balancing {
			disabled=true
		}
		network_policy_config {
			disabled=false
		}
	}
	dynamic "authenticator_groups_config" {
		for_each=var.gke_security_group!=null ? [1] : []
		content {
			security_group=var.gke_security_group
		}
	}
	binary_authorization {
		evaluation_mode="PROJECT_SINGLETON_POLICY_ENFORCE"
	}
	deletion_protection=false
	depends_on=[google_compute_subnetwork.subnet]
	enable_intranode_visibility=true
	initial_node_count=1
	ip_allocation_policy {
		cluster_secondary_range_name="${var.deployment_name}-pods"
		services_secondary_range_name="${var.deployment_name}-services"
	}
	location=var.regional_cluster ? var.region : "${var.region}-a"
	master_auth {
		client_certificate_config {
			issue_client_certificate=false
		}
	}
	master_authorized_networks_config {
		dynamic "cidr_blocks" {
			for_each=var.master_authorized_networks
			content {
				cidr_block=cidr_blocks.value
			}
		}
	}
	name="${var.deployment_name}-gke"
	network=google_compute_network.vpc.id
	network_policy {
		enabled=true
		provider="CALICO"
	}
	networking_mode="VPC_NATIVE"
	node_config {
		shielded_instance_config {
			enable_integrity_monitoring=true
			enable_secure_boot=true
		}
		workload_metadata_config {
			mode="GKE_METADATA"
		}
	}
	private_cluster_config {
		enable_private_endpoint=true
		enable_private_nodes=true
		master_global_access_config {
			enabled=false
		}
		master_ipv4_cidr_block="172.16.0.0/28"
	}
	project=var.project_id
	release_channel {
		channel="REGULAR"
	}
	remove_default_node_pool=true
	resource_labels={
		deployment_name=var.deployment_name
		managed_by="terraform"
	}
	subnetwork=google_compute_subnetwork.subnet.id
	workload_identity_config {
		workload_pool="${var.project_id}.svc.id.goog"
	}
}
resource "google_container_node_pool" "general_purpose" {
	cluster=google_container_cluster.primary.name
	location=var.regional_cluster ? var.region : "${var.region}-a"
	name="general-purpose"
	project=var.project_id
	autoscaling {
		max_node_count=var.max_node_count
		min_node_count=var.min_node_count
	}
	management {
		auto_repair=true
		auto_upgrade=true
	}
	node_config {
		disk_size_gb=100
		disk_type="pd-balanced"
		image_type="COS_CONTAINERD"
		machine_type=var.machine_type
		oauth_scopes=["https://www.googleapis.com/auth/cloud-platform",]
		preemptible=var.spot_instances
		service_account=google_service_account.node_sa.email
		shielded_instance_config {
			enable_integrity_monitoring=true
			enable_secure_boot=true
		}
		workload_metadata_config {
			mode="GKE_METADATA"
		}
	}
}
resource "google_gke_hub_membership" "membership" {
	endpoint {
		gke_cluster {
			resource_link="//container.googleapis.com/${google_container_cluster.primary.id}"
		}
	}
	membership_id="${var.deployment_name}-membership"
	project=var.project_id
}
resource "google_gke_hub_feature" "gateway" {
	location="global"
	name="connectgateway"
	project=var.project_id
}
