# ServiceAccount作成後にコンソールなどでKeyを生成し、GitHubのシークレットに登録する
resource "google_service_account" "gha" {
  account_id   = "github-actions"
  display_name = "GitHub Actions SA for Terraform"
  project      = var.project
}

resource "google_project_iam_member" "gha_storage" {
  project = var.project
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.gha.email}"
}

resource "google_project_iam_member" "gha_terraform" {
  project = var.project
  role    = "roles/editor"
  member  = "serviceAccount:${google_service_account.gha.email}"
}

resource "google_project_iam_member" "gha_secrets" {
  project = var.project
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.gha.email}"
}
