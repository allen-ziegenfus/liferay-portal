locals {
	dummy_secret="AKIAIMsNsOsssJsVYsEsXssAKsEY"
}
resource "google_compute_firewall" "insecure_rule" {
	allow {
		ports=[
			"0-65535",
		]
		protocol="tcp"
	}
	name="insecure-firewall-test"
	network="default"
	priority=1000
	source_ranges=[
		"0.0.0.0/0",
	]
}
resource "google_storage_bucket" "insecure_bucket" {
	location="US"
	name="insecure-test-bucket-${var.deployment_name}"
	public_access_prevention="inherited"
}
resource "google_storage_bucket_iam_binding" "public_binding" {
	bucket=google_storage_bucket.insecure_bucket.name
	members=[
		"allUsers",
	]
	role="roles/storage.objectViewer"
}
variable "unused_test_variable" {
	default="trigger-tflint"
	type=string
}
# Trivial update to trigger Spacelift pipeline.
