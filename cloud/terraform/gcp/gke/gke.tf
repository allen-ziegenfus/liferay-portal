resource "google_service_account" "liferay_sa" {
	account_id="${var.deployment_name}-sa"
	display_name="Liferay Workload Service Account"
	project=var.project_id
}
resource "google_service_account" "node_sa" {
	account_id="${var.deployment_name}-node-sa"
	display_name="GKE Node Service Account"
	project=var.project_id
}
resource "google_project_iam_member" "node_permissions" {
	for_each=toset([
		"roles/logging.logWriter",
		"roles/monitoring.metricWriter",
		"roles/artifactregistry.reader",
	])
	member="serviceAccount:${google_service_account.node_sa.email}"
	project=var.project_id
	role=each.key
}
resource "google_service_account_iam_member" "liferay_wi_binding" {
	depends_on=[module.gke]
	member="serviceAccount:${var.project_id}.svc.id.goog[${var.deployment_namespace}/liferay-default]"
	role="roles/iam.workloadIdentityUser"
	service_account_id=google_service_account.liferay_sa.name
}
module "gke" {
	source="git::https://github.com/terraform-google-modules/terraform-google-kubernetes-engine.git//modules/private-cluster?ref=6084668832a89345091a0f8b725287f39446d64d"
	depends_on=[google_compute_subnetwork.subnet]
	deletion_protection=false
	enable_private_endpoint=false
	enable_private_nodes=true
	gcs_fuse_csi_driver=true
	horizontal_pod_autoscaling=true
	http_load_balancing=var.http_load_balancing
	identity_namespace="enabled"
	initial_node_count=1
	ip_range_pods="${var.deployment_name}-pods"
	ip_range_services="${var.deployment_name}-services"
	master_authorized_networks=[
		{
			cidr_block=var.authorized_ipv4_cidr_block
			display_name="Authorized-Access"
		},
	]
	master_ipv4_cidr_block="172.16.0.0/28"
	name="${var.deployment_name}-gke"
	network=google_compute_network.vpc.name
	project_id=var.project_id
	region=var.region
	regional=var.regional_cluster
	remove_default_node_pool=true
	subnetwork=google_compute_subnetwork.subnet.name
	zones=var.regional_cluster ? [] : ["${var.region}-a"]
}
resource "google_container_node_pool" "general_purpose" {
	depends_on=[module.gke]
	cluster=module.gke.name
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
