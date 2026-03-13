variable "authorized_ipv4_cidr_block" {
	default="0.0.0.0/0"
	type=string
}
variable "deployment_name" {
	type=string
}
variable "deployment_namespace" {
	default="liferay"
	type=string
}
variable "http_load_balancing" {
	default=true
	type=bool
}
variable "machine_type" {
	default="e2-standard-4"
	type=string
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
