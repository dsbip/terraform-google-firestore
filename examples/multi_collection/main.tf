provider "google" {
  project = "my-gcp-project"
}

module "firestore" {
  source      = "../../modules/firestore"
  config_file = "${path.module}/config.yaml"
}

output "database_name" {
  value = module.firestore.database_name
}

output "location" {
  value = module.firestore.location
}

output "index_ids" {
  value = module.firestore.index_ids
}

output "document_ids" {
  value = module.firestore.document_ids
}
