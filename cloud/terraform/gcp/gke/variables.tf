variable "deployment_name" {
	type=string
	validation {
		condition=can(regex("^[a-z0-9-]*$", var.deployment_name))
		error_message="The deployment_name must contain only lowercase letters, numbers, and hyphens."
	}
}
variable "deployment_namespace" {
	default="liferay-system"
	validation {
		condition=can(regex("^[a-z0-9-]*$", var.deployment_namespace))
		error_message="The deployment_namespace must contain only lowercase letters, numbers, and hyphens."
	}
}
variable "gke_security_group" {
	default=null
	type=string
}
variable "machine_type" {
	default="e2-standard-4"
	type=string
}
variable "master_authorized_networks" {
	default=["10.0.0.0/16",]
	type=list(string)
}
variable "max_node_count" {
	default=3
	type=number
}
variable "min_node_count" {
	default=1
	type=number
}
variable "pod_cidr" {
	default="10.1.0.0/16"
	type=string
}
variable "project_id" {
	type=string
}
variable "region" {
	type=string
}
variable "regional_cluster" {
	default=true
	type=bool
}
variable "service_cidr" {
	default="10.2.0.0/16"
	type=string
}
variable "spot_instances" {
	default=false
	type=bool
}
variable "vpc_cidr" {
	default="10.0.0.0/16"
	type=string
}
