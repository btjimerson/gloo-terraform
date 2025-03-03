output "configure_kubectl_command" {
  value = [for cluster in google_container_cluster.cluster : "gcloud container clusters get-credentials ${cluster.name} --project ${var.project_id} --region ${var.region}"]
}