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

output "type" {
  value = module.firestore.type
}

output "index_ids" {
  value = module.firestore.index_ids
}
