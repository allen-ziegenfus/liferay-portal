resource "google_iam_workload_identity_pool" "github" {
	count=var.liferay_workspace_git_repo != "" ? 1 : 0
	project=var.project_id
	workload_identity_pool_id=local.github_workload_identity_pool_name
}
resource "google_iam_workload_identity_pool_provider" "github" {
	count=var.liferay_workspace_git_repo != "" ? 1 : 0
	attribute_condition="assertion.sub == 'repo:${var.liferay_workspace_git_repo}:ref:refs/heads/${var.liferay_workspace_git_repo_branch}'"
	attribute_mapping={
		"attribute.actor"="assertion.actor"
		"attribute.repository"="assertion.repository"
		"attribute.repository_owner"="assertion.repository_owner"
		"google.subject"="assertion.sub"
	}
	oidc {
		issuer_uri="https://token.actions.githubusercontent.com"
	}
	project=var.project_id
	workload_identity_pool_id=google_iam_workload_identity_pool.github[0].workload_identity_pool_id
	workload_identity_pool_provider_id="github-provider"
}
resource "google_project_iam_member" "workspace_overlay_bucket_admin" {
	count=var.liferay_workspace_git_repo != "" ? 1 : 0
	condition {
		expression="resource.name.matches('.*${local.overlay_bucket_suffix}(/.*)?')"
		title="Restrict to Overlay Buckets"
	}
	member="principalSet://iam.googleapis.com/projects/${data.google_project.project.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.github[0].workload_identity_pool_id}/attribute.repository/${var.liferay_workspace_git_repo}"
	project=var.project_id
	role="roles/storage.objectAdmin"
}
resource "random_id" "pool_suffix" {
	count=var.liferay_workspace_git_repo != "" ? 1 : 0
	byte_length=2
}
